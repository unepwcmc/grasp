React = require("react")
Question = require("components/question")

class DateQuestion extends Question
  render: ->
    <div className="question">
      <h1>{@props.data.question}</h1>
      <input value={@props.data.selected} onChange={@handleChange} type="date"></input>
    </div>

module.exports = DateQuestion
