React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")
Page = require("components/page")

class Questionnaire extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {
      currentPage: 0,
      pages: QuestionnaireStore.allVisible()
    }

  componentDidMount: ->
    QuestionnaireStore.addChangeListener(@onChange)

  render: ->
    <div className="questionnaire">
      {@renderCurrentPage()}

      <div className="page-controls">
        <button onClick={@nextPage} className="page-controls__control">
          Next step
        </button>
        <button onClick={@previousPage} className="page-controls__control page-controls__control">
          Previous step
        </button>
      </div>

    </div>

  renderCurrentPage: =>
    if @state.pages[@state.currentPage]
      <Page questions={@state.pages[@state.currentPage]}/>
    else
      null

  onChange: =>
    @setState({pages: QuestionnaireStore.allVisible()})

  previousPage: => @setState({currentPage: @state.currentPage-1})
  nextPage:     => @setState({currentPage: @state.currentPage+1})

module.exports = Questionnaire
