_ = require("underscore")

module.exports = class UserFormHandler
  @initialize: ->
    $roleSelectionEl = $(".js-role-selection")
    $expertiseFormEl = $(".js-form-expertise")

    if _.some($roleSelectionEl) and _.some($expertiseFormEl)
      @handleRoleSelection($roleSelectionEl, $expertiseFormEl)

  @handleRoleSelection: ($roleSelectionEl, $expertiseFormEl) ->
    $roleSelectionEl.change( (e) ->
      $el = $(e.target)
      selected = $el.find("option:selected").text().toLowerCase()

      if selected in ["admin", "validator"]
        $expertiseFormEl.show()
      else
        $expertiseFormEl.hide()
    )


