React = require("react")
Question = require("components/question")

class TextQuestion extends Question
  render: ->
    <div className="question">
      <h1>{@props.data.question}</h1>
      <input type="text" onChange={@handleChange} value={@props.data.selected}/>
    </div>

module.exports = TextQuestion

