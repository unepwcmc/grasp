NavigationStore = require("stores/navigation_store")
React = require("react")
Page = require("components/page")

module.exports = class PageControls extends React.Component
  render: =>
    <div className="page-controls">
      {@renderNextPage()}
      {@renderPreviousPage()}
    </div>

  renderNextPage: =>
    unless NavigationStore.isLastPage()
      <button onClick={@nextPage} className="page-controls__control">
        Next step
      </button>

  renderPreviousPage: =>
    unless NavigationStore.isFirstPage()
      <button onClick={@previousPage} className="page-controls__control">
        Previous step
      </button>

  previousPage: -> NavigationStore.previousPage()
  nextPage:     -> NavigationStore.nextPage()
