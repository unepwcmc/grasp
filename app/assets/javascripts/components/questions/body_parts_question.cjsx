_ = require("underscore")
React = require("react")
Question = require("components/question")
NumericQuestion = require("components/questions/numeric_question")
DecimalNumericQuestion = require("components/questions/decimal_numeric_question")
QuestionnaireStore = require("stores/questionnaire_store")

class BodyPartsQuestion extends React.Component
  render: ->
    <div>
      {@renderParts()}
    </div>

  renderParts: =>
    _.map(@props.data.parts, (part) =>
      <div className="answer__subpart">{@renderAppropriateQuestion(part)}</div>
    )

  renderAppropriateQuestion: (part) =>
    switch part.type
      when "numeric"         then <NumericQuestion onChange={@handleChangeFor(part)}
                                   partName={part.question} answer={@props.answer?.parts?[part.id]}/>
      when "decimal_numeric" then <DecimalNumericQuestion onChange={@handleChangeFor(part)}
                                   partName={part.question} answer={@props.answer?.parts?[part.id]}/>

  handleChangeFor: (part) =>
    (answer) => QuestionnaireStore.selectPart(@props.data.id, part.id, answer)


module.exports = BodyPartsQuestion
