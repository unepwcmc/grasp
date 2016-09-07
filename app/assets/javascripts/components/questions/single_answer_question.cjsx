_ = require("underscore")
React = require("react")
Question = require("components/question")

class SingleAnswerQuestion extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <ul className="question__list">
      {@renderAnswers()}
      {@renderOther()}
    </ul>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer}>
        <label htmlFor={@props.data.id + answer}>
          <input
            checked={@props.answer?.selected == answer}
            type="radio"
            onChange={@props.onChange}
            value={answer}
            name={@props.data.id}
            id={@props.data.id + answer}
          />
          {@renderAnswerLabel(answer)}
        </label>

        {@renderOtherField(answer)}
      </li>
    )

  renderAnswerLabel: (answer) =>
    if (matches = answer.match(/(.*) \((.*)\)/)) and not _.contains(@props.data.other_answers, answer)
      <span className="label-body">{matches[1]} (<em>{matches[2]}</em>)</span>
    else
      <span className="label-body">{answer}</span>

  renderOther: =>
    if @props.data.other
      <li className="answer" key="other">
        <label>
          <input checked={"other" == @props.answer?.selected}
            type="radio" onChange={@props.onChange} value="other"
            name={@props.data.id}
          />
          <span className="label-body">Other (please specify)</span>
        </label>

        {@renderOtherField("other")}
      </li>

  renderOtherField: (triggerAnswer) =>
    if triggerAnswer != "other" and not _.contains(@props.data.other_answers, triggerAnswer)
      return

    if triggerAnswer == @props.answer?.selected
      <input type="text" value={@props.answer?.other_answer}
        onChange={@props.onOtherChange}/>

module.exports = SingleAnswerQuestion
