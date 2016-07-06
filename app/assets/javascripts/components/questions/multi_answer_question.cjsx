React = require("react")
Question = require("components/question")
QuestionnaireStore   = require("stores/questionnaire_store")

class MultiAnswerQuestion extends Question
  render: ->
    @props.data.selected ||= []

    <div className="question">
      <h1>{@props.data.question}</h1>
      <ul>
        {@renderAnswers()}
        {@renderOther()}
      </ul>
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

  renderOther: =>
    if @props.data.other
      <li className="answer" key="other">
        <div>
          <input checked={"other" in @props.data.selected}
            type="checkbox" className="answer__radio"
            onChange={@handleChange} value="other"
            name={@props.data.id}/>
          <label>Other (please specify)</label>
        </div>

        {@renderOtherField()}
      </li>

  renderOtherField: =>
    if "other" in @props.data.selected
      <input type="text" value={@props.data.other_answer}
        onChange={@handleOtherChange}/>

module.exports = MultiAnswerQuestion
