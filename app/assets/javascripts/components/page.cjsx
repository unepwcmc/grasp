React = require("react")
Question = require("components/question")
NavigationStore = require("stores/navigation_store")
QuestionnaireStore = require("stores/questionnaire_store")

module.exports = class Page extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <div>
      <div>{@renderQuestions()}</div>
    </div>

  renderQuestions: =>
    @props.data.questions.map (question) =>
      <Question
        mode={@props.mode}
        key={question.id}
        answer={@getAnswers(question.id)}
        answered={QuestionnaireStore.isQuestionAnswered(question)}
        data={question}
      />

  getAnswers: (questionId) =>
    if @props.data.multiple
      activeTab = NavigationStore.tabIndexForCurrentPage()
      @props.answers[@props.data.id]?[activeTab]?[questionId] || null
    else
      @props.answers[questionId] || null
