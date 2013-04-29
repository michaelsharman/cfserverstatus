# ColdFusion status page(s)

The scripts here can be used to help test the health of ColdFusion/Railo application server(s). You can either use them ad hoc or set them up as part of your nagios (etc) reporting.

## Configuration
This package should be loaded as a separate vhost, within an application server environment. Each script is self contained (has no dependencies) and can be run either independently or as a suite.

## Scripts
### cf.cfm
Simply executes a .cfm template on a ColdFusion based application server (for us, typically a railo node running on tomcat); no database or external requests are made.

 * Purpose - to determine whether the application server can execute ColdFusion code
 * Returns - "true" if the script ran successfully

### db.cfm
Makes a request to a database and runs a basic SELECT statement calling a mysql function. Needs a datasource with SELECT privileges, but doesn't talk to any tables so a simple database user is all that's required.

* Purpose - to determine connectivity from a ColdFusion application server to a database server
* Returns - "true" if a database connection was made
* Returns - a 500 status code and error message if an exception was thrown

### outbound.cfm
Makes a cfhttp HEAD request to a public URL (google)

* Purpose - Tests whether outbound connections are allowed from the application server
* Returns - "true" if a connection was made and the status code was either 200 or 302. Returns the actual status code if other
* Returns - a 500 status code and error message if an exception was thrown

### server_info.cfm
Returns a ColdFusion structure (dump) of information about the instance including the number of applications running and Java memory allocation etc

* Purpose - Check Java memory usage and application information

### sessioncount_external.cfm
Returns a count (Int) of the number of active sessions on the node/instance where the script is run outside of the target applications WEB-INF
You man need to enable "Application.cfc_" (ie remove the trailing _) to prevent the application server bubbling up to find an Application.cfc
	
* Purpose - Checks the amount of active sessions
* Returns - An integer count of sessions in an application specific scope
* Returns - a 500 status code and error message if an exception was thrown

### sessioncount_internal.cfm
Returns a count (Int) of the number of active sessions of an application where this script runs in the same WEB-INF as the application

* Purpose - Checks the amount of active sessions
* Returns - An integer count of sessions in the current application scope
* Returns - a 500 status code and error message if an exception was thrown

### sessions_enabled.cfm
Attempts are made to read/write from the session scope.

* Purpose - Tests whether the session scope is available
* Returns - "true" if the session scope could be written to (and read from)
* Returns - an error message (and 500 status code) if not

## How to run
After you setup this project as a vhost (can be a sub-directory), just call any .cfm file (listed above). Nothing else needs doing :)
