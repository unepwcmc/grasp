{EventEmitter} = require("events")
require('whatwg-fetch')

class QuestionnaireStore extends EventEmitter
  CHANGE_EVENT = "change"
  VISIBILITY_EVENT = "visibility"
  PAGE_CHANGE_EVENT = "page_change"

  reportId      = null
  currentPage   = 0
  questionnaire = {}

  constructor: ->
    @on(PAGE_CHANGE_EVENT, @saveOrUpdateReport)

  currentPage: ->
    currentPage

  previousPage: ->
    currentPage -= 1
    @emit(CHANGE_EVENT)
    @emit(PAGE_CHANGE_EVENT)

  nextPage: ->
    currentPage += 1
    @emit(CHANGE_EVENT)
    @emit(PAGE_CHANGE_EVENT)

  load: (data) ->
    questionnaire = data

  allVisible: ->
    questionnaire.pages.map( (page) ->
      page.filter( (question_id) ->
        questionnaire.questions[question_id].visible
      ).map( (question_id) ->
        questionnaire.questions[question_id]
      )
    )

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

  saveOrUpdateReport: =>
    if reportId? then @updateReport() else @saveReport()

  saveReport: =>
    token = document.getElementsByName("csrf-token")[0].content
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
      response.json().then((json) ->
        reportId = json.id
      )
    )

  updateReport: =>
    token = document.getElementsByName("csrf-token")[0].content
    fetch("/reports/#{reportId}", {
      method: 'PUT',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      },
      credentials: 'include',
      body: JSON.stringify({ report: { data: questionnaire }})
    })

  submitReport: =>
    alert("Report marked as submitted")

module.exports = new QuestionnaireStore()
