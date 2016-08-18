React = require("react")
Question = require("components/question")
TabControls = require("components/tab_controls")
NavigationStore = require("stores/navigation_store")

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
        answer={@getAnswers(question.id)}
        data={question}
      />

  getAnswers: (questionId) =>
    if @props.data.multiple
      activeTab = NavigationStore.tabIndexForCurrentPage()
      @props.answers[@props.data.id]?[activeTab]?[questionId] || null
    else
      @props.answers[questionId] || null
