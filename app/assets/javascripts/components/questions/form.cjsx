React = require("react")
Question = require("components/question")

class Form extends Question
  render: ->
    <div>
      <h1>{@props.data.question}</h1>
      <form>
        <label for="agency_name">Agency Name:</label>
        <input type="text" name="agency_name" id="agency_name"/><br/>
        <label for="contact_name">Contact Name:</label>
        <input type="text" name="contact_name" id="contact_name"/><br/>
        <label for="telephone">Telephone:</label>
        <input type="text" name="telephone" id="telephone"/><br/>
        <label for="email">Email:</label>
        <input type="text" name="email" id="email"/><br/>
      </form>
    </div>

module.exports = Form
