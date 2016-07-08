React = require("react")
Question = require("components/question")

class SingleAnswerQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>
      <p style={@displayStyle()}>{@props.data.selected}</p>

      <div style={@editStyle()}>
        <ul>
          {@renderAnswers()}
          {@renderOther()}
        </ul>
      </div>
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer}>
        <label htmlFor={@props.data.id + answer}>
          <input
            checked={@props.data.selected == answer}
            type="radio"
            onChange={@handleChange}
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
          <input checked={"other" == @props.data.selected}
            type="radio" onChange={@handleChange} value="other"
            name={@props.data.id}
          />
          <span className="label-body">Other (please specify)</span>
        </label>

        {@renderOtherField()}
      </li>

module.exports = SingleAnswerQuestion
