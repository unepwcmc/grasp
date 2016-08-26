React    = require("react")
{render} = require("react-dom")
Questionnaire = require("components/questionnaire")
QuestionnaireStore = require("stores/questionnaire_store")

module.exports =
  start: ->
    if containerEl = document.getElementById("report-container")
      QuestionnaireStore.setMode(containerEl.getAttribute("data-report-mode"))
      QuestionnaireStore.initializeQuestionnaire(questionnaireTemplate)

      render(<Questionnaire/>, containerEl, ->
        if reportData?
          QuestionnaireStore.loadReportData(containerEl.getAttribute("data-report-id"), reportData)
      )

    $(".select2").select2(tags: true, width: "100%")

    $(".validation__info").click( ->
      $(@).parent().find(".validation__comments").slideToggle()
      $(@).find('i').toggleClass("fa-chevron-up fa-chevron-down")
    )

    $(".header__menu-button").click( ->
      $('.header__main-nav').slideToggle()
      $('.header__lower').slideToggle()
    )

    setTimeout (->
      $('.alert').slideUp()
      return
    ), 10000

    $('.alert').click(->
      $(this).slideUp()
    )

    if ($validationEl = $(".js-validating")).length > 0
      reportId = $validationEl.data("report")

      setInterval(@validationLock, 10000, reportId)
      @validationLock(reportId)

  validationLock: (reportId) ->
    token = document.getElementsByName("csrf-token")[0].content
    fetch("/reports/#{reportId}/lock", {
      method: "GET",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        'X-CSRF-Token': token
      }, credentials: 'include'
    })
