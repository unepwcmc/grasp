QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")

module.exports = class SaveButton extends React.Component
  render: =>
    <div className="save-report">
      <input type="submit" value="Save Report" onClick={@saveReport}/>
    </div>

  saveReport: =>
    QuestionnaireStore.saveOrUpdateReport()
