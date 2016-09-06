React = require("react")
moment = require("moment")
DatePicker = require("react-datepicker")
QuestionnaireStore = require("stores/questionnaire_store")
Question = require("components/question")

class DateQuestion extends React.Component
  componentDidMount: =>
    setTimeout(=>
      QuestionnaireStore.selectAnswer(@props.data.id, moment().format("DD/MM/YYYY"))
    , 100)

  render: ->
    <DatePicker inline={false} dateFormat="DD/MM/YYYY" maxDate={moment()}
      readOnly={true} selected={@selectedDate()} onChange={@handleChange}/>

  handleChange: (date) =>
    QuestionnaireStore.selectAnswer(@props.data.id, date.format("DD/MM/YYYY"))

  selectedDate: =>
    parsedDate = moment(@props.answer?.selected, "DD/MM/YYYY")
    if parsedDate.isValid() then parsedDate else moment()


module.exports = DateQuestion
