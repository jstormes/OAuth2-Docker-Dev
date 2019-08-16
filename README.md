# oauth2-docker-dev

Docker support environment for OAuth2 development on local machine.

TODO: Change the nomenclature in the filesystem and namespace from 
oauth2 and 'App' to Authorization Server.

# Preface 

As part of developing OAuth2 in PHP I needed a simple way to setup a
simulated cloud environment.  This git project supports development
of my sample OAuth2 Access server.  I am *not* trying to implement 
OpenID, just the best practice OAuth2 flows.

This system relies heavily on the OAuth2 libraries from the The League 
of Extraordinary Packages https://github.com/thephpleague.

My hope with this project is to provide a sample implementation of 
OAuth2 with Authentication that is tested and secure enough to use 
on the Internet at large. 

# Data sources for user credentials

I want to be able to cascade the sources for user credentials.  
Many times I have come across enterprise situations where the users
credentials need to come from multiple sources.  This is frequently 
Windows Active Directory over LDAP and MySQL a database.

# Data sources for clients

Many pre-existing systems lack an analogy for clients. So only 
the MySQL source will be used for Client IDs and Client secrets. 

# Data source for Scopes

Like users I want to get the scopes from multiple sources based on 
users and clients.  

## User Scopes

If the user is authenticated from LDAP I want to use LDAP groups
as available scopes for that user.

If the user has matching scopes in the MySQL database, these MySQL 
based scopes should also be available for the user.

## Client Scopes 

Clients will only be able to use scopes from the MySQL database.

# Using this project for local development

## Requirements

You must have a Git client, Docker and Docker Compose installed.
Ports 8080 thorough 8085 should also be unused on your development 
system.

## Cloning the Project

From a command line, pull this project from GitHub and include the 
submodules:

`git clone --recurse-submodules -j8 git@github.com:jstormes/oauth2-docker-dev.git`

## Interacting with the Project

To start the development environment:

`cd oauth2-docker-dev`

`docker-compose up`

It will take some time to start up.  During startup it will pull down a full
set of services including, MariaDB, Redis, OpenLDAP and tools to access 
these services.

After startup the Zend Project will be available at 
http://locahost:8080.

PhpMyAdmin will be available at http://locahost:8082.

RedisAdmin will be available at http://localhost:8081.

PhpLdapAdmin will be available at https://localhost:8083.

    Username: `cn=admin,dc=example,dc=org`

    Password: `admin`

To stop the development environment press `CTRL-C` in the running Docker Compose window. 
    
# Handy References:

https://stackoverflow.com/questions/997424/active-directory-vs-openldap

https://media.ccc.de/v/froscon2019-2334-how_not_to_use_oauth