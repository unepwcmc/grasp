React = require("react")
Question = require("components/question")
TabControls = require("components/tab_controls")

module.exports = class Page extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <div>
      <h1 className="page__title">{@props.data.title}</h1>
      <TabControls
        answers={@props.answers}
        pageId={@props.data.id}
        show={@props.data.multiple}
      />
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
