React = require("react")
Question = require("components/question")
QuestionnaireStore   = require("stores/questionnaire_store")

class MultiAnswerQuestion extends Question
  render: ->
    @props.data.selected ||= []

    <div className="question">
      <h1>{@props.data.question}</h1>
      <ul>{@renderAnswers()}</ul>
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer}>
        <input
          checked={answer in @props.data.selected}
          type="checkbox"
          className="answer__radio"
          onChange={@handleChange}
          value={answer}
          name={@props.data.id}
        />
        <label>{answer}</label>
      </li>
    )

  handleChange: (e) =>
    if e.target.checked
      QuestionnaireStore.addAnswer(@props.data.id, e.target.value)
    else
      QuestionnaireStore.removeAnswer(@props.data.id, e.target.value)

module.exports = MultiAnswerQuestion
