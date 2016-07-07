React = require("react")
Question = require("components/question")

class DateQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>
      <input max={@maxDate()} value={@props.data.selected} onChange={@handleChange} type="date"></input>
    </div>

  maxDate: ->
    new Date().toJSON().slice(0,10)

module.exports = DateQuestion
