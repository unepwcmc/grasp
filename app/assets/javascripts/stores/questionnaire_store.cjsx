{EventEmitter} = require("events")

class QuestionnaireStore extends EventEmitter
  CHANGE_EVENT = "change"
  VISIBILITY_EVENT = "visibility"

  currentPage   = 0
  questionnaire = {}

  currentPage: ->
    currentPage

  previousPage: ->
    currentPage -= 1
    window.scrollTo(0, 0)
    @emit(CHANGE_EVENT)

  nextPage: ->
    currentPage += 1
    window.scrollTo(0, 0)
    @emit(CHANGE_EVENT)

  load: (data) ->
    questionnaire = data

  allPages: ->
    questionnaire.pages.map( (page) ->
      visibleQuestions = page.questions.filter( (question_id) ->
        questionnaire.questions[question_id].visible
      ).map( (question_id) ->
        questionnaire.questions[question_id]
      )

      {title: page.title, questions: visibleQuestions}
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

module.exports = new QuestionnaireStore()
