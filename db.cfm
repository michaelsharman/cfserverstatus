<cfsetting enablecfoutputonly="true">

<cfscript>
	// Connect to the database server and run a simple query. This doesn't talk to a specific database table, just selects "now()"
	// Returns "true" (status code 200) if successful, otherwise an error message (status code 500)
	// You must have a valid datasource in the railo-web.xml.cfm to be set in the local variable `dsn_ro`
	try
	{
		dsn_ro = "<add datasource here>";
		output = "";
		q = new Query();
		sql = "SELECT now()";

		q.setDatasource(dsn_ro);
		q.setSQL(sql);
		result = q.execute().getResult();

		if (result.recordCount)
		{
			output = true;
		}
	}
	catch (any e)
	{
		output = e.message;
		getPageContext().getResponse().setstatus(500);
	}

	writeOutput(output);
</cfscript>
