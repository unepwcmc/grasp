React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")

class Question extends React.Component
  constructor: (props, context) ->
    @state = {}

  handleChange: (e) =>
    answer = e.target.value
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

    @hideChildren()
    @showChildrenFor(answer)

  hideChildren: =>
    (@state.shownChildren || []).map (child) ->
      QuestionnaireStore.hide(child)

  showChildrenFor: (answer) ->
    @setState({shownChildren: @props.data.children[answer]})
    (@props.data.children[answer] || []).map (child) ->
      QuestionnaireStore.show(child)

module.exports = Question
