React = require("react")
Question = require("components/question")

class SingleAnswerQuestion extends Question
  render: ->
    <div className="question">
      <h1>{@props.data.question}</h1>
      <ul>{@renderAnswers()}</ul>
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer}>
        <input
          checked={@props.data.selected == answer}
          type="radio"
          className="answer__radio"
          onChange={@handleChange}
          value={answer}
          name={@props.data.id}
        />
        <label>{answer}</label>
      </li>
    )

module.exports = SingleAnswerQuestion
