React = require("react")
Question = require("components/question")

class NumericQuestion extends Question
  render: ->
    <div className="question">
      <h1>{@props.data.question}</h1>
      <input type="number" onChange={@handleChange} value={@props.data.selected}/>
    </div>

module.exports = NumericQuestion

