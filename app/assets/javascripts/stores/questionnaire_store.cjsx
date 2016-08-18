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
    questionnaire = questionnaireTemplate.questions
    NavigationStore.loadPages(questionnaireTemplate.pages)

  loadReportData: (id, data) =>
    report.id = id
    report.answers = data.answers
    report.state = data.state
    @emit(CHANGE_EVENT)

  startAutoSave: ->
    autoSaveTimer = setInterval(@saveOrUpdateReport, autoSaveInterval)

  stopAutoSave: ->
    clearInterval(autoSaveTimer) if autoSaveTimer

  allQuestionIds: -> questionnaire.map( (el) -> el.id )

  setMode: (mode) -> questionnaireMode = mode
  getMode: -> questionnaireMode

  getAnswers:   -> report.answers
  getQuestions: -> questionnaire

  requiredQuestionsAnswered: ->
    allAnswered = true

    for page, pageIndex in NavigationStore.getPages() when NavigationStore.isPageVisible(page)
      for questionId in page.questions
        question = questionnaire[questionId]

        if page.multiple
          answersForPage = report.answers[page.id]

          if answersForPage
            for answersInTab, tabIndex in answersForPage
              if question.required and NavigationStore.isQuestionVisible(question, page, tabIndex)
                if answersInTab[question.id] is undefined or answersInTab[question.id]?.selected == ""
                  console.log("question #{question.id} not answered")
                  allAnswered = false
          else
            allAnswered = false if question.required

        else
          if question.required and NavigationStore.isQuestionVisible(question, page)
            if report.answers[question.id] is undefined or report.answers[question.id]?.selected == ""
              console.log("question #{question.id} not answered")
              console.log(report.answers)
              allAnswered = false

    allAnswered

  selectAnswer: (key, answer) ->
    currentPage = NavigationStore.currentPage()
    tabIndex = NavigationStore.tabIndexForCurrentPage()

    if currentPage.multiple
      report.answers[currentPage.id] ||= []
      report.answers[currentPage.id][tabIndex] ||= {}
      report.answers[currentPage.id][tabIndex][key] ||= {}
      report.answers[currentPage.id][tabIndex][key].selected = answer
    else
      report.answers[key] ||= {}
      report.answers[key].selected = answer
    @emit(CHANGE_EVENT)

  nullAnswer: (key, fireChange=true) ->
    currentPage = NavigationStore.currentPage()
    tabIndex = NavigationStore.tabIndexForCurrentPage()

    if currentPage.multiple
      delete report.answers[currentPage.id]?[tabIndex]?[key]
    else
      delete report.answers[key]

    @emit(CHANGE_EVENT) if fireChange

  updateOtherAnswer: (key, text) ->
    report.answers[key] ||= {}
    report.answers[key].other_answer = text
    @emit(CHANGE_EVENT)

  addAnswer: (key, answer) ->
    currentPage = NavigationStore.currentPage()
    tabIndex = NavigationStore.tabIndexForCurrentPage()

    if currentPage.multiple
      report.answers[currentPage.id] ||= []
      report.answers[currentPage.id][tabIndex] ||= {}
      report.answers[currentPage.id][tabIndex][key] ||= {}
      report.answers[currentPage.id][tabIndex][key].selected ||= []
      report.answers[currentPage.id][tabIndex][key].selected.push(answer)
    else
      report.answers[key] ||= {}
      report.answers[key].selected ||= []
      report.answers[key].selected.push(answer)
    @emit(CHANGE_EVENT)

  removeAnswer: (key, answer) ->
    currentPage = NavigationStore.currentPage()
    tabIndex = NavigationStore.tabIndexForCurrentPage()

    if currentPage.multiple
      report.answers[currentPage.id] ||= []
      report.answers[currentPage.id][tabIndex] ||= {}
      report.answers[currentPage.id][tabIndex][key] ||= {}
      report.answers[currentPage.id][tabIndex][key].selected = (report.answers[currentPage.id][tabIndex][key].selected || []).filter(word -> word isnt answer)
    else
      report.answers[key] ||= {}
      report.answers[key].selected = (report.answers[key].selected || []).filter(word -> word isnt answer)
    @emit(CHANGE_EVENT)

  addChangeListener:     (callback) => @on(CHANGE_EVENT,     callback)
  addVisibilityListener: (callback) => @on(VISIBILITY_EVENT, callback)

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
