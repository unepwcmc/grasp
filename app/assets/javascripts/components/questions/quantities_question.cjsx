React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class QuantitiesQuestion extends React.Component
  render: ->
    <div>
      <fieldset>
        <label className="label label--left">Live</label>

        <button onClick={@decrement.bind(@, "live")}>-</button>
        <input type="number" onChange={@handleLive} value={@valueFor("live")}/>
        <button onClick={@increment.bind(@, "live")}>+</button>
      </fieldset>

      <fieldset>
        <label className="label label--left">Dead</label>

        <button onClick={@decrement.bind(@, "dead")}>-</button>
        <input type="number" onChange={@handleDead} value={@valueFor("dead")}/>
        <button onClick={@increment.bind(@, "dead")}>+</button>
      </fieldset>

      <fieldset>
        <label className="label label--left">Body parts</label>

        <input checked={@props.data.selected?.body_parts}
          type="checkbox" onChange={@handleBodyParts} value="body_parts"
          id="body_parts" name={@props.data.id}/>
      </fieldset>
    </div>

  handleLive: (e) =>
    debugger
    @update("live", e.target.value)
  handleDead: (e) =>
    @update("dead", e.target.value)
  handleBodyParts: (e) =>
    @update("body_parts", e.target.checked)

  valueFor: (type) =>
    @props.data.selected?[type] || 0

  increment: (type) =>
    answer = parseInt(@props.data.selected?[type] || 0) + 1
    @update(type, answer) if answer < 100

  decrement: (type) =>
    answer = parseInt(@props.data.selected?[type] || 0) - 1
    @update(type, answer) if answer >= 0

  update: (type, answer) =>
    @props.data.selected ||= {}
    @props.data.selected[type] = answer
    QuestionnaireStore.selectAnswer(@props.data.id, @props.data.selected)


module.exports = QuantitiesQuestion
