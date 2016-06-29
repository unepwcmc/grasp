class @SingleAnswerQuestion extends Question
  render: ->
    @render_if_visible(
      <div>
        <h1>{@state.question}</h1>
        <ul>{@renderAnswers()}</ul>
      </div>
    )

  renderAnswers: ->
    @state.answers.map( (answer) =>
      <li key={answer}>
        <label>{answer}</label>
        <input checked={@state.selected == answer} type="radio" onChange={@handleChange} value={answer} name={@state.id}/>
      </li>
    )
