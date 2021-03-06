NavigationStore = require("stores/navigation_store")
React = require("react")

module.exports = class TabControls extends React.Component
  render: =>
    return null unless @props.show

    <div className="tab-controls">
      {@renderTabs()}
    </div>

  renderTabs: =>
    numOfTabs = (@props.answers["quantities"]?["selected"]?[@props.pageId] || 1)
    for i in [0..numOfTabs-1]
      <div onClick={@selectTab.bind(@, i)} className={@buildClassName(i)}>
        {@renderApeType()} Ape Nº {i+1}
      </div>

  renderApeType: ->
    type = NavigationStore.currentPage().id
    type.charAt(0).toUpperCase() + type.slice(1)

  selectTab: (i) ->
    NavigationStore.selectTab(i)

  buildClassName: (i) ->
    name = "tab-controls__control"
    name += " is-selected" if NavigationStore.tabIndexForCurrentPage() == i

    name
