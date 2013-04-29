<cfsetting enablecfoutputonly="true">

<cfscript>
	// Returns a count (Int) of the number of active sessions on the node/instance
	// This script MUST be run in the same WEB-INF as the application you
	// want to track.
	try
	{
		// The name of the application on this node/instance that you want session information for
		appName = application.getApplicationSettings().name;

		sessionTracker = createObject("java", "coldfusion.runtime.SessionTracker");
		// Total struct of sessions for a specific app
		appSessions = sessionTracker.getSessionCollection(appName);
		output = structCount(appSessions);
	}
	catch (any e)
	{
		output = e.message;
		getPageContext().getResponse().setstatus(500);
	}

	writeOutput(output);
</cfscript>
