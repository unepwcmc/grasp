React = require("react")
Question = require("components/question")
QuestionnaireStore   = require("stores/questionnaire_store")

class MultiAnswerQuestion extends Question
  render: ->
    @props.data.selected ||= {}

    <div className="question">
      <h1>{@props.data.question}</h1>
      <ul>{@renderAnswers()}</ul>
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer}>
        <input
          checked={answer of @props.data.selected}
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
      @props.data.selected[e.target.value] = true
    else
      delete @props.data.selected[e.target.value]

    QuestionnaireStore.selectAnswer(@props.data.id, @props.data.selected)
    @showChildrenFor(@props.data.selected)




module.exports = MultiAnswerQuestion
