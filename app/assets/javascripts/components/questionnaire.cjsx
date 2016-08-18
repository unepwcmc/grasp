React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")
NavigationStore    = require("stores/navigation_store")
Page               = require("components/page")
PageControls       = require("components/page_controls")
SaveButton         = require("components/save_button")
SubmitButton       = require("components/submit_button")

class Questionnaire extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {
      currentPage: NavigationStore.currentPage(),
      mode: QuestionnaireStore.getMode(),
      answers: QuestionnaireStore.getAnswers()
    }

  componentDidMount: ->
    NavigationStore.addPageChangeListener(@onChange)
    NavigationStore.addTabChangeListener(@onChange)
    QuestionnaireStore.addChangeListener(@onChange)

  render: ->
    <div className="questionnaire">
      {@renderCurrentPage()}
      <PageControls/>
      <SaveButton/>
      {@renderSubmitButton()}
    </div>

  renderCurrentPage: =>
    if @state.currentPage?.questions.length > 0
      <Page mode={@state.mode} answers={@state.answers} data={@state.currentPage}/>

  renderSubmitButton: ->
    <SubmitButton/> if QuestionnaireStore.requiredQuestionsAnswered()

  onChange: =>
    @setState({
      currentPage: NavigationStore.currentPage(),
      mode: QuestionnaireStore.getMode(),
      answers: QuestionnaireStore.getAnswers()
    })

  componentDidUpdate: (prev, now) =>
    tabIndex = NavigationStore.tabIndexForCurrentPage()
    for key, question of @state.currentPage.questions
      if @state.currentPage.multiple
        unless question.type == "multi"
          if question.answers? and @state.answers[@state.currentPage.id]?[tabIndex]?[question.id]?.selected not in question.answers
            QuestionnaireStore.nullAnswer(question.id, false)
      else
        unless question.type == "multi"
          if question.answers? and @state.answers[question.id]?.selected not in question.answers
            QuestionnaireStore.nullAnswer(question.id, false)


module.exports = Questionnaire
