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
    @props.data.questions.map( (question) ->
      switch question.type
        when "single"           then <SingleAnswerQuestion   key={question.id} data={question}/>
        when "agency"           then <AgencyQuestion         key={question.id} data={question}/>
        when "date"             then <DateQuestion           key={question.id} data={question}/>
        when "text"             then <TextQuestion           key={question.id} data={question}/>
        when "file"             then <FileQuestion           key={question.id} data={question}/>
        when "numeric"          then <NumericQuestion        key={question.id} data={question}/>
        when "decimal_numeric"  then <DecimalNumericQuestion key={question.id} data={question}/>
        when "form"             then <Form                   key={question.id} data={question}/>
        when "multi"            then <MultiAnswerQuestion    key={question.id} data={question}/>
        when "gps"              then <GpsQuestion            key={question.id} data={question}/>
    )
