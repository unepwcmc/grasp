React = require("react")
Question = require("components/question")
NewAgencyForm = require("components/questions/new_agency_form")

class AgencyQuestion extends Question
  render: ->
    <div>
      <h1>{@props.data.question}</h1>
      <ul>
        {@renderAnswers()}
        <li>
          <label>Add a New Agency</label>
          <input type="radio" checked={@props.data.selected == "form"} value={"form"} onChange={@handleChange} name={@props.data.id}/>
        </li>
      </ul>

      {@renderForm()}
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li key={answer.id}>
        <label>{answer.name}</label>
        <input type="radio" checked={@isSelected(answer)} onChange={@handleChange} value={answer.id} name={@props.data.id}/>
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
