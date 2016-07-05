React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")

class Question extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  componentDidMount: =>
    QuestionnaireStore.addVisibilityListener(@onVisibilityChange)

  handleChange: (e) =>
    answer = e.target.value
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

    @showChildrenFor(answer)

  showChildrenFor: (chosen) ->
    for answer, children of @props.data.children
      if chosen == answer
        QuestionnaireStore.show(child) for child in children
      else
        QuestionnaireStore.hide(child) for child in children

  onVisibilityChange: (key, change) =>
    return if key != @props.data.id

    if(change == "hide")
      @showChildrenFor(null)
    else
      @showChildrenFor(@props.data.selected)

module.exports = Question
