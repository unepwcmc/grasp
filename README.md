# GRASP - GReat Apes Survival Partnership Database

This repository contains the source code of the GRASP database.

## Installation

GRASP is a Rails 4 app, using a Postgres database. Installation is pretty standard:

```
  $ git clone https://github.com/unepwcmc/grasp
  $ cd grasp
  $ bundle install
  $ bundle exec rake db:create db:migrate
  …

  $ bundle exec rails server
  …
```

Visit `http://localhost:3000` and you should be good to go! 🎉

## Report structure Example (Draft)

```json
{
  "questions": {
    "own_organisation": {
      "type": "single",
      "question": "Are you reporting on behalf of your own organisation?",
      "answers": ["Yes", "No"],
      "selected": "Yes",
      "children": {
        "No": ["select_agency"]
      }
    },
    "select_agency": {
      "hidden_at_start": true,
      "type": "agency",
      "question": "Select agency",
      "answers": [{"id": 1, "name": "Agency One"}, {"id": 2, "name": "Agency Two"}],
      "selected": {"id": 1, "name": "Agency One"},
      "children": {}
    },
    "date_of_discovery": {
      "id": "date_of_discovery",
      "type": "date",
      "question": "Date of discovery",
      "answers": [],
      "selected": "25/12/2016",
      "children": {}
    }
  },
  "structure": [
    ["own_organisation", "select_agency"],
    ["date_of_discovery"]
  ],
  "state": "accepted",
  "validation_comment": "All good! :)"
}
```

# License

This repository lives under the [MIT license.](LICENSE)
