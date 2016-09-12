QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")

module.exports = class SaveButton extends React.Component
  render: =>
    <input className="six columns button button-primary button--larger" type="submit" value="Save Report" onClick={@saveReport}/>

  saveReport: =>
    QuestionnaireStore.saveOrUpdateReport()
