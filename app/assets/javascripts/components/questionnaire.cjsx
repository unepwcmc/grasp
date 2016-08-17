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
      pages: NavigationStore.allPages(),
      answers: QuestionnaireStore.getAnswers()
    }

  componentDidMount: ->
    NavigationStore.addPageChangeListener(@onChange)
    NavigationStore.addTabChangeListener(@onChange)
    QuestionnaireStore.addChangeListener(@onChange)

  render: ->
    <div className="questionnaire">
      {@renderCurrentPage()}
      <PageControls maxPages={@state.pages.length} currentPage={@state.currentPage}/>
      <SaveButton/>
      {@renderSubmitButton()}
    </div>

  renderCurrentPage: =>
    if @state.pages[@state.currentPage]?.questions.length > 0
      <Page mode={@state.mode} answers={@state.answers} data={@state.pages[@state.currentPage]}/>

  renderSubmitButton: =>
    if QuestionnaireStore.requiredQuestionsAnswered()
      <SubmitButton/>

  onChange: =>
    @setState({
      currentPage: NavigationStore.currentPage(),
      pages: NavigationStore.allPages(),
      answers: QuestionnaireStore.getAnswers()
    })

module.exports = Questionnaire
