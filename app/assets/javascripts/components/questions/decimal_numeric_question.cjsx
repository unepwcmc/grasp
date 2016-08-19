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

    if answer > 99 then answer = 99.0 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

  decrement: =>
    answer = (@props.answer?.selected || 0.0) - 0.1
    answer = parseFloat((answer).toFixed(1))

    if answer < 0 then answer = 0.0 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

module.exports = DecimalNumericQuestion

