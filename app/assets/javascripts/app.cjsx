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
