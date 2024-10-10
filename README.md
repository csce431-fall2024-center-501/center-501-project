# Introduction

This repository creates the EWB (Engineers Without Boarders) website that they are able to use both internally and externally. The website uses Google OAuth for the users login. The login allows for Calendar and Email permissions that varies on the users status in the organization. The website also hosts much of the EWB information including their projects, sponsorship, and about pages. 


# Project Environment

This code has been run and tested using the following internal and external components

- Tools
    - Git Hub
    - VS Code
    - Jira
    - Robocop
    - Docker Image: FILL HERE

- Environment
    - Ruby version 3.1.2
    - Check Gemfile for any other version used

- Language / Runtimes
    - Ruby version 3.1.2

- Libraries
    - Rails version ~> 7.0.3

- External Dependencies
    - Github Actions for CI/CD
    - Postgres
    - Heroku


# Installation

1. Connect to the docker image provided
2. Open up docker in terminal
3. Clone the Github repo inside container
4. run 'bundle install'
5. Open up the repo and work away

# Building & Development

1. run 'rails server --binding=0.0.0.0'
2. Open up app using ['localhost:3000'](http://localhost:3000/)
3. Run any pending migrations

## Installation

- Install the latest version of docker
- Install ruby 3.1.2

## Environmental Variables/Files

Nothing as of now 

CREATE ENV HOST WE CAN PROVIDE HERE

## Execute Code

### Example:

Install the app

`bundle install && rails webpacker:install && rails db:create && db:migrate`


Run the app
`rails server --binding:0.0.0.0`


The application can be seen using a browser and navigating to http://localhost:3000/

## Tests

### Example:

An RSpec test suite is available and can be ran using:

`rspec spec/`

You can run all the test cases by running. This will run both the unit and integration tests.
`rspec .`

## Deployment

1. Start docker and work in the terminal
2. Login and open the Heroku Dashboard for monitoring the deployment
3. Merge the dev branch into the test branch 
4. Merge the test branch into the main branch
4. Heroku should automatically deploy once the code is pushed

# Documentation

### Example:

Our product and sprint backlog can be found in [Jira](https://center-501.atlassian.net/jira/software/projects/EWB/boards/1/backlog) 

# Our Team

- Ryan Pavlik
- Kevin Johnson
- Sara Dyl
- Pearlynn Toh
Kaili Fogle

