React = require("react")
Question = require("components/question")

class TextQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>
      <p style={@displayStyle()}>{@props.data.selected}</p>

      <div style={@editStyle()}>
        <input type="text" onChange={@handleChange} value={@props.data.selected}/>
      </div>
    </div>

module.exports = TextQuestion

