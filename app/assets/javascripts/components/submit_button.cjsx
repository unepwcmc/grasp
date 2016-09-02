QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")

module.exports = class SubmitButton extends React.Component
  render: =>
    <div>
      <input className="columns button button-primary" type="submit" value="Submit" onClick={@submitReport}/>
    </div>

  submitReport: =>
    QuestionnaireStore.submitReport()
