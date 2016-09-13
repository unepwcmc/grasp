NavigationStore = require("stores/navigation_store")
QuestionnaireStore = require("stores/questionnaire_store")
React = require("react")
Page = require("components/page")

module.exports = class PageControls extends React.Component
  render: =>
    <div className="page-controls">
      <div className="row">
        {@renderNextPage()}
        {@renderPreviousPage()}
      </div>
    </div>

  renderPreviousPage: =>
    unless NavigationStore.isFirstPage()
      <button onClick={@previousPage} className="page-controls__prev button--larger">
        {if QuestionnaireStore.getMode() == "show" then "< Previous" else "< Previous step"}
      </button>

  renderNextPage: =>
    unless NavigationStore.isLastPage()
      <button onClick={@nextPage} className="button button-primary button--larger page-controls__next">
        {if QuestionnaireStore.getMode() == "show" then "Next >" else "Next step >"}
      </button>

  previousPage: -> NavigationStore.previousPage()
  nextPage:     -> NavigationStore.nextPage()
