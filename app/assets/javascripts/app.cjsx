React    = require("react")
{render} = require("react-dom")
Questionnaire = require("components/questionnaire")
QuestionnaireStore = require("stores/questionnaire_store")

module.exports =
  start: ->
    QuestionnaireStore.load(questionnaire_json)

    render(
      <Questionnaire/>,
      document.getElementById("container")
    );
