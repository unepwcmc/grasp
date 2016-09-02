QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")

module.exports = class SubmitButton extends React.Component
  render: =>
    <input disabled={!@props.enabled} className="six columns button button-primary" type="submit" value="Submit" onClick={@submitReport}/>

  submitReport: =>
    QuestionnaireStore.submitReport()
