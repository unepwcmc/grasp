React = require("react")

module.exports = class Tooltip extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {
      show: false
    }

  render: =>
    <div className="tooltip">
      <p className="tooltip__trigger" onClick={@toggleTooltip}>
        <i className="fa fa-question-circle tooltip__icon"></i> Show help text
      </p>
      {@renderTooltip()}
    </div>

  renderTooltip: =>
    if @state.show then <p>{@props.text}</p> else null

  toggleTooltip: =>
    @setState(show: !@state.show)
