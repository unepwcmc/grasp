{EventEmitter} = require("events")

class NavigationStore extends EventEmitter
  PAGE_CHANGE_EVENT = "page_change"
  currentPage = 0

  currentPage: ->
    currentPage

  previousPage: ->
    currentPage -= 1
    window.scrollTo(0, 0)
    @emit(PAGE_CHANGE_EVENT)

  nextPage: ->
    currentPage += 1
    window.scrollTo(0, 0)
    @emit(PAGE_CHANGE_EVENT)

  addPageChangeListener: (callback) =>
    @on(PAGE_CHANGE_EVENT, callback)


module.exports = new NavigationStore()
