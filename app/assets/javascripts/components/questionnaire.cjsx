React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")
Page = require("components/page")

class Questionnaire extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {
      pages: QuestionnaireStore.allVisible()
    }

  componentDidMount: ->
    QuestionnaireStore.addChangeListener(@onChange)

  render: ->
    <div className="pages">
      {@renderPages()}
    </div>

  renderPages: =>
    @state.pages.map (page) -> <Page questions={page}/>

  onChange: =>
    @setState({pages: QuestionnaireStore.allVisible()})

module.exports = Questionnaire
