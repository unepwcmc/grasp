React = require("react")
Question = require("components/question")

class Form extends React.Component
  render: ->
    <form>
      <label for="agency_name">Agency Name:</label>
      <input type="text" name="agency_name" id="agency_name"/>

      <label for="contact_name">Contact Name:</label>
      <input type="text" name="contact_name" id="contact_name"/>

      <label for="telephone">Telephone:</label>
      <input type="text" name="telephone" id="telephone"/>

      <label for="email">Email:</label>
      <input type="text" name="email" id="email"/><br/>
    </form>

module.exports = Form
