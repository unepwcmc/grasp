_ = require("underscore")
async = require("async")
{EventEmitter} = require("events")
NavigationStore = require("stores/navigation_store")
ImageStore = require("stores/image_store")
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
    state: "in_progress",
    genera: {},
    images: {}
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
    return if questionnaireMode == "show"
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
                  allAnswered = false
          else
            allAnswered = false if question.required

        else
          if question.required and NavigationStore.isQuestionVisible(question, page)
            if report.answers[question.id] is undefined or report.answers[question.id]?.selected == ""
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

  selectPart: (key, part, answer) ->
    report.answers[key] ||= {}
    report.answers[key].parts ||= {}
    report.answers[key].parts[part] ||= {}
    report.answers[key].parts[part].selected = answer
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
    currentPage = NavigationStore.currentPage()
    tabIndex = NavigationStore.tabIndexForCurrentPage()

    if currentPage.multiple
      report.answers[currentPage.id] ||= []
      report.answers[currentPage.id][tabIndex] ||= {}
      report.answers[currentPage.id][tabIndex][key] ||= {}
      report.answers[currentPage.id][tabIndex][key].other_answer = text
    else
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
      report.answers[currentPage.id][tabIndex][key].selected = (report.answers[currentPage.id][tabIndex][key].selected || []).filter((word) -> word isnt answer)
    else
      report.answers[key] ||= {}
      report.answers[key].selected = (report.answers[key].selected || []).filter((word) -> word isnt answer)
    @emit(CHANGE_EVENT)

  confirmDna: (key) ->
    currentPage = NavigationStore.currentPage()
    tabIndex = NavigationStore.tabIndexForCurrentPage()

    if currentPage.multiple
      report.answers[currentPage.id] ||= []
      report.answers[currentPage.id][tabIndex] ||= {}
      report.answers[currentPage.id][tabIndex][key] ||= {}
      report.answers[currentPage.id][tabIndex][key].dna_confirmation = true
    else
      report.answers[key] ||= {}
      report.answers[key].dna_confirmation = true
    @emit(CHANGE_EVENT)

  removeDnaConfirmation: (key) ->
    currentPage = NavigationStore.currentPage()
    tabIndex = NavigationStore.tabIndexForCurrentPage()

    if currentPage.multiple
      report.answers[currentPage.id] ||= []
      report.answers[currentPage.id][tabIndex] ||= {}
      report.answers[currentPage.id][tabIndex][key] ||= {}
      report.answers[currentPage.id][tabIndex][key].dna_confirmation = false
    else
      report.answers[key] ||= {}
      report.answers[key].dna_confirmation = false
    @emit(CHANGE_EVENT)


  addChangeListener:     (callback) => @on(CHANGE_EVENT,     callback)
  addVisibilityListener: (callback) => @on(VISIBILITY_EVENT, callback)

  saveOrUpdateReport: (callback) =>
    return if questionnaireMode == "show"
    @storeGenera()

    if report.id?
      @reportRequest("/reports/#{report.id}", "PUT", (response) =>
        @setNotification("success", "Report updated")
        ImageStore.storeImages(report, (newReport) =>
          report = newReport
          callback?(response.headers.get('Location'))
        )
      )
    else
      @reportRequest("/reports", "POST", (response) =>
        @setNotification("success", "Report saved")

        response.json().then((json) =>
          report.id = json.id
          ImageStore.storeImages(report, (newReport) =>
            report = newReport
            callback?(response.headers.get('Location'))
          )
        )
      )

  storeGenera: ->
    genera = {
      live: [],
      dead: [],
      parts: report.answers?.genus_parts?.selected || []
    }

    for ape in (report.answers?.live || []) when ape.genus_live?.selected
      if genera.live.indexOf(ape.genus_live.selected) == -1
        genera.live.push(ape.genus_live.selected)

    for ape in (report.answers?.dead || []) when ape.genus_dead?.selected
      if genera.dead.indexOf(ape.genus_dead.selected) == -1
        genera.dead.push(ape.genus_dead.selected)

    report.genera = genera

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
        report: {data: {genera: report.genera, answers: report.answers, state: report.state}}
      })
    }).then(callback)

  setPath: (path) ->
    window.location = path

  setNotification: (key, msg) ->
    title_icon = switch key
                    when "success" then "check"
                    when "error" then "times-circle"
                    else "info-circle"
    title = key.charAt(0).toUpperCase() + key.slice(1)

    $notificationEl = $('.js-questionnaire-notification')
    $notificationEl.empty()
    $notificationEl.append(
      $('<div class="alert alert-' + key + '"></div>').append(
        $('<p class="alert__close"><i class="fa fa-close"></i> Close</p>')
      ).append(
        $('<h4 class="alert__title"><i class="fa fa-' + title_icon + '"></i> ' + title + '</h4>')
      ).append(
        $('<p class="alert__body">' + msg + '</p>')
        )
      )

    $notificationEl.fadeIn()
    setTimeout((-> $notificationEl.fadeOut()), 10000)
    $notificationEl.click(->
      $(this).hide()
    )

  submitReport: =>
    return if questionnaireMode == "show"
    report.state = "submitted"

    @stopAutoSave()
    @saveOrUpdateReport(@setPath)

module.exports = new QuestionnaireStore()
