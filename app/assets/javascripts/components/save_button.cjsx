QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")

module.exports = class SaveButton extends React.Component
  render: =>
    <div>
      <input className="columns button button-primary" type="submit" value="Save Report" onClick={@saveReport}/>
    </div>

  saveReport: =>
    QuestionnaireStore.saveOrUpdateReport()
