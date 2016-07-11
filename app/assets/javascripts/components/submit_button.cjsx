QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")

module.exports = class SubmitButton extends React.Component
  render: =>
    <div className="submit-report">
      <input type="submit" value="Submit" onClick={@submitReport}/>
    </div>

  submitReport: =>
    QuestionnaireStore.submitReport()
