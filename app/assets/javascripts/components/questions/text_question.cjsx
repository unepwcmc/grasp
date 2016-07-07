React = require("react")
Question = require("components/question")

class TextQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>
      <input type="text" onChange={@handleChange} value={@props.data.selected}/>
    </div>

module.exports = TextQuestion

