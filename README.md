# SHYNE

***

## First-time install

``git clone git@github.com:shyneinc/Shyne.git``

``cd Shyne``

``bundle install``

``bundle exec rake db:setup``

``rails s``

***

## Git development workflow

Install git-flow: See the Wiki for up-to-date [Installation Instructions](https://github.com/nvie/gitflow/wiki/Installation).

### Start

``git fetch origin``

``git rebase origin/develop develop``

``git flow feature start name-of-feature``

``hack hack hack``

### Finish

``git fetch origin``

``git rebase origin/develop develop``

``git flow feature rebase new_feature``

``git flow feature finish name-of-feature``

``git push origin develop``

***

## Testing

Run this to execute the API test suite:

``rake db:migrate RAILS_ENV=test``

``rspec spec``

***

## Documentation

API documentation is located at `/docs` and is generated using passing acceptance tests.

Run this to regenerate the docs: `rake docs:generate`