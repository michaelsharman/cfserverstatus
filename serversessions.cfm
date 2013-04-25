<cfsetting enablecfoutputonly="true">

<cfscript>
	// Returns a count (Int) of the number of active sessions on the node/instance
	// If `checkAppSpecificSessions` is true, set an `appName` to also return a count
	// from within a specific application scope. In this case the return object will be a
	// JSON packet:
	// 	{"nodeSessions":n,"applicationSessions":n}
	try
	{
		// Do you want to also test within a specific application scope?
		checkAppSpecificSessions = false;
		// The name of the application on this node/instance that you want session information for (if checkAppSpecificSessions == true)
		appName = "myappname";

		sessionTracker = createObject("java", "coldfusion.runtime.SessionTracker");
		// Total number of sessions on this node/instance (includes all applications that may be running)
		numNodeSessions = sessionTracker.getSessionCount();

		if (checkAppSpecificSessions)
		{
			// Structure of sessions for a specific application
			appSessions = sessionTracker.getSessionCollection(appName);
			// Total number of sessions per `application` running on a single node/instance
			numAppSessions = structCount(appSessions);

			output = {
				"applicationSessions": numAppSessions,
				"nodeSessions": numNodeSessions
			}
		}
		else
		{
			output = numNodeSessions;
		}

	}
	catch (any e)
	{
		output = e.message;
		getPageContext().getResponse().setstatus(500);
	}

	writeOutput(serializeJSON(output));
</cfscript>
