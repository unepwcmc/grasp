class @Questionnaire extends React.Component
  render: ->
    window.questions = {}
    <div className="questions">
      <SingleAnswerQuestion id="own_organisation" data={questionnaire_json.questions.own_organisation}/>
      <SingleAnswerQuestion id="own_organisation_2" data={questionnaire_json.questions.own_organisation_2}/>
      <AgencyQuestion id="select_agency" data={questionnaire_json.questions.select_agency}/>
    </div>
