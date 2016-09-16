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
      <button onClick={@nextPage} className={@nextPageClassName()}>
        {if QuestionnaireStore.getMode() == "show" then "Next >" else "Next step >"}
      </button>

  nextPageClassName: ->
    className = "button button-primary button--larger page-controls__next"
    className += " is-disabled" unless NavigationStore.isCurrentPageCompleted()
    className

  previousPage: -> NavigationStore.previousPage()
  nextPage:     ->
    if NavigationStore.isCurrentPageCompleted()
      NavigationStore.nextPage()
    else
      alert("""
        Sorry! You can't move onto the next page yet as there are
        some required questions without answers.

        #{QuestionnaireStore.unansweredQuestionsForPage(NavigationStore.currentPage()).join("\n")}
      """)
