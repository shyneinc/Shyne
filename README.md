# SHYNE ![CircleCI build status of the default branch][1]

## First-time install

``git clone git@github.com:shyneinc/Shyne.git``

``cd Shyne``

``bundle install``

``bundle exec rake db:setup``

``rails s``

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

We will be using [heroku_san](https://github.com/fastestforward/heroku_san) to manage deployments.

To deploy to dev.shyne.io use:

``rake development deploy``

## Documentation

API documentation is located at `/docs` and is generated using passing acceptance tests.

Run this to regenerate the docs: `rake docs:generate`

## Coding Style

To keep our codebase clean, uniform and readable let's follow the coding styleguide prescribed by GitHub: https://github.com/styleguide


  [1]: https://circleci.com/gh/shyneinc/Shyne.png?circle-token=f98ef1503c88afd9129d9a5e7319d8658228120a