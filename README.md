# README
This README would normally document whatever steps are necessary to get your application up and running.

## Table of contents

  - [Setting up](#setting-up)
    - [Prerequisites](#prerequisites)
    - [Install Dependencies](#install-dependencies)
    - [Project Configuration](#project-configuration)
    - [Database Configuration](#database-configuration)
      - [Configure Application Variables](#configure-application-variables)
      - [Create a User](#create-a-user)
      - [Update Endpoint](#update-endpoint)
      - [Running the Project](#running-the-project)
    - [How to run tests](#how-to-run-tests)
    - [Deployment instructions](#deployment-instructions)
  - [Sending emails in development](#sending-emails-in-development)
    - [Set up](#set-up)
    - [MailCatcher](#mailcatcher)
      - [Installing](#installing)
      - [Set up](#set-up-1)
      - [Visualizaing The Emails](#visualizaing-the-emails)
    - [Sending Email From Console](#sending-email-from-console)
  - [Accessing the running production server](#accessing-the-running-production-server)
  - [Contribution guidelines](#contribution-guidelines)
  - [Who do I talk to?](#who-do-i-talk-to)

## Setting up

### Prerequisites

The following dependencies and versions are used in this project, make sure you have installed them in the correct versions to avoid errors.

- **rbenv**: 1.1.2
- **ruby**: 2.1.5
- **rails**: 4.1.8
- **bundler**: 1.8.4
- **postgresql**: 10.10
- **redis**: 4.0.9

### Install Dependencies

```shell
$ cd on_rocket_app
$ bundle install
```

### Project Configuration

### Database Configuration

* If you don't have a postgres database, create one, here we call it *points_production*:

```shell
$ createdb points_production
```

* Enter the production environment:

```shell
$ ssh deploy@5.9.145.198 -p 2222
```

* Get the name of the most recent database dump file:

```shell
$ ll /var/pgdump/Ubuntu-1604-xenial-64-minimal_communities* | tail -1
$ exit
```

* Download the database dump:

```shell
$ scp -P 2222 deploy@5.9.145.198:/var/pgdump/<name-of-file.sql.gz> communities_dump.sql.gz <destination-path>
```

* Import the database dump to the local database:

```shell
$ gunzip <path/communities_dump.sql.gz>
$ psql -h local -U postgres -d <database-name> < communities_dump.sql
```

#### Configure Application Variables

First, copy the file *config/application.yml.example* and rename it to *config/application.yml*.

Update the **DATABASE_NAME**, **DATABASE_USERNAME**, **SECRET_KEY_BASE** and **DATABASE_URL** variables by setting the values set on your machine.

#### Create a User

To use the application you must have a user with admin access. To do this, run the commands:

```shell
$ bundle exec rails c
> User.create(user: "xxxx", password: "xxxx", email: "xxxx")
> User.find_by(email: "xxxx").update(admin: true)
```

#### Update Endpoint

When running the application locally, you must update the _URL_ of the client you want to use.

Run the commands:

```shell
$ bundle exec rails c
> ts
```

The **ts** command returns a list of client **subdomains** and their _URLs_.

You have to get the expected subdomain you want to use and update it by changing the `.communities.points.rocket.com` _URL_ to `.lvh.me:3000`, by doing this you can have access locally. Let's say you want to use melissa client:

```shell
> Domain.find_by(subdomain: "melissa").update(url: "http://melissa.lvh.me:3000")
```

#### Running the Project

Run the command to run the project locally:

```shell
$ bundle exec rails s
```

### How to run tests

TODO 

### Deployment instructions

* Deploy in production environment:

```shell
$ bundle exec cap communities deploy
```

* Deploy in staging environment:

```shell
$ bundle exec cap staging_communities deploy
```

## Sending emails in development

### Set up

In the `config/environments/development.rb`, set the **config.action_mailer.perform_deliveries** constant to **true**.

### MailCatcher

Another option for testing sending emails in development mode is MailCatcher gem, which allows you to send and view the emails in the browser.

#### Installing

```shell
$ gem install mailcatcher
$ mailcatcher
```

#### Set up

Add in the `environment/development.rb` file the lines:

```
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
```

If you want to load the assets used in emails from another source, add the line and set the url:

```
config.action_mailer.asset_host = '<url>' 
```

#### Visualizaing The Emails

Sent emails can be viewed at http://127.0.0.1:1080/.

### Sending Email From Console

Example of sending an email from console.

```shell
$ bundle exec rails c
> user = User.find_by(id: 11)
> EmployeeAdvocacyMailer.new_post_email(user, EmployeeAdvocacyPost.first, current_domain).deliver!
```

Above was used the `EmployeeAdvocacyMailer`, but other mailers that are in the `app/mailers` can be used.

## Accessing the running production server

- In the `config/deploy/communities.rb` file, change in the line 21 `'production.pointsrocket.com'` to `'5.9.145.198'`.
- In the `config/application.yml`, set the **SUBDOMAIN_AS_COMMUNITIES** constant to "false".
- In the `lib/capistrano/tasks/console.rb` file, add in the lines 16 and 17 **-p 2222** after the *{host}*.
- In the root of the project, run the command:
```shell
$ echo 2.1.5 > .ruby-version
```
- Finally, run the command to enter in the production console:
```shell
$ bundle exec cap communities console
```

## Contribution guidelines

TODO

## Who do I talk to?

TODO# pointsrocket-base
