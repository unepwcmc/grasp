React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")
Page               = require("components/page")
PageControls       = require("components/page_controls")
SubmitButton       = require("components/submit_button")

class Questionnaire extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {
      currentPage: QuestionnaireStore.currentPage(),
      mode: QuestionnaireStore.getMode(),
      pages: QuestionnaireStore.allPages()
    }

  componentDidMount: ->
    QuestionnaireStore.addChangeListener(@onChange)

  render: ->
    <div className="questionnaire">
      {@renderCurrentPage()}
      <PageControls maxPages={@state.pages.length} currentPage={@state.currentPage}/>
      <SubmitButton/>
    </div>

  renderCurrentPage: =>
    if @state.pages[@state.currentPage]?.questions.length > 0
      <Page mode={@state.mode} data={@state.pages[@state.currentPage]}/>

  onChange: =>
    @setState({
      currentPage: QuestionnaireStore.currentPage(),
      pages: QuestionnaireStore.allPages()
    })


module.exports = Questionnaire
