React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class DecimalNumericQuestion extends React.Component
  render: ->
    <div>
      <button onClick={@decrement}>-</button>
      <input type="number" onChange={@props.onChange}
        value={parseFloat((@props.answer?.selected || 0.0).toFixed(1))}
        step="0.1"/>
      <button onClick={@increment}>+</button>
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

module.exports = DecimalNumericQuestion

