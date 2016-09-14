React    = require("react")
{render} = require("react-dom")
Questionnaire = require("components/questionnaire")
NavigationControls = require("components/navigation_controls")
QuestionnaireStore = require("stores/questionnaire_store")

# modules
UserFormHandler = require("modules/user_form_handler")

module.exports =
  start: ->
    if questionnaireEl = document.getElementById("report-container")
      QuestionnaireStore.setMode(questionnaireEl.getAttribute("data-report-mode"))
      QuestionnaireStore.initializeQuestionnaire(questionnaireTemplate)

      render(<Questionnaire/>, questionnaireEl, ->
        if reportData?
          QuestionnaireStore.loadReportData(questionnaireEl.getAttribute("data-report-id"), reportData)
      )

      render(<NavigationControls/>, document.getElementById("navigation"))

    $(".select2").select2(
      tags: true,
      width: "100%",
      templateSelection: @select2Formatting,
      templateResult: @select2Formatting
    )

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

    UserFormHandler.initialize()

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

  select2Formatting: (data, container) ->
    if matches = data.text.match(/(.*) \((.*)\)/)
      $("<span>#{matches[1]} <em>(#{matches[2]})</em></span>")
    else
      data.text
