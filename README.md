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

# License

This repository lives under the [MIT license.](LICENSE)
