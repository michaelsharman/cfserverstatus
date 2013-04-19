# ColdFusion status page(s)

The scripts here can be used to help test the health of ColdFusion/Railo application server(s).

## Configuration
This package should be run as a separate vhost, within an application server environment. Each script is self contained and can be run either independantly or as a suite.

## Scripts
### railo.cfm
Simply execute a .cfm template on a ColdFusion based application server (typically a railo node running on tomcat); no database or external requests are made. The puropose is to determine whether the application server can execute ColdFusio code.
Returns "true" if the script ran successfully.

### db.cfm
Makes a request to a database and runs a basic SELECT to a mysql function. Needs a datasource with SELECT priviliges, but doesn't talk to any tables so a simple database user is all that's required.
Returns "true" if a database connection was made.
Returns a 500 status code and error message if an exception was thrown.

### session.cfm
Tests whether the session scope is available. Attemps are made to read/write from the session scope.
Returns "true" if the session scope could be written to (and read from).
Returns an error message (and 500 status code) if not.

## Running
Just call any .cfm file (listed above). Nothing else needs doing :)