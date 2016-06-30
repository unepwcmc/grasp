React = require("react")
Question = require("components/question")

class DateQuestion extends Question
  render: ->
    <div>
      <h1>{@props.data.question}</h1>
      <input value={@props.selected} type="date"></input>
    </div>

module.exports = DateQuestion
