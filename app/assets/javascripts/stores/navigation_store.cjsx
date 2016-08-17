{EventEmitter} = require("events")

class NavigationStore extends EventEmitter
  PAGE_CHANGE_EVENT = "page_change"
  TAB_CHANGE_EVENT  = "tab_change"

  currentPage = 0
  tabsIndexesPerPage = []
  pages = {}

  loadPages: (sourcePages) ->
    pages = sourcePages

  allPages: ->
    QuestionnaireStore = require("stores/questionnaire_store")
    questions = QuestionnaireStore.getQuestions()

    pages.map( (page) ->
      visibleQuestions = page.questions.filter( (question_id) ->
        questions[question_id].visible
      ).map( (question_id) ->
        questions[question_id]
      )

      {
        id: page.id,
        title: page.title,
        multiple: page.multiple,
        questions: visibleQuestions
      }
    )

  currentPage:       -> currentPage
  tabForCurrentPage: -> tabsIndexesPerPage[currentPage] || 0

  selectTab: (i) ->
    tabsIndexesPerPage[currentPage] = i
    @emit(TAB_CHANGE_EVENT)

  previousPage: =>
    currentPage -= 1
    currentPage -= 1 until @isVisible(pages[currentPage])

    window.scrollTo(0, 0)
    @emit(PAGE_CHANGE_EVENT)

  nextPage: =>
    currentPage += 1
    currentPage += 1 until @isVisible(pages[currentPage])

    window.scrollTo(0, 0)
    @emit(PAGE_CHANGE_EVENT)

  isVisible: (page) ->
    return true unless page.show_if
    QuestionnaireStore = require("stores/questionnaire_store")
    answers   = QuestionnaireStore.getAnswers()
    answers[page.show_if]?.selected?[page.id]

  addPageChangeListener: (callback) => @on(PAGE_CHANGE_EVENT, callback)
  addTabChangeListener:  (callback) => @on(TAB_CHANGE_EVENT,  callback)

module.exports = new NavigationStore()
