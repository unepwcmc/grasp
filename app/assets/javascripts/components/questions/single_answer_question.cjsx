React = require("react")
Question = require("components/question")

class SingleAnswerQuestion extends Question
  render: ->
    <div>
      <h1>{@props.data.question}</h1>
      <ul>{@renderAnswers()}</ul>
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li key={answer}>
        <label>{answer}</label>
        <input checked={@props.data.selected == answer} type="radio" onChange={@handleChange} value={answer} name={@props.data.id}/>
      </li>
    )

module.exports = SingleAnswerQuestion
