{EventEmitter} = require("events")

class QuestionnaireStore extends EventEmitter
  EVENT = "change"
  currentPage   = 0
  questionnaire = {}

  currentPage: ->
    currentPage

  previousPage: ->
    currentPage -= 1
    @emit(EVENT)

  nextPage: ->
    currentPage += 1
    @emit(EVENT)

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
    @emit(EVENT)

  addFile: (key, file) ->
    questionnaire.questions[key].selected ||= []
    questionnaire.questions[key].selected.push(file)
    @emit(EVENT)

  deleteFile: (key, fileIndex) ->
    questionnaire.questions[key].selected ||= []
    questionnaire.questions[key].selected.splice(fileIndex, 1)
    @emit(EVENT)

  show: (key) =>
    questionnaire.questions[key].visible = true
    @emit(EVENT)

  hide: (key) =>
    questionnaire.questions[key].visible = false
    @emit(EVENT)

  addChangeListener: (callback) =>
    @on(EVENT, callback)

  saveAll: =>
    console.dir(questionnaire)
    # Use fetch here to make ajax request to post data to report model

module.exports = new QuestionnaireStore()
