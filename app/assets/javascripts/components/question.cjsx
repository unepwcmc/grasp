React = require("react")
QuestionnaireStore = require("stores/questionnaire_store")

# Question types
SingleAnswerQuestion   = require("components/questions/single_answer_question")
SubspeciesQuestion     = require("components/questions/subspecies_question")
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
SelectQuestion         = require("components/questions/select_question")

Tooltip = require("components/tooltip")

class Question extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: =>
    <div className="question">
      <h5><strong>{@props.data.question}</strong></h5>
      {@renderTooltip()}
      {@renderAppropriateAnswer()}
      {@renderAppropriateQuestion()}
    </div>

  renderTooltip: =>
    return null unless @props.data.tooltip
    <Tooltip text={@props.data.tooltip}/>

  renderAppropriateQuestion: =>
    return null if @props.mode != "edit"
    switch @props.data.type
      when "single"           then <SingleAnswerQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "agency"           then <AgencyQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "date"             then <DateQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "text"             then <TextQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "file"             then <FileQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "quantities"       then <QuantitiesQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "numeric"          then <NumericQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "decimal_numeric"  then <DecimalNumericQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "form"             then <Form
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "multi"            then <MultiAnswerQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "gps"              then <GpsQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "subspecies"       then <SubspeciesQuestion
                                    onChange={@handleChange} onOtherChange={@handleOtherChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>
      when "select"           then <SelectQuestion
                                    onChange={@handleChange} emptyOption={@props.data.question}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>

  renderAppropriateAnswer: =>
    return null if @props.mode != "show" or !@props.answer?.selected?
    general = <p>{@props.answer?.selected}</p>

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
        if @props.answer?.selected?.length > 0
          <ul>
            {<li key={select}>{select}</li> for select in @props.answer?.selected}
          </ul>
      when "gps"
        <div>
          <p>Latitude: {@props.answer?.selected.lat}</p>
          <p>Longitude: {@props.answer?.selected.lng}</p>
        </div>
      when "quantities"
        <div>
          <p>Live: {@props.answer?.selected.live}</p>
          <p>Dead: {@props.answer?.selected.dead}</p>
          <p>Body parts: {"✓" if @props.answer?.selected.body_parts}</p>
        </div>
      when "subspecies"
        <div>
          {general}
          <p>DNA Confirmation: {"✓" if @props.answer?.dna_confirmation}</p>
        </div>

  renderOtherField: =>
    if "other" == @props.answer?.selected
      <input type="text" value={@props.data.other_answer}
        onChange={@handleOtherChange}/>

  handleChange: (e) =>
    answer = e.target.value
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

  handleOtherChange: (e) =>
    QuestionnaireStore.updateOtherAnswer(@props.data.id, e.target.value)

module.exports = Question
