React = require("react")
Question = require("components/question")

module.exports = class Page extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <div>
      <h1 className="page__title">{@props.data.title}</h1>
      <div>{@renderQuestions()}</div>
    </div>

  renderQuestions: =>
    @props.data.questions.map (question) =>
      <Question
        mode={@props.mode}
        key={question.id}
        answer={@props.answers[question.id]}
        data={question}
      />
