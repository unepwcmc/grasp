React = require("react")
Question = require("components/question")

class TextQuestion extends React.Component
  render: ->
    <input type="text" onChange={@props.onChange} value={@props.data.selected}/>

module.exports = TextQuestion

