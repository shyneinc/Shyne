# SHYNE ![CircleCI build status of the default branch][1]

## First-time install & run

``git clone git@github.com:shyneinc/shyne-dev-box.git``

``cd shyne-dev-box``

``git clone git@github.com:shyneinc/Shyne.git``

``vagrant up``

``vagrant ssh``

``cd /vagrant/Shyne``

``bundle install``

``bundle exec rake db:setup``

``cp sample.env .env`` (.env file is need at the root for foreman)

``foreman start``

## Git development workflow

Install git-flow: See the Wiki for up-to-date [Installation Instructions](https://github.com/nvie/gitflow/wiki/Installation).

Please make sure to **always rebase instead of merge** to keep our commit history clean, linear and readable.

If you use ``git pull`` or a GUI client, run this command to ensure new commits are rebased rather than merged:

``git config --global pull.rebase true``

### Start

``git fetch origin``

``git rebase origin/develop develop``

``git flow feature start name-of-feature``

``hack hack hack``

### Finish

Before pushing any code please **make sure all tests are passing!**

``git fetch origin``

``git rebase origin/develop develop``

``git rebase develop feature/name-of-feature``

``git flow feature finish name-of-feature``

``git push origin develop``

## Testing

Run this to execute the API test suite:

``rake db:test:prepare``

``rspec spec`` OR ``bundle exec guard``

## Deployment

### Staging

Deployments to [staging.shyne.io](http://staging.shyne.io) happen continuously through CircleCI & [heroku_san](https://github.com/fastestforward/heroku_san) every time a commit is made to the develop branch.

### Production

Deployments to [www.shyne.io](http://www.shyne.io) happen similar to staging but only when a release is create through git-flow (never push directly to master):

``git flow release start X.X.X``

``Bump asset versions if needed``

``git folow relese finish X.X.X``

``git push origin master develop --tags``

## Documentation

API documentation is located at `/docs` and is generated using passing acceptance tests.

Run this to regenerate the docs: `rake docs:generate`

## Coding Style

To keep our codebase clean, uniform and readable let's follow the coding styleguide prescribed by GitHub: https://github.com/styleguide

## Gotchas

For shyne-staging, make sure [user-env-compile](https://devcenter.heroku.com/articles/labs-user-env-compile) add-on is enabled on Heroku for rake assets:precompile to work properly.

  [1]: https://circleci.com/gh/shyneinc/Shyne.png?circle-token=84572cf098f3e783ea27317ada59cde54c386547