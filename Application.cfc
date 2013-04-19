component
{

	this.name = "status-check";
	this.applicationTimeout = createTimeSpan(0,2,0,0);
	this.sessionManagement = true;
	this.setClientCookies = false;
	this.clientManagement = false;
	this.scriptProtect = "cgi,cookies,url";


	public boolean function onApplicationStart()
	{
		return true;
	}


	public void function onApplicationEnd(required struct applicationScope)
	{}


	public void function onError(required any exception, required string eventName)
	{}


	public boolean function onRequestStart(required string targetPage)
	{
		setLocale("English (Australian)");
		return true;
	}


	public void function onRequestEnd()
	{}


	public void function onSessionEnd(required struct sessionScope, struct applicationScope={})
	{}


	public void function onSessionStart()
	{}

}
