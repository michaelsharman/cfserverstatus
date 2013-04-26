<cfsetting enablecfoutputonly="true">

<cfscript>
	// Returns a count (Int) of the number of active sessions for a specific application on the node/instance
	// You must add your `targetAppName` and `nodeServerPwd` (Railo server password)
	try
	{
		targetAppName = "programbuilder";
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
				//sessionScopes = config.getFactory().getScopeContext().getAllSessionScopes(targetAppName);
				output = config.getFactory().getScopeContext().getSessionCount(getPageContext());
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
