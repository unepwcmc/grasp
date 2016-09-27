React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class Form extends React.Component
  render: ->
    <div>
      <fieldset className="form__group">
        <label htmlFor="agency_name">Agency Name:</label>
        <input onChange={@onChange} className="form__field" type="text" name="agency_name" id="agency_name"/>
      </fieldset>

      <fieldset className="form__group">
        <label htmlFor="contact_name">Contact Name:</label>
        <input onChange={@onChange} className="form__field" type="text" name="contact_name" id="contact_name"/>
      </fieldset>

      <fieldset className="form__group">
        <label htmlFor="telephone">Telephone:</label>
        <input onChange={@onChange} className="form__field" type="text" name="telephone" id="telephone"/>
      </fieldset>

      <fieldset className="form__group">
        <label htmlFor="email">Email:</label>
        <input onChange={@onChange} className="form__field" type="email" name="email" id="email"/><br/>
      </fieldset>
    </div>

  onChange: (e) =>
    selected = (@props.answer?.selected || {})
    selected[e.target.name] = e.target.value

    QuestionnaireStore.selectAnswer(@props.data.id, selected)

module.exports = Form
