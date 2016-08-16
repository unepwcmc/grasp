{EventEmitter} = require("events")
NavigationStore = require("stores/navigation_store")
require("whatwg-fetch")

class QuestionnaireStore extends EventEmitter
  CHANGE_EVENT = "change"
  VISIBILITY_EVENT = "visibility"

  questionnaireMode = null
  autoSaveTimer = null
  autoSaveInterval = 60000

  questionnaire = {}

  # Report's default values, get overwritten by loadReportData,
  # if data-report-id attr is found in the report-container HTML element
  report = {
    id: null,
    answers: {},
    state: "in_progress"
  }

  constructor: ->
    NavigationStore.addPageChangeListener(@saveOrUpdateReport)

  initializeQuestionnaire: (questionnaireTemplate) ->
    questionnaire = questionnaireTemplate

  loadReportData: (id, data) =>
    report.id = id
    report.answers = data.answers
    report.state = data.state

    @emit(CHANGE_EVENT)
    @show(key) for key, _answer of report.answers

  startAutoSave: ->
    autoSaveTimer = setInterval(@saveOrUpdateReport, autoSaveInterval)

  stopAutoSave: ->
    clearInterval(autoSaveTimer) if autoSaveTimer

  setMode: (mode) -> questionnaireMode = mode
  getMode: -> questionnaireMode

  getAnswers: -> report.answers

  allPages: ->
    questionnaire.pages.map( (page) ->
      visibleQuestions = page.questions.filter( (question_id) ->
        questionnaire.questions[question_id].visible
      ).map( (question_id) ->
        questionnaire.questions[question_id]
      )

      {title: page.title, questions: visibleQuestions}
    )

  requiredQuestionsAnswered: ->
    allAnswered = true
    for _key, question of questionnaire.questions
      required = question.visible and question.required

      if required and report.answers[question.id]?.selected == ""
        allAnswered = false
    allAnswered

  selectAnswer: (key, answer) ->
    report.answers[key] ||= {}
    report.answers[key].selected = answer
    @emit(CHANGE_EVENT)

  updateOtherAnswer: (key, text) ->
    report.answers[key] ||= {}
    report.answers[key].other_answer = text
    @emit(CHANGE_EVENT)

  addAnswer: (key, answer) ->
    report.answers[key] ||= {}
    report.answers[key].selected ||= []
    report.answers[key].selected.push(answer)
    @emit(CHANGE_EVENT)

  removeAnswer: (key, answer) ->
    report.answers[key] ||= {}
    report.answers[key].selected = (report.answers[key].selected || []).filter(word -> word isnt answer)
    @emit(CHANGE_EVENT)

  show: (key) =>
    questionnaire.questions[key]?.visible = true
    @emit(CHANGE_EVENT)
    @emit(VISIBILITY_EVENT, key, "show")

  hide: (key) =>
    questionnaire.questions[key].visible = false
    @emit(CHANGE_EVENT)
    @emit(VISIBILITY_EVENT, key, "hide")

  addChangeListener: (callback) =>
    @on(CHANGE_EVENT, callback)

  addVisibilityListener: (callback) =>
    @on(VISIBILITY_EVENT, callback)

  saveOrUpdateReport: (msg, callback) =>
    if report.id? then @updateReport("Report updated", callback) else @saveReport("Report saved", callback)

  saveReport: (msg, callback) =>
    token = document.getElementsByName("csrf-token")[0].content
    fetch('/reports', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      },
      credentials: 'include',
      body: JSON.stringify({
        report: {data: {answers: report.answers, state: report.state}}
      })
    }).then((response) =>
      @setNotification(msg) if msg
      response.json().then((json) -> report.id = json.id)

      callback(response.headers.get('Location')) if callback
    )

  updateReport: (msg, callback) =>
    token = document.getElementsByName("csrf-token")[0].content
    fetch("/reports/#{report.id}", {
      method: 'PUT',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      },
      credentials: 'include',
      body: JSON.stringify({
        report: {data: {answers: report.answers, state: report.state}}
      })
    }).then((response) =>
      @setNotification(msg) if msg
      callback(response.headers.get('Location')) if callback
    )

  setPath: (path) ->
    window.location = path

  setNotification: (msg) ->
    notifications     = document.getElementsByClassName("questionnaire__notification")
    for notification in notifications
      notification.style.display = 'none'

    nav               = document.getElementsByClassName("navigation__inner")[0]
    notice            = document.createElement("h5")
    notice.className  = 'questionnaire__notification'
    notice.innerHTML  = msg
    nav.appendChild(notice)

  submitReport: =>
    report.state = "submitted"

    @stopAutoSave()
    @saveOrUpdateReport("Report Submitted!", @setPath)

module.exports = new QuestionnaireStore()
