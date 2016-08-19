{EventEmitter} = require("events")

class NavigationStore extends EventEmitter
  PAGE_CHANGE_EVENT = "page_change"
  TAB_CHANGE_EVENT  = "tab_change"

  currentPageIndex = 0
  tabsIndexesPerPage = []
  pages = {}

  loadPages: (sourcePages) ->
    pages = sourcePages

  currentPage: =>
    QuestionnaireStore = require("stores/questionnaire_store")
    questions = QuestionnaireStore.getQuestions()
    page = pages[currentPageIndex]

    visibleQuestions = page.questions.filter( (questionId) =>
      @isQuestionVisible(questions[questionId])
    ).map( (questionId) ->
      question = questions[questionId]
      question.uniqueId = questionId
      question
    )

    {
      id: page.id,
      title: page.title,
      multiple: page.multiple,
      questions: visibleQuestions
    }

  getPages:    -> pages
  isFirstPage: -> currentPageIndex == 0
  isLastPage:  -> currentPageIndex == pages.length - 1

  tabIndexForPage: (pageIndex) -> tabsIndexesPerPage[pageIndex] || 0
  tabIndexForCurrentPage:      -> tabsIndexesPerPage[currentPageIndex] || 0

  selectTab: (i) ->
    tabsIndexesPerPage[currentPageIndex] = i
    @emit(TAB_CHANGE_EVENT)

  previousPage: =>
    currentPageIndex -= 1
    currentPageIndex -= 1 until @isPageVisible(pages[currentPageIndex])

    window.scrollTo(0, 0)
    @emit(PAGE_CHANGE_EVENT)

  nextPage: =>
    currentPageIndex += 1
    currentPageIndex += 1 until @isPageVisible(pages[currentPageIndex])

    window.scrollTo(0, 0)
    @emit(PAGE_CHANGE_EVENT)

  isQuestionVisible: (question, page=pages[currentPageIndex], tabIndex=@tabIndexForCurrentPage()) =>
    return true unless question.show_if

    QuestionnaireStore = require("stores/questionnaire_store")
    answers   = QuestionnaireStore.getAnswers()
    questions = QuestionnaireStore.getQuestions()

    if page.multiple
      answers[page.id]?[tabIndex]?[question.show_if.question]?.selected == question.show_if.answer
    else
      answers[question.show_if.question]?.selected == question.show_if.answer


  isPageVisible: (page) ->
    return true unless page.show_if

    QuestionnaireStore = require("stores/questionnaire_store")
    answers   = QuestionnaireStore.getAnswers()
    answers[page.show_if]?.selected?[page.id]

  addPageChangeListener: (callback) => @on(PAGE_CHANGE_EVENT, callback)
  addTabChangeListener:  (callback) => @on(TAB_CHANGE_EVENT,  callback)

module.exports = new NavigationStore()
