class @AgencyQuestion extends Question
  render: ->
    @render_if_visible(
      <div>
        <h1>{@state.question}</h1>
        <ul>{@renderAnswers()}</ul>
      </div>
    )

  renderAnswers: ->
    @state.answers.map( (answer) =>
      <li key={answer.id}>
        <label>{answer.name}</label>
        <input type="radio" checked={@state.selected == answer.id.toString()} onChange={@handleChange} value={answer.id} name={@state.id}/>
      </li>
    )
