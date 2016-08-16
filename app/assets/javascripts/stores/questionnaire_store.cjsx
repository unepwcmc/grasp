{EventEmitter} = require("events")
require('whatwg-fetch')

class QuestionnaireStore extends EventEmitter
  CHANGE_EVENT = "change"
  VISIBILITY_EVENT = "visibility"
  PAGE_CHANGE_EVENT = "page_change"

  reportId      = null
  questionnaireMode = null
  currentPage   = 0
  autoSaveTimer = null
  autoSaveInterval = 60000

  questionnaire = {}
  answers = {}
  state = null

  constructor: ->
    state = "in_progress"
    @on(PAGE_CHANGE_EVENT, @saveOrUpdateReport)

  startAutoSave: ->
    autoSaveTimer = setInterval(@saveOrUpdateReport, autoSaveInterval)

  stopAutoSave: ->
    clearInterval(autoSaveTimer) if autoSaveTimer

  currentPage: ->
    currentPage

  previousPage: ->
    currentPage -= 1
    window.scrollTo(0, 0)
    @emit(CHANGE_EVENT)
    @emit(PAGE_CHANGE_EVENT)

  nextPage: ->
    currentPage += 1
    window.scrollTo(0, 0)
    @emit(CHANGE_EVENT)
    @emit(PAGE_CHANGE_EVENT)

  load: (data, id) ->
    reportId = id if id?
    questionnaire = data

  setMode: (mode) -> questionnaireMode = mode
  getMode: -> questionnaireMode

  getAnswers: -> answers

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

      if required and answers[question.id]?.selected == ""
        allAnswered = false
    allAnswered

  selectAnswer: (key, answer) ->
    answers[key] ||= {}
    answers[key].selected = answer
    @emit(CHANGE_EVENT)

  updateOtherAnswer: (key, text) ->
    answers[key] ||= {}
    answers[key].other_answer = text
    @emit(CHANGE_EVENT)

  addAnswer: (key, answer) ->
    answers[key] ||= {}
    answers[key].selected ||= []
    answers[key].selected.push(answer)
    @emit(CHANGE_EVENT)

  removeAnswer: (key, answer) ->
    answers[key] ||= {}
    answers[key].selected = (answers[key].selected || []).filter(word -> word isnt answer)
    @emit(CHANGE_EVENT)

  show: (key) =>
    questionnaire.questions[key].visible = true
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
    if reportId? then @updateReport("Report updated", callback) else @saveReport("Report saved", callback)

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
        report: {data: {answers: answers, state: state}}
      })
    }).then((response) =>
      @setNotification(msg) if msg
      response.json().then((json) -> reportId = json.id)

      callback(response.headers.get('Location')) if callback
    )

  updateReport: (msg, callback) =>
    token = document.getElementsByName("csrf-token")[0].content
    fetch("/reports/#{reportId}", {
      method: 'PUT',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      },
      credentials: 'include',
      body: JSON.stringify({
        report: {data: {answers: answers, state: state}}
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
    @stopAutoSave()
    questionnaire.state = "submitted"
    @saveOrUpdateReport("Report Submitted!", @setPath)

module.exports = new QuestionnaireStore()
