React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class NumericQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>
      <button onClick={@decrement}>-</button>
      <input type="number" onChange={@handleChange} value={@props.data.selected}/>
      <button onClick={@increment}>+</button>
    </div>

  increment: =>
    answer = parseInt(@props.data.selected || 0) + 1
    if answer > 99 then answer = 99 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

  decrement: =>
    answer = parseInt(@props.data.selected || 0) - 1
    if answer < 0 then answer = 0 else answer
    QuestionnaireStore.selectAnswer(@props.data.id, answer)


module.exports = NumericQuestion

