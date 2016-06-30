{EventEmitter} = require("events")

class QuestionnaireStore extends EventEmitter
  EVENT = "change"
  questionnaire = {}

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

  addChangeListener: (callback) =>
    @on(EVENT, callback)

  selectAnswer: (key, answer) ->
    questionnaire.questions[key].selected = answer
    @emit(EVENT)

  hide: (key) =>
    questionnaire.questions[key].visible = false
    @emit(EVENT)

  show: (key) =>
    questionnaire.questions[key].visible = true
    @emit(EVENT)

  fetch: (key) ->
    questionnaire.questions[key]

module.exports = new QuestionnaireStore()
