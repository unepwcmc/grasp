React = require("react")
Question = require("components/question")

class DateQuestion extends React.Component
  render: ->
    <input max={@maxDate()} value={@props.answer?.selected}
      onChange={@props.onChange} type="date"></input>

  maxDate: -> new Date().toJSON().slice(0,10)

module.exports = DateQuestion
