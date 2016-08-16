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

  saveOrUpdateReport: (callback) =>
    if report.id?
      @reportRequest("/reports/#{report.id}", "PUT", (response) =>
        @setNotification("Report updated")
        callback?(response.headers.get('Location'))
      )
    else
      @reportRequest("/reports", "POST", (response) =>
        @setNotification("Report saved")
        response.json().then((json) -> report.id = json.id)

        callback?(response.headers.get('Location'))
      )

  reportRequest: (path, method, callback) ->
    token = document.getElementsByName("csrf-token")[0].content
    fetch(path, {
      method: method,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      },
      credentials: 'include',
      body: JSON.stringify({
        report: {data: {answers: report.answers, state: report.state}}
      })
    }).then(callback)


  setPath: (path) ->
    window.location = path

  setNotification: (msg) ->
    $notificationEl = $('.js-questionnaire-notification')
    $notificationEl.html(msg).fadeIn()

    setTimeout((-> $notificationEl.fadeOut()), 3000)

  submitReport: =>
    report.state = "submitted"

    @stopAutoSave()
    @saveOrUpdateReport("Report Submitted!", @setPath)

module.exports = new QuestionnaireStore()
