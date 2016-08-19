React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class NumericQuestion extends React.Component
  render: ->
    <div>
      <button onClick={@decrement}>-</button>
      <input type="number" onChange={@props.onChange} value={@props.answer?.selected}/>
      <button onClick={@increment}>+</button>
    </div>

  increment: =>
    answer = parseInt(@props.answer?.selected || 0) + 1
    if answer > 99 then answer = 99 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

  decrement: =>
    answer = parseInt(@props.answer?.selected || 0) - 1
    if answer < 0 then answer = 0 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)


module.exports = NumericQuestion

