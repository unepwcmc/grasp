React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class NumericQuestion extends Question
  render: ->
    <div className="question">
      <h1>{@props.data.question}</h1>
      <button id="numeric__decrement" onClick={@decrement}>-</button>
      <input type="number" onChange={@handleChange} value={@props.data.selected}/>
      <button id="numeric__increment" onClick={@increment}>+</button>
    </div>

  increment: =>
    answer = parseInt(@props.data.selected || 0) + 1
    if answer > 999 then answer = 999 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

  decrement: =>
    answer = parseInt(@props.data.selected || 0) - 1
    if answer < 0 then answer = 0 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)


module.exports = NumericQuestion

