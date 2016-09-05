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

        <input checked={@props.answer?.selected?.body_parts}
          type="checkbox" onChange={@handleBodyParts} value="body_parts"
          id="body_parts" name={@props.data.id}/>
      </fieldset>
    </div>

  handleLive: (e) => @update("live", parseInt(e.target.value))
  handleDead: (e) => @update("dead", parseInt(e.target.value))
  handleBodyParts: (e) => @update("body_parts", e.target.checked)

  increment: (type) => @update(type, @valueFor(type) + 1)
  decrement: (type) => @update(type, @valueFor(type) - 1)

  update: (type, answer) =>
    return unless 0 <= answer < 100

    selectedAnswers = {
      live: @props.answer?.selected?.live,
      dead: @props.answer?.selected?.dead,
      body_parts: @props.answer?.selected?.body_parts
    }

    selectedAnswers[type] = answer
    QuestionnaireStore.selectAnswer(@props.data.id, selectedAnswers)

  valueFor: (type) => parseInt(@props.answer?.selected?[type] || 0)

module.exports = QuantitiesQuestion
