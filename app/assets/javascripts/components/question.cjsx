React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")

class Question extends React.Component
  constructor: (props, context) ->
    super(props, context)
    QuestionnaireStore.addVisibilityListener(@onVisibilityChange)
    @state = {}

  renderOtherField: =>
    if "other" == @props.data.selected
      <input type="text" value={@props.data.other_answer}
        onChange={@handleOtherChange}/>

  handleChange: (e) =>
    answer = e.target.value
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

    @showChildrenFor(answer)

  handleOtherChange: (e) =>
    QuestionnaireStore.updateOtherAnswer(@props.data.id, e.target.value)

  displayStyle: => if @props.mode == "edit" then {display: "none"}  else {display: "block"}
  editStyle:    => if @props.mode == "edit" then {display: "block"} else {display: "none"}

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
