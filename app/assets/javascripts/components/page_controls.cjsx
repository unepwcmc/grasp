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
    if @props.currentPage < @props.maxPages - 1
      <button onClick={@nextPage} className="page-controls__control">
        Next step
      </button>

  renderPreviousPage: =>
    if @props.currentPage > 0
      <button onClick={@previousPage} className="page-controls__control">
        Previous step
      </button>

  previousPage: -> NavigationStore.previousPage()
  nextPage:     -> NavigationStore.nextPage()
