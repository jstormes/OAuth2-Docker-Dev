# oauth2-docker-dev
Docker support files for OAauth2 development on local machine.

This git repository supports the development of my Zend Expressive OAuth2
project.

You must have Docker and Docker Compose installed.

To start the development environment, run the following from the projects' home directory:

`docker-compose up`

After startup the OAuth2 Zend Application will be available at http://locahost:8080.

PhpMyAdmin will be available at http://locahost:8082.

RedisAdmin will be available at http://localhost:8081.

PhpLdapAdmin will be available at https://localhost:8083.

    Username: `cn=admin,dc=example,dc=org`

    Password: `admin`
    
 NOTES: https://stackoverflow.com/questions/997424/active-directory-vs-openldap
