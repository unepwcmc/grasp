React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")

# Question types
SingleAnswerQuestion   = require("components/questions/single_answer_question")
MultiAnswerQuestion    = require("components/questions/multi_answer_question")
AgencyQuestion         = require("components/questions/agency_question")
DateQuestion           = require("components/questions/date_question")
TextQuestion           = require("components/questions/text_question")
FileQuestion           = require("components/questions/file_question")
Form                   = require("components/questions/form")
NumericQuestion        = require("components/questions/numeric_question")
QuantitiesQuestion     = require("components/questions/quantities_question")
DecimalNumericQuestion = require("components/questions/decimal_numeric_question")
GpsQuestion            = require("components/questions/gps_question")

class Question extends React.Component
  constructor: (props, context) ->
    super(props, context)
    QuestionnaireStore.addVisibilityListener(@onVisibilityChange)
    @state = {}

  render: =>
    <div className="question">
      <h3>{@props.data.question}</h3>
      {@renderAppropriateAnswer()}
      {@renderAppropriateQuestion()}
    </div>

  renderAppropriateQuestion: =>
    return null if @props.mode != "edit"
    switch @props.data.type
      when "single"           then <SingleAnswerQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "agency"           then <AgencyQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "date"             then <DateQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "text"             then <TextQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "file"             then <FileQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "quantities"       then <QuantitiesQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "numeric"          then <NumericQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "decimal_numeric"  then <DecimalNumericQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "form"             then <Form
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "multi"            then <MultiAnswerQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>
      when "gps"              then <GpsQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} mode={@props.mode}/>

  renderAppropriateAnswer: =>
    return null if @props.mode != "show" or !@props.data.selected?
    general = <p>{@props.data.selected}</p>

    switch @props.data.type
      when "single"           then general
      when "agency"           then general
      when "date"             then general
      when "text"             then general
      when "file"             then general
      when "numeric"          then general
      when "decimal_numeric"  then general
      when "form"             then general
      when "multi"
        if @props.data.selected?.length > 0
          <ul>
            {<li key={select}>{select}</li> for select in @props.data.selected}
          </ul>
      when "gps"
        <div>
          <p>Latitude: {@props.data.selected.lat}</p>
          <p>Longitude: {@props.data.selected.lng}</p>
        </div>
      when "quantities"
        <div>
          <p>Live: {@props.data.selected.live}</p>
          <p>Dead: {@props.data.selected.dead}</p>
          <p>Body parts: {"✓" if @props.data.selected.body_parts}</p>
        </div>

  renderOtherField: =>
    if "other" == @props.data.selected
      <input type="text" value={@props.data.other_answer}
        onChange={@handleOtherChange}/>

  handleChange: (e) =>
    answer = e.target.value
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

    @showChildrenFor(answer)

  handleOtherChange: (e) =>
    QuestionnaireStore.updateOtherAnswer(@props.data.id, e.target.value)

  displayStyle: => if @props.mode == "edit" then {display: "none"}  else {display: "block"}
  editStyle:    => if @props.mode == "edit" then {display: "block"} else {display: "none"}

  showChildrenFor: (chosen) ->
    for answer, children of @props.data.children
      if chosen == answer
        QuestionnaireStore.show(child) for child in children
      else
        QuestionnaireStore.hide(child) for child in children

  onVisibilityChange: (key, change) =>
    return if key != @props.data.id

    if(change == "hide")
      @showChildrenFor(null)
    else
      @showChildrenFor(@props.data.selected)

module.exports = Question
