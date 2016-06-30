React = require("react")
Question = require("components/question")

class NewAgencyForm extends Question
  render: ->
    <form>
      <fieldset>
        <label for="agency_name">Agency Name:</label>
        <input type="text" name="agency_name" id="agency_name"/><br/>
        <label for="contact_name">Contact Name:</label>
        <input type="text" name="contact_name" id="contact_name"/><br/>
        <label for="telephone">Telephone:</label>
        <input type="text" name="telephone" id="telephone"/><br/>
        <label for="email">Email:</label>
        <input type="text" name="email" id="email"/><br/>
        <input type="submit" value="Submit"/>
      </fieldset>
    </form>

module.exports = NewAgencyForm
