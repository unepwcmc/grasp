React = require("react")
Question = require("components/question")

class SingleAnswerQuestion extends React.Component
  render: ->
    <ul>
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
          <span className="label-body">{answer}</span>
        </label>
      </li>
    )

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

        {@renderOtherField()}
      </li>


  renderOtherField: =>
    if "other" == @props.answer?.selected
      <input type="text" value={@props.data.other_answer}
        onChange={@handleOtherChange}/>

module.exports = SingleAnswerQuestion
