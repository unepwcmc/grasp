React = require("react")
Question = require("components/question")

class Form extends React.Component
  render: ->
    <form>
      <fieldset className="form__group">
        <label htmlFor="agency_name">Agency Name:</label>
        <input className="form__field" type="text" name="agency_name" id="agency_name"/>
      </fieldset>

      <fieldset className="form__group">
        <label htmlFor="contact_name">Contact Name:</label>
        <input className="form__field" type="text" name="contact_name" id="contact_name"/>
      </fieldset>

      <fieldset className="form__group">
        <label htmlFor="telephone">Telephone:</label>
        <input className="form__field" type="text" name="telephone" id="telephone"/>
      </fieldset>

      <fieldset className="form__group">
        <label htmlFor="email">Email:</label>
        <input className="form__field" type="text" name="email" id="email"/><br/>
      </fieldset>
    </form>

module.exports = Form
