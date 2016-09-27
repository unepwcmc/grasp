FactoryGirl.define do
  factory :report do
    data do
      {
        'questions': {
          # Put each question as an object here
          "own_organisation": {
            "id": "own_organisation",
            "visible": true,
            "type": "single",
            "question": "Are you reporting an incident observed by your own agency or an incident observed by another agency?",
            "answers": ["Own Agency", "Another Agency"],
            "required": true,
            "children": {
              "Yes": ["new_agency_contact"]
            }
          }
        }
      }
    end
    user # Report belongs to
  end
end

