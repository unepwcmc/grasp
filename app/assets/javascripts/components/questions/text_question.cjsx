React = require("react")
Question = require("components/question")

class TextQuestion extends React.Component
  render: ->
    <input type="text" onChange={@props.onChange} value={@props.answer?.selected}/>

module.exports = TextQuestion

