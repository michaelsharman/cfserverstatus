<cfsetting enablecfoutputonly="true">

<cfscript>
	// Returns a count (Int) of the number of active sessions for a specific application on the node/instance
	// This script is run outside the application WEB-INF you want to track, but within the same node/instance.
	// You must add your `targetAppName` and `nodeServerPwd` (Railo server password)
	try
	{
		targetAppName = "<app name>";
		nodeServerPwd = "<railo server password>";

		// Retrieve all the web config/contexts for this instance
		configs = getPageContext().getConfig().getConfigServer(nodeServerPwd).getConfigWebs();
		output = "";
		targetAppFound = false;

		for(config in configs)
		{
			// Retrieve all the application scopes active on this config/context
			appScopes = config.getFactory().getScopeContext().getAllApplicationScopes();
			if (structKeyExists(appScopes, targetAppName))
			{
				output = structCount(config.getFactory().getScopeContext().getAllSessionScopes(targetAppName));	// Railo 3.x
				//output = config.getFactory().getScopeContext().getSessionCount(getPageContext());	Railo 4.x
				targetAppFound = true;
				break;
			}
		}
		if (!targetAppFound)
		{
			output = "I didn't find any applications running that match '#targetAppName#'";
		}
	}
	catch (any e)
	{
		output = e.message;
		getPageContext().getResponse().setstatus(500);
	}

	writeOutput(output);
</cfscript>
