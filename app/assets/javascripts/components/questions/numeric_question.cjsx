React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class NumericQuestion extends React.Component
  render: ->
    <div className="label label--left answer__num-label">
      <div onClick={@handleClick} className={@checkboxClassName()}></div>
      <span className="label-body">{@props.partName}</span>

      <div className="answer__num-container">
        <button className="answer__num-button"
          onClick={@decrement}>-</button>

        <input className="answer answer--numeric" type="number"
          onChange={@props.onChange} value={@calculateAnswer()}/>

        <button className="answer__num-button"
          onClick={@increment}>+</button>

      </div>
    </div>

  increment: =>
    answer = parseInt(@props.answer?.selected || 0) + 1
    answer = if answer > 99 then 99 else answer
    @props.onChange(answer)

  decrement: =>
    answer = parseInt(@props.answer?.selected || 0) - 1
    answer = if answer < 0 then 0 else answer
    @props.onChange(answer)

  calculateAnswer: =>
    @props.answer?.selected || 0

  checkboxClassName: (type) =>
    className = "answer__num-check"
    className += " is-checked" if @props.answer?.selected > 0
    className

  handleClick: =>
    if @props.answer?.selected > 0 then @props.onChange(0) else @props.onChange(1)


module.exports = NumericQuestion

