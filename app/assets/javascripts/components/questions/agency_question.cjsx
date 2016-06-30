React = require("react")
Question = require("components/question")
NewAgencyForm = require("components/questions/new_agency_form")

class AgencyQuestion extends Question
  render: ->
    <div className="question">
      <h1>{@props.data.question}</h1>
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
      <NewAgencyForm/>
    else
      null

  isSelected: (answer) =>
    @props.data.selected == answer.id.toString()

module.exports = AgencyQuestion
