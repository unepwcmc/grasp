_ = require("underscore")
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

    allQuestions = page.questions.map( (questionId) ->
      question = questions[questionId]
      question.uniqueId = questionId
      question
    )

    visibleQuestions = allQuestions.filter( (question) => @isQuestionVisible(question))

    {
      id: page.id,
      title: page.title,
      multiple: page.multiple,
      questions: visibleQuestions,
      allQuestions: allQuestions
    }

  getPages:            -> pages
  getCurrentPageIndex: -> currentPageIndex
  isFirstPage:         -> currentPageIndex == 0
  isLastPage:          -> currentPageIndex == pages.length - 1


  tabIndexForPage: (pageIndex) -> tabsIndexesPerPage[pageIndex] || 0
  tabIndexForCurrentPage:      -> tabsIndexesPerPage[currentPageIndex] || 0

  selectTab: (i) ->
    tabsIndexesPerPage[currentPageIndex] = i
    @emit(TAB_CHANGE_EVENT)

  setPage: (i) =>
    return unless @isPageVisible(pages[i])
    currentPageIndex = i

    window.scrollTo(0, 0)
    @emit(PAGE_CHANGE_EVENT)

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
      parentQuestion = questions[question.show_if.question]

      if parentQuestion.type == "multi" and answers[page.id]?[tabIndex]?[question.show_if.question]?.selected
        question.show_if.answer in answers[page.id]?[tabIndex]?[question.show_if.question]?.selected
      else
        question.show_if.answer == answers[page.id]?[tabIndex]?[question.show_if.question]?.selected
    else
      parentQuestion = questions[question.show_if.question]

      if parentQuestion.type == "multi" and answers[question.show_if.question]?.selected
        question.show_if.answer in answers[question.show_if.question]?.selected
      else
        question.show_if.answer == answers[question.show_if.question]?.selected


  isPageVisible: (page) ->
    return true unless page.show_if

    QuestionnaireStore = require("stores/questionnaire_store")
    answers   = QuestionnaireStore.getAnswers()
    answers[page.show_if]?.selected?[page.id]

  updateAnswers: =>
    QuestionnaireStore = require("stores/questionnaire_store")
    answers = QuestionnaireStore.getAnswers()
    questions = QuestionnaireStore.getQuestions()

    tabIndex = @tabIndexForCurrentPage()
    page = pages[currentPageIndex]

    allQuestions = page.questions.map( (questionId) ->
      question = questions[questionId]
      question.uniqueId = questionId
      question
    )

    for key, question of allQuestions
      unless question.type == "multi"
        if page.multiple
          selected = answers[page.id]?[tabIndex]?[question.id]?.selected
          if question.answers? and selected not in @allAnswersForQuestion(allQuestions, question.id)
            QuestionnaireStore.nullAnswer(question.id, false)
        else
          if question.answers? and answers[question.id]?.selected not in @allAnswersForQuestion(allQuestions, question.id)
            QuestionnaireStore.nullAnswer(question.id, false)

  allAnswersForQuestion: (allQuestions, questionId) =>
    allAnswers = _.chain(allQuestions)
      .filter((question, _key) -> question.id == questionId)
      .filter((question, _key) => @isQuestionVisible(question))
      .map((question, _key) -> question.answers)
      .flatten()
      .compact()
      .value()

    allAnswers.push("other")
    allAnswers

  addPageChangeListener: (callback) => @on(PAGE_CHANGE_EVENT, callback)
  addTabChangeListener:  (callback) => @on(TAB_CHANGE_EVENT,  callback)

module.exports = new NavigationStore()
