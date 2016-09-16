React = require("react")
Page = require("components/page")
TabControls = require("components/tab_controls")
QuestionnaireStore = require("stores/questionnaire_store")
NavigationStore = require("stores/navigation_store")

module.exports = class NavigationControls extends React.Component
  constructor: (props, context) ->
    super(props, context)

    QuestionnaireStore.addChangeListener(@onChange)
    NavigationStore.addPageChangeListener(@onChange)
    NavigationStore.addTabChangeListener(@onChange)

    @state = ({
      currentPage: NavigationStore.currentPage(),
      currentPageIndex: NavigationStore.getCurrentPageIndex(),
      allPages: NavigationStore.getPages(),
      allAnswers: QuestionnaireStore.getAnswers()
    })

  render: =>
    <div className="navigation-controls">
      <div className="navigation-controls__inner navigation-controls__sup">
        {@renderControl("1", 0)}
        {@renderControl("2", [1,2,3])}
        {@renderIfPageVisible("a", 1, true, "is-minor")}
        {@renderIfPageVisible("b", 2, true, "is-minor")}
        {@renderIfPageVisible("c", 3, true, "is-minor")}
        {@renderControl("3", 4, false)}
      </div>
      <div className="navigation-controls__inner navigation-controls__inf">
        <h4>{@state.currentPage.title}</h4>
      </div>
      <div className="navigation-controls__inner">
        <TabControls
          answers={@state.allAnswers}
          pageId={@state.currentPage.id}
          show={@state.currentPage.multiple}
        />
      </div>
      <p className="navigation-controls__inner navigation-controls__inner--last">
        All questions must be answered, unless marked (optional).
      </p>
    </div>

  renderIfPageVisible: (text, pageIndex, withDivider=true, additionalClass) =>
    page = @state.allPages[pageIndex]
    if NavigationStore.isPageVisible(page)
      @renderControl(text, pageIndex, withDivider, additionalClass)

  renderControl: (text, pageIndex, withDivider=true, additionalClass="") =>
    className = "#{@elementClassName(pageIndex)} #{additionalClass}"
    result = [<div onClick={@onClick.bind(@, pageIndex)} className={className}>
        <span>{text}</span>
    </div>]
    result.push(<div className={@dividerClassName(pageIndex)}></div>) if withDivider

    result

  elementClassName: (pageIndex) =>
    name = "navigation-controls__element"
    if pageIndex.constructor == Array
      name += " is-current" if @state.currentPageIndex in pageIndex
    else
      name += " is-current" if @state.currentPageIndex == pageIndex
      name += " is-current" if @state.currentPageIndex in [1,2,3] and pageIndex in [1,2,3] and pageIndex <= @state.currentPageIndex
    name

  dividerClassName: (pageIndex) =>
    name = "navigation-controls__divider"
    if pageIndex.constructor == Array
      name += " is-current" if @state.currentPageIndex in pageIndex
    else
      name += " is-current" if @state.currentPageIndex == pageIndex
      name += " is-current" if @state.currentPageIndex in [1,2,3] and pageIndex in [1,2,3] and pageIndex <= @state.currentPageIndex
    name

  onChange: =>
    @setState({
      currentPage: NavigationStore.currentPage(),
      currentPageIndex: NavigationStore.getCurrentPageIndex(),
      allPages: NavigationStore.getPages(),
      allAnswers: QuestionnaireStore.getAnswers()
    })

  onClick: (pageIndex) ->
    if NavigationStore.isCurrentPageCompleted()
      if pageIndex.constructor == Array
        NavigationStore.setPage(pageIndex[0])
      else
        NavigationStore.setPage(pageIndex)
    else
      alert("""
        Sorry! You can't move onto other pages yet, as there are some required questions without answers.

        #{QuestionnaireStore.unansweredQuestionsForPage(NavigationStore.currentPage()).join("\n")}"
      """)
