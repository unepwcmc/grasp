React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")
Page               = require("components/page")
PageControls       = require("components/page_controls")

class Questionnaire extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {
      currentPage: QuestionnaireStore.currentPage(),
      pages: QuestionnaireStore.allVisible()
    }

  componentDidMount: ->
    QuestionnaireStore.addChangeListener(@onChange)

  render: ->
    <div className="questionnaire">
      {@renderCurrentPage()}
      <PageControls maxPages={@state.pages.length} currentPage={@state.currentPage}/>
    </div>

  renderCurrentPage: =>
    if @state.pages[@state.currentPage]
      <Page questions={@state.pages[@state.currentPage]}/>
    else
      null

  onChange: =>
    @setState({
      currentPage: QuestionnaireStore.currentPage(),
      pages: QuestionnaireStore.allVisible()
    })


module.exports = Questionnaire
