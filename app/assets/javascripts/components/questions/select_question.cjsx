React = require("react")
Question = require("components/question")

class SelectQuestion extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <select value={@props.answer?.selected} onChange={@props.onChange}>
      <option value={@props.emptyOption}>Select {@props.emptyOption}</option>
      {@props.data.options.map( (option) ->
        <option value={option}>{option}</option>
      )}
    </select>

module.exports = SelectQuestion
