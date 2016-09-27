React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class QuantitiesQuestion extends React.Component
  componentDidMount: (newProps) ->
    @setState({body_parts: @props.answer?.selected?.body_parts || false})

  componentWillReceiveProps: (newProps) ->
    @setState({body_parts: newProps.answer?.selected?.body_parts || false})

  render: ->
    <div>
      <fieldset>
        <div className="label label--left answer__num-label">
          <div onClick={@handleClick.bind(@, "live")} className={@checkboxClassName("live")}></div>
          <span className="label-body">Live ape</span>

          <div className="answer__num-container">
            <button className="answer__num-button" onClick={@decrement.bind(@, "live")}>-</button>
            <input className="answer answer--numeric" type="number" onChange={@handleLive} value={@valueFor("live")}/>
            <button className="answer__num-button" onClick={@increment.bind(@, "live")}>+</button>
          </div>
        </div>
      </fieldset>

      <fieldset>
        <div className="label label--left answer__num-label">
          <div onClick={@handleClick.bind(@, "dead")} className={@checkboxClassName("dead")}></div>
          <span className="label-body">Dead ape</span>

          <div className="answer__num-container">
            <button className="answer__num-button" onClick={@decrement.bind(@, "dead")}>-</button>
            <input className="answer answer--numeric" type="number" onChange={@handleDead} value={@valueFor("dead")}/>
            <button className="answer__num-button" onClick={@increment.bind(@, "dead")}>+</button>
          </div>
        </div>
      </fieldset>

      <fieldset>
        <div className="label label--left answer__num-label">
          <div onClick={@handleBodyParts} className={@checkboxClassName("body_parts")}></div>
          <span className="label-body">Body parts</span>
        </div>
      </fieldset>
    </div>

  checkboxClassName: (type) =>
    className = "answer__num-check"
    className += " is-checked" if @valueFor(type) != 0 and @valueFor(type) != false
    className

  handleLive: (e) => @update("live", parseInt(e.target.value))
  handleDead: (e) => @update("dead", parseInt(e.target.value))
  handleBodyParts: (e) =>
    @update("body_parts", !@state.body_parts)
    @setState({body_parts: !@state.body_parts})

  handleClick: (type) =>
    if @valueFor(type) == 0 then @update(type, 1) else @update(type, 0)

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
