class @SingleAnswerQuestion extends Question
  render: ->
    @show(
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

  handleChange: (e) =>
    @setState({selected: e.target.value})

    @hideChildren()
    @setState({shownChildren: @state.children[e.target.value]})
    @showChildrenFor(e.target.value)

