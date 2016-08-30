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
    answer = if answer > 99 then 99 else answer
    @props.onChange(answer)

  decrement: =>
    answer = parseInt(@props.answer?.selected || 0) - 1
    answer = if answer < 0 then 0 else answer
    @props.onChange(answer)


module.exports = NumericQuestion

