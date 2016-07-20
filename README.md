# GRASP - GReat Apes Survival Partnership Database

This repository contains the source code of the GRASP database.

## Installation

GRASP is a Rails 4 app, using a Postgres database, built with Facebook's React.
Needless to say, make sure to have Ruby and Node.js installed. From there, it's
all pretty standard:

```
  $ git clone https://github.com/unepwcmc/grasp
  $ cd grasp
  $ bundle install
  $ npm install
  $ bundle exec rake db:create db:migrate
  $ bundle exec rake db:seed
  $ bundle exec rails server
  …
```

Visit `http://localhost:3000` and you should be good to go! 🎉

## Report structure Example (Draft)

```json
{
  "questions": {
    "own_organisation": {
      "id": "own_organisation",
      "visible": true,
      "type": "single",
      "question": "Are you reporting on behalf of your own organisation?",
      "required": true,
      "answers": ["Yes", "No"],
      "children": {
        "No": ["own_organisation_2"]
      }
    },
    "own_organisation_2": {
      "id": "own_organisation_2",
      "type": "single",
      "visible": false,
      "question": "hwhwhhwhwhwhwh",
      "required": true,
      "answers": ["Yes", "No"],
      "children": {
        "No": ["select_agency"]
      }
    },
    "select_agency": {
      "id": "select_agency",
      "visible": false,
      "type": "agency",
      "question": "Select agency",
      "answers": [{"id": 1, "name": "Agency One"}, {"id": 2, "name": "Agency Two"}],
      "children": {}
    },
    "date_of_discovery": {
      "id": "date_of_discovery",
      "visible": true,
      "type": "date",
      "question": "Date of discovery",
      "answers": [],
      "selected": "25/12/2016",
      "children": {}
    }
  },
  "pages": [
    ["own_organisation", "own_organisation_2"],
    ["date_of_discovery", "select_agency"]
  ],
  "state": "accepted",
  "validation_comment": "All good! :)"
}
```

# License

This repository lives under the [MIT license.](LICENSE)
