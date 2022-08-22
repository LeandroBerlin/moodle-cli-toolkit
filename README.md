# Moodle CLI Toolkit

A CLI to setup and manage a local Moodle development environment

## It uses
- [Moodle](https://github.com/moodle/moodle)
- [Moodle Docker](https://github.com/moodlehq/moodle-docker)

## Features
* All supported database servers (PostgreSQL, MySQL, Micosoft SQL Server, Oracle XE)
* Behat/Selenium configuration for Firefox and Chrome
* Catch-all smtp server and web interface to messages using [MailHog](https://github.com/mailhog/MailHog/)
* All PHP Extensions enabled configured for external services (e.g. solr, ldap)
* All supported PHP versions
* Zero-configuration approach
* Backed by [automated tests](https://travis-ci.com/moodlehq/moodle-docker/branches)


## Prerequisites
Moodle Docker requires
* [Docker](https://docs.docker.com) and [Docker Compose](https://docs.docker.com/compose/cli-command/#installing-compose-v2) installed if your Docker CLI version does not support `docker compose` command.
* 3.25GB of RAM (if you choose [Microsoft SQL Server](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup#prerequisites) as db server)


## Quick start
- clone this repo  
`git clone https://github.com/LeandroBerlin/moodle-cli-toolkit`
- change executing permissions  
`cd moodle-cli-toolkit && chmod +x cli.sh`
- set local variable
```export MOODLE_DOCKER_WWWROOT=$(pwd)/moodle/
export MOODLE_DOCKER_WWWROOT=$(pwd)/moodle/
export MOODLE_DOCKER_PATH=$(pwd)/moodle-docker/
export MOODLE_DOCKER_DB=pgsql
export MOODLE_DOCKER_PHP_VERSION=7.3
```
- change the configuration in the cli.sh script (optional)
- run the setup script  
`./cli.sh --setup`


## Commands

Syntax: cli.sh [--setup|--start|--stop|--delete|--reset|--help]     

options:  
--setup    Setup and launch the development environment  
--start    Start the development environment  
--stop     Stop the development environment  
--delete   Stop and delete the docker containers  
--reset    Cleanup, remove docker and Moodle dirs  
--help     Print this help.
