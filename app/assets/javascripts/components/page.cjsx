React = require("react")
Question = require("components/question")

module.exports = class Page extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <div>
      <h1 className="page__title">{@props.data.title}</h1>
      {@tabsDividers()}
      <div>{@renderQuestions()}</div>
    </div>

  renderQuestions: =>
    @props.data.questions.map (question) =>
      <Question
        mode={@props.mode}
        key={question.id}
        answer={@props.answers[question.id] || null}
        data={question}
      />

  tabsDividers: =>
    return null unless @props.data.multiple

    numOfTabs = (@props.answers["quantities"]?["selected"]?[@props.data.id] || 1)
    for i in [0..numOfTabs-1]
      <span>Ape #{i+1}</span>

