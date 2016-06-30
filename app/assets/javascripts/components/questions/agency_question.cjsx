React = require("react")
Question = require("components/question")

class AgencyQuestion extends Question
  render: ->
    <div>
      <h1>{@props.data.question}</h1>
      <ul>{@renderAnswers()}</ul>
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li key={answer.id}>
        <label>{answer.name}</label>
        <input type="radio" checked={@isSelected(answer)} onChange={@handleChange} value={answer.id} name={@props.data.id}/>
      </li>
    )

  isSelected: (answer) =>
    @props.data.selected == answer.id.toString()

module.exports = AgencyQuestion
