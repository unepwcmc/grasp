React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class SubspeciesQuestion extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <ul>
      {@renderAnswers()}
      {@renderDnaConfirmation()}
    </ul>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer}>
        <label htmlFor={@props.data.uniqueId + answer}>
          <input
            checked={@props.answer?.selected == answer}
            type="radio"
            onChange={@props.onChange}
            value={answer}
            name={@props.data.id}
            id={@props.data.uniqueId + answer}
          />
          {@renderAnswerLabel(answer)}
        </label>
      </li>
    )

  renderAnswerLabel: (answer) ->
    if matches = answer.match(/(.*) \((.*)\)/)
      <span className="label-body">{matches[1]} (<em>{matches[2]}</em>)</span>
    else
      <span className="label-body">{answer}</span>

  renderDnaConfirmation: =>
    <label htmlFor={@props.data.uniqueId + "-dna-confirmation"}>
      <input
        disabled={!@props.answer or !@props.answer.selected}
        checked={@props.answer?.dna_confirmation}
        type="checkbox"
        onChange={@toggleDnaConfirmation}
        value={true}
        id={@props.data.uniqueId + "-dna-confirmation"}
        name={@props.data.id}
      />
      <span className="label-body">DNA Confirmation</span>
    </label>

  toggleDnaConfirmation: (e) =>
    if e.target.checked
      QuestionnaireStore.confirmDna(@props.data.id)
    else
      QuestionnaireStore.removeDnaConfirmation(@props.data.id)

module.exports = SubspeciesQuestion
