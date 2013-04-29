<cfsetting enablecfoutputonly="true">

<cfscript>
	// Tests whether the session scope is available. Returns `true` if successful, or an error message (and 500 status code) if not
	try
	{
		session.output = true;
		output = session.output;
	}
	catch (any e)
	{
		output = e.message;
		getPageContext().getResponse().setstatus(500);
	}

	writeOutput(output);
</cfscript>
