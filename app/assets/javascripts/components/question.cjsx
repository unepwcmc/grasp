_ = require("underscore")
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
BodyPartsQuestion      = require("components/questions/body_parts_question")

Tooltip = require("components/tooltip")

class Question extends React.Component
  ALWAYS_OPEN_QUESTIONS = [
    "quantities", "multi", "subspecies",
    "gps", "body_parts", "form", "text",
    "numeric", "file", "decimal_numeric"
  ]

  constructor: (props, context) ->
    super(props, context)
    @state = {hidden: false}

  componentWillReceiveProps: (nextProps) =>
    selected = nextProps.answer?.selected
    notOtherAnswer = selected != "other" and not _.contains(@props.data.other_answers, selected)
    alwaysOpen = @props.data.type not in ALWAYS_OPEN_QUESTIONS

    if nextProps.answered and notOtherAnswer and alwaysOpen
      @setState(hidden: true)
    if not nextProps.answered and @props.answered
      @setState(hidden: false)

  render: =>
    <div className="question">
      <h5 onClick={@toggleQuestion} className={@titleClassName()}>
        <strong>{@props.data.question}</strong>
        {@renderToggleChevron()}
      </h5>
      {@renderQuestionBody()}
    </div>


  renderToggleChevron: =>
    <i className={@toggleClassName()}></i> if @props.mode != "show"

  toggleClassName: =>
    className = "fa u-pull-right"
    className += (if @state.hidden then " fa-chevron-down" else " fa-chevron-up")
    className

  titleClassName: =>
    className = "question__title"
    className += " is-inactive"  if @state.hidden
    className += " is-completed" if @props.answered
    className

  renderQuestionBody: =>
    return if @state.hidden and not @props.answered

    if (@state.hidden and @props.answered) or @props.mode == "show"
      @renderAppropriateAnswer()
    else
      [@renderTooltip(), @renderAppropriateQuestion()]

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
      when "body_parts"       then <BodyPartsQuestion
                                    onChange={@handleChange}
                                    data={@props.data} answer={@props.answer} mode={@props.mode}/>

  renderAppropriateAnswer: =>
    return <p>N/A</p> unless @props.answer?.selected

    general = @renderAnswerLabel(@props.answer)
    switch @props.data.type
      when "single"           then general
      when "select"           then general
      when "agency"           then general
      when "date"             then general
      when "text"             then general
      when "numeric"          then general
      when "decimal_numeric"  then general
      when "form"             then general
      when "file"
        if @props.answer?.selected?.length > 0
          <ul>
            {_.map(@props.answer?.selected, (image) ->
              <li className="answer" key={image.id}><img src={image.url} width=48></img></li>
            )}
          </ul>
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

  renderAnswerLabel: (answer) =>
    isString = answer.selected.constructor == String
    matches = if isString then answer.selected.match(/(.*) \((.*)\)/) else false
    isAnOtherAnswer = _.contains(@props.data.other_answers, answer.selected)

    if not isAnOtherAnswer and isString and matches
      <p>{matches[1]} (<em>{matches[2]}</em>)</p>
    else if answer.selected == "other"
      <p>Other: {answer.other_answer} </p>
    else if isAnOtherAnswer
      <p>{answer.selected}: {answer.other_answer} </p>
    else
      <p>{answer.selected}</p>

  renderOtherField: =>
    if "other" == @props.answer?.selected
      <input type="text" value={@props.data.other_answer}
        onChange={@handleOtherChange}/>

  handleChange: (e) =>
    answer = if e?.target then e.target.value else e
    QuestionnaireStore.selectAnswer(@props.data.id, answer)

  handleOtherChange: (e) =>
    answer = if e?.target then e.target.value else e
    QuestionnaireStore.updateOtherAnswer(@props.data.id, answer)

  toggleQuestion: =>
    @setState({hidden: !@state.hidden}) unless @props.mode == "show"

module.exports = Question
