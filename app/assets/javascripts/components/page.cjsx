React = require("react")
QuestionnaireStore   = require("stores/questionnaire_store")
SingleAnswerQuestion = require("components/questions/single_answer_question")
AgencyQuestion       = require("components/questions/agency_question")
DateQuestion         = require("components/questions/date_question")
TextQuestion         = require("components/questions/text_question")
FileQuestion         = require("components/questions/file_question")
Form                 = require("components/questions/form")

module.exports = class Page extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <div>{@renderQuestions()}</div>

  renderQuestions: =>
    @props.questions.map( (question) ->
      switch question.type
        when "single"     then <SingleAnswerQuestion key={question.id} data={question}/>
        when "agency"     then <AgencyQuestion       key={question.id} data={question}/>
        when "date"       then <DateQuestion         key={question.id} data={question}/>
        when "text"       then <TextQuestion         key={question.id} data={question}/>
        when "file"       then <FileQuestion         key={question.id} data={question}/>
        when "form"       then <Form                 key={question.id} data={question}/>
    )
