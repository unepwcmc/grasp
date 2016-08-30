React = require("react")
Question = require("components/question")

class SelectQuestion extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <select onChange={@props.onChange}>
      {@props.data.options.map( (option) ->
        <option value={option}>{option}</option>
      )}
    </select>

module.exports = SelectQuestion
