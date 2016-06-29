class @Question extends React.Component
  constructor: (props, context) ->
    super(props, context)

    @state = @props.data
    @state.id = @props.id
    QuestionsRepo.register(@state.id, @)

  render_if_visible: (component) ->
    if @state.hidden
      null
    else
      component

  componentDidUpdate: ->
    if @state.hidden
      @hideChildren()
    else
      @showChildrenFor(@state.selected)

  handleChange: (e) =>
    @setState({selected: e.target.value})

    @hideChildren()
    @setState({shownChildren: @state.children[e.target.value]})
    @showChildrenFor(e.target.value)


  hideChildren: =>
    (@state.shownChildren || []).map( (child) ->
      QuestionsRepo.fetch(child).setState({hidden: true})
    )

  showChildrenFor: (answer) ->
    (@state.children[answer] || []).map( (child) ->
      QuestionsRepo.fetch(child).setState({hidden: false})
    )
