React = require("react")
Question = require("components/question")

class DateQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>
      <p style={@displayStyle()}>{@props.data.selected}</p>

      <div style={@editStyle()}>
        <input max={@maxDate()} value={@props.data.selected} onChange={@handleChange} type="date"></input>
      </div>
    </div>

  maxDate: ->
    new Date().toJSON().slice(0,10)

module.exports = DateQuestion
