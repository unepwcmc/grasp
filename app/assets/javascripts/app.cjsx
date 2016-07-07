React    = require("react")
{render} = require("react-dom")
Questionnaire = require("components/questionnaire")
QuestionnaireStore = require("stores/questionnaire_store")

module.exports =
  start: ->
    if containerEl = document.getElementById("report-container")
      QuestionnaireStore.load(questionnaireJson, containerEl.getAttribute("data-report-id"))
      render(<Questionnaire/>, containerEl)
