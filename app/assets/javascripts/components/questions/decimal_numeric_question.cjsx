React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class DecimalNumericQuestion extends React.Component
  render: ->
    <div className="label label--left answer__num-label">
      <div onClick={@handleClick} className={@checkboxClassName()}></div>
      <span className="label-body">{@props.partName}</span>

      <div className="answer__num-container">
        <button className="answer__num-button"
          onClick={@decrement}>-</button>

        <input className="answer answer--numeric" type="number"
          onChange={@props.onChange} value={@calculateAnswer()} step="0.1"/>

        <button className="answer__num-button"
          onClick={@increment}>+</button>

      </div>
    </div>

  increment: =>
    answer = (@props.answer?.selected || 0.0) + 0.1
    answer = parseFloat((answer).toFixed(1))
    answer = if answer > 99 then 99.0 else answer

    @props.onChange(answer)

  decrement: =>
    answer = (@props.answer?.selected || 0.0) - 0.1
    answer = parseFloat((answer).toFixed(1))
    answer = if answer < 0 then 0.0 else answer

    @props.onChange(answer)

  calculateAnswer: =>
    parseFloat((@props.answer?.selected || 0.0).toFixed(1))

  checkboxClassName: (type) =>
    className = "answer__num-check"
    className += " is-checked" if @props.answer?.selected > 0
    className

  handleClick: =>
    if @props.answer?.selected > 0 then @props.onChange(0.0) else @props.onChange(1.0)

module.exports = DecimalNumericQuestion

