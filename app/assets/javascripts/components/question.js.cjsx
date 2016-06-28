class @Question extends React.Component
  constructor: (props, context) ->
    super(props, context)

    @state = @props.data
    @state.id = @props.id
    window.questions[@state.id] = @

  show: (component) ->
    if @state.hidden
      @hideChildren()
      <div></div>
    else
      @showChildrenFor(@state.selected)
      component

  handleChange: (e) =>
    @setState({selected: e.target.value})

    @hideChildren()
    @setState({shownChildren: @state.children[e.target.value]})
    @showChildrenFor(e.target.value)


  hideChildren: =>
    (@state.shownChildren || []).map( (child) ->
      window.questions[child].setState({hidden: true})
    )

  showChildrenFor: (answer) ->
    (@state.children[answer] || []).map( (child) ->
      window.questions[child].setState({hidden: false})
    )
