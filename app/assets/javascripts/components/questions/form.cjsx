React = require("react")
Question = require("components/question")

class Form extends Question
  render: ->
    <div>
      <h3>{@props.data.question}</h3>
      <p style={@displayStyle()}>{@props.data.selected}</p>

      <div style={@editStyle()}>
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
    </div>

module.exports = Form
