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
      {@renderAppropriateQuestion()}
    </div>

  renderAppropriateQuestion: =>
    switch @props.data.type
      when "single"           then <SingleAnswerQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "agency"           then <AgencyQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "date"             then <DateQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "text"             then <TextQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "file"             then <FileQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "numeric"          then <NumericQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "decimal_numeric"  then <DecimalNumericQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "form"             then <Form
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "multi"            then <MultiAnswerQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>
      when "gps"              then <GpsQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data}/>

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
