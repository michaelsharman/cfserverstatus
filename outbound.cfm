<cfsetting enablecfoutputonly="true">

<cfscript>
	// Tests whether outbound connections are allowed from the application server
	try
	{
		testURI = "http://www.google.com";
		proxyPort = "";
		proxyServer = "";
		validStatusCodes = "200,302";

		// Use proxy?
		if (isNumeric(proxyPort) && len(proxyServer))
		{
			http
				url = testURI
				method = "HEAD"
				redirect = true
				throwOnError = true
				timeout = 5
				addtoken = false
				proxyPort = proxyPort
				proxyServer = proxyServer;
		}
		else
		{
			http
				url = testURI
				method = "HEAD"
				redirect = true
				throwOnError = true
				timeout = 5
				addtoken = false;
		}
		if (listFind(validStatusCodes, cfhttp.status_code))
		{
			output = true;
		}
		else
		{
			output = "The following connection status was returned: #cfhttp.status_code#";
		}
	}
	catch (any e)
	{
		output = e.message;
		getPageContext().getResponse().setstatus(500);
	}

	writeOutput(output);
</cfscript>
