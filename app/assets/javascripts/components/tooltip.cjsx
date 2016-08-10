React = require("react")

module.exports = class Tooltip extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {
      show: false
    }

  render: =>
    <p>
      <p>
        <em onClick={@toggleTooltip}>
          <i className="fa fa-question-circle"></i> Show help text
        </em>
      </p>
      {@renderTooltip()}
    </p>

  renderTooltip: =>
    if @state.show then <p>{@props.text}</p> else null

  toggleTooltip: =>
    @setState(show: !@state.show)
