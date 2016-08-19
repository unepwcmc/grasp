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

You will need a `.env` file which you can steal from another developer or copy from the `.env.example` provided

Visit `http://localhost:3000` and you should be good to go! 🎉

# Questionnaires and reports

A bit of glossary: `provider` users submit `reports` by answering `questions` in `questionnaires`. The questionnaire
template resides in the `config` folder. [Give it a look](config/questionnaire) to understand how questionnaires
are structured.

# License

This repository lives under the [MIT license.](LICENSE)
