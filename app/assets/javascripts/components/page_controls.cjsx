NavigationStore = require("stores/navigation_store")
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
      <button onClick={@previousPage} className="page-controls__prev">
        < Previous step
      </button>

  renderNextPage: =>
    unless NavigationStore.isLastPage()
      <button onClick={@nextPage} className="button button-primary page-controls__next">
        Next step >
      </button>

  previousPage: -> NavigationStore.previousPage()
  nextPage:     -> NavigationStore.nextPage()
