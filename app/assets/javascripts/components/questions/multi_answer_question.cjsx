React = require("react")
Question = require("components/question")
QuestionnaireStore   = require("stores/questionnaire_store")

class MultiAnswerQuestion extends React.Component
  render: ->
    @props.data.selected ||= []

    <ul>
      {@renderAnswers()}
      {@renderOther()}
    </ul>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer}>
        <label htmlFor={@props.data.id + answer}>
          <input
            checked={answer in @props.data.selected}
            type="checkbox"
            onChange={@handleChange}
            value={answer}
            id={@props.data.id + answer}
            name={@props.data.id}
          />
          <span className="label-body">{answer}</span>
        </label>
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
        <label>
          <input checked={"other" in @props.data.selected}
            type="checkbox" onChange={@handleChange} value="other"
            name={@props.data.id}
          />
          <span className="label-body">Other (please specify)</span>
        </label>

        {@renderOtherField()}
      </li>

  renderOtherField: =>
    if "other" in @props.data.selected
      <input type="text" value={@props.data.other_answer}
        onChange={@props.onOtherChange}/>

module.exports = MultiAnswerQuestion
