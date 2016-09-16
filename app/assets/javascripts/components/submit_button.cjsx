QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")

module.exports = class SubmitButton extends React.Component
  render: =>
    <input className={@submitClassName()} type="submit" value="Submit" onClick={@submitReport}/>

  submitReport: =>
    if @props.enabled
      QuestionnaireStore.submitReport()
    else
      alert("""
        Sorry! You can't submit this report yet as there are some required questions without answers.

        #{QuestionnaireStore.unansweredQuestionsForAllPages().join("\n")}
      """)

  submitClassName: =>
    className = "six columns button button-primary button--larger"
    className += " is-disabled" if not @props.enabled
    className
