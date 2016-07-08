React = require("react")
Form = require("components/questions/form")

class AgencyQuestion extends React.Component
  render: ->
    <div>
      <ul>
        {@renderAnswers()}
        <li className="answer">
          <input className="answer__radio" type="radio"
            checked={@isSelected("form")}
            value={"form"} onChange={@props.onChange} name={@props.data.id}
          />
          <label>Add a New Agency</label>
        </li>
      </ul>

      {@renderForm()}
    </div>

  renderAnswers: ->
    @props.data.answers.map( (answer) =>
      <li className="answer" key={answer.id}>
        <input className="answer__radio" type="radio"
          checked={@isSelected(answer)} onChange={@props.onChange}
          value={answer.id} name={@props.data.id}
        />
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
