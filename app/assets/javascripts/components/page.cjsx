React = require("react")
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

module.exports = class Page extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <div>
      <h1 className="page__title">{@props.data.title}</h1>
      <div>{@renderQuestions()}</div>
    </div>

  renderQuestions: =>
    @props.data.questions.map( (question) =>
      switch question.type
        when "single"           then <SingleAnswerQuestion   mode={@props.mode} key={question.id} data={question}/>
        when "agency"           then <AgencyQuestion         mode={@props.mode} key={question.id} data={question}/>
        when "date"             then <DateQuestion           mode={@props.mode} key={question.id} data={question}/>
        when "text"             then <TextQuestion           mode={@props.mode} key={question.id} data={question}/>
        when "file"             then <FileQuestion           mode={@props.mode} key={question.id} data={question}/>
        when "numeric"          then <NumericQuestion        mode={@props.mode} key={question.id} data={question}/>
        when "decimal_numeric"  then <DecimalNumericQuestion mode={@props.mode} key={question.id} data={question}/>
        when "form"             then <Form                   mode={@props.mode} key={question.id} data={question}/>
        when "multi"            then <MultiAnswerQuestion    mode={@props.mode} key={question.id} data={question}/>
        when "gps"              then <GpsQuestion            mode={@props.mode} key={question.id} data={question}/>
    )
