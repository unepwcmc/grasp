# GRASP - GReat Apes Survival Partnership Database

This repository contains the source code of the GRASP database.

## Installation

GRASP is a Rails 4 app, using a Postgres database, built with Facebook's React.
Needless to say, make sure to have Ruby and Node.js installed. From there, it's
all pretty standard:

Dependencies:
* Ruby v2.3.1

In Linux (with rbenv) ensure you have OpenSSL lib installed before proceeding to install Ruby v2.3.1:
```
sudo apt install libssl1.0-dev
rbenv install 2.3.1
```

Note also that the version of bundler used `cat Gemfile.lock` is 1.12.5:

```
BUNDLED WITH
   1.12.5
```

So, (if you don't already have 2.3.1 installed) you should install that version:

```
gem install bundler -v 1.12.5
```

If you already have multiple versions of bundler installed, you can specify the version when using it like so:

```
bundle _1.12.5_ install
```

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
