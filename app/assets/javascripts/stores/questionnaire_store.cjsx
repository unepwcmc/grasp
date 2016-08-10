{EventEmitter} = require("events")
require('whatwg-fetch')

class QuestionnaireStore extends EventEmitter
  CHANGE_EVENT = "change"
  VISIBILITY_EVENT = "visibility"
  PAGE_CHANGE_EVENT = "page_change"

  reportId      = null
  questionnaireMode = null
  currentPage   = 0
  questionnaire = {}
  autoSaveTimer = null
  autoSaveInterval = 60000

  constructor: ->
    @on(PAGE_CHANGE_EVENT, @saveOrUpdateReport)
    #@startAutoSave()

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
  getMode: (mode) -> questionnaireMode

  allPages: ->
    questionnaire.pages.map( (page) ->
      visibleQuestions = page.questions.filter( (question_id) ->
        questionnaire.questions[question_id].visible
      ).map( (question_id) ->
        question = questionnaire.questions[question_id]
        question.id = question_id
        question
      )

      {title: page.title, questions: visibleQuestions}
    )

  requiredQuestionsAnswered: ->
    allAnswered = true
    for key, question of questionnaire.questions
      required = question.visible and question.required

      if required and (question.selected == "" or 'selected' not of question)
        allAnswered = false
    allAnswered

  selectAnswer: (key, answer) ->
    questionnaire.questions[key].selected = answer
    @emit(CHANGE_EVENT)

  updateOtherAnswer: (key, text) ->
    questionnaire.questions[key].other_answer = text
    @emit(CHANGE_EVENT)

  addAnswer: (key, answer) ->
    questionnaire.questions[key].selected ||= []
    questionnaire.questions[key].selected.push(answer)
    @emit(CHANGE_EVENT)

  removeAnswer: (key, answer) ->
    questionnaire.questions[key].selected = (
      questionnaire.questions[key].selected || []
    ).filter (word) -> word isnt answer

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
    store = @
    fetch('/reports', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      },
      credentials: 'include',
      body: JSON.stringify({ report: { data: questionnaire }})
    }).then((response) ->
      if msg
        store.setNotification(msg)
      if callback
        callback(response.headers.get('Location'))
      response.json().then((json) ->
        reportId = json.id
      )
    )

  updateReport: (msg, callback) =>
    token = document.getElementsByName("csrf-token")[0].content
    store = @
    fetch("/reports/#{reportId}", {
      method: 'PUT',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      },
      credentials: 'include',
      body: JSON.stringify({ report: { data: questionnaire }})
    }).then((response) ->
      if msg
        store.setNotification(msg)
      if callback
        callback(response.headers.get('Location'))
    )

  setPath: (path) =>
    window.location = path

  setNotification: (msg) =>
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
