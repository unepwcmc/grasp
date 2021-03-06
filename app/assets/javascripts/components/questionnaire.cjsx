_ = require("underscore")
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
      {@renderButtons()}
    </div>

  renderCurrentPage: =>
    if @state.currentPage?.questions.length > 0
      <Page mode={@state.mode} answers={@state.answers} data={@state.currentPage}/>

  renderButtons: =>
    unless @state.mode == "show"
      [
        <div className="hide-mobile six columns u-pull-right questionnaire-buttons">
          <SaveButton/> {@renderSubmitButton()}
        </div>,
        <div className="only-mobile">
          <SaveButton/> {@renderSubmitButton()}
        </div>
      ]

  renderSubmitButton: ->
    <SubmitButton enabled={QuestionnaireStore.requiredQuestionsAnswered()}/>

  onChange: =>
    NavigationStore.updateAnswers()

    @setState({
      currentPage: NavigationStore.currentPage(),
      mode: QuestionnaireStore.getMode(),
      answers: QuestionnaireStore.getAnswers()
    })

module.exports = Questionnaire
