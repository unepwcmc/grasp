React = require("react")
Question = require("components/question")
Form = require("components/questions/form")

class AgencyQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>
      <ul>
        {@renderAnswers()}
        <li className="answer">
          <input className="answer__radio" type="radio" checked={@props.data.selected == "form"} value={"form"} onChange={@handleChange} name={@props.data.id}/>
          <label>Add a New Agency</label>
        </li>
      </ul>

      {@renderForm()}
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer.id}>
        <input className="answer__radio" type="radio" checked={@isSelected(answer)} onChange={@handleChange} value={answer.id} name={@props.data.id}/>
        <label>{answer.name}</label>
      </li>
    )

  renderForm: =>
    if @props.data.selected == "form"
      <Form/>
    else
      null

  isSelected: (answer) =>
    @props.data.selected == answer.id.toString()

module.exports = AgencyQuestion
