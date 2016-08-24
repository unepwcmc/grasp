NavigationStore = require("stores/navigation_store")
React = require("react")
Page = require("components/page")

module.exports = class NavigationControls extends React.Component
  render: =>
    <div>
      {@renderPageIndexes()}
    </div>

  renderPageIndexes: =>
    for page, index in NavigationStore.getPages() when NavigationStore.isPageVisible(page)
      <p>{index}</p>
