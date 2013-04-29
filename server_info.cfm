<cfsetting enablecfoutputonly="true">

<cfscript>
	// Returns information about the instance this script is run in, from application and session data
	// to Java memory usage
	try
	{
		startTime = getTickCount();
		nodeServerPwd = "<railo server password>";
		configs = getPageContext().getConfig().getConfigServer(nodeServerPwd).getConfigWebs();
		appCount = 0;
		totalSessionCount = 0;
		apps = [];

		for(config in configs)
		{
			thisScopeContext = config.getFactory().getScopeContext();
			appScopes = thisScopeContext.getAllApplicationScopes();
			for(appName IN appScopes)
			{
				appCount++;
				thisApp = {
					"name" = appName
				};
				// Get the session info
				sessionScopes[appName] = thisScopeContext.getAllSessionScopes(getPageContext(), appName);
				thisApp["sessioncount"] =  structCount(sessionScopes[appName]);
				totalSessionCount += thisApp['sessioncount'];

				arrayAppend(apps, thisApp);
			}

			data = {
				"memory" = getJavaMemoryInfo(),
				"processors" = getProcessorCount(),
				"apps" = apps,
				"appcount" = appCount,
				"totalsessioncount" = totalSessionCount,
				"memoryPools" = getJavaMemoryPoolInfo(),
				"gc" = getJavaGCInfo(),
				"compilation" = getJavaCompilationInfo(),
				"classloading" = getClassLoadingInfo(),
				"pageproccessingtimems" = getTickCount() - startTime
			};

			writeDump(data);
			//writeOutput(serializeJSON(data));
		}
	}
	catch (any e)
	{
		writeOutput(e.message);
		getPageContext().getResponse().setstatus(500);
	}
</cfscript>



<cffunction name="getClassLoadingInfo" returntype="struct" output="false">
	<cfscript>
		var bean = createObject("java","java.lang.management.ManagementFactory").getClassLoadingMXBean();
		var data = structNew();

		data.loadedClassCount = bean.getLoadedClassCount();
		data.unloadedClassCount = bean.getUnloadedClassCount();
		data.totalLoadedClassCount = bean.getTotalLoadedClassCount();

		return data;
	</cfscript>
</cffunction>


<cffunction name="getJavaCompilationInfo" returntype="struct" output="false">
	<cfscript>
		var bean = createObject("java","java.lang.management.ManagementFactory").getCompilationMXBean();
		var data = structNew();

		data.name = bean.getName();
		data.totalCompilationTime = bean.getTotalCompilationTime();
		data.isCompilationTimeMonitoringSupported = bean.isCompilationTimeMonitoringSupported();

		return data;
	</cfscript>
</cffunction>

<cffunction name="getJavaGCInfo" returntype="array" output="false">
	<cfscript>
		var memoryPools = createObject("java","java.lang.management.ManagementFactory").getGarbageCollectorMXBeans().toArray();
		var data = arrayNew();

		 for(i=1;i LTE ArrayLen(memoryPools);i++){
			data[i].name = memoryPools[i].getName();
			data[i].count = memoryPools[i].getCollectionCount();
			data[i].timespent = memoryPools[i].getCollectionTime();
 		}

		return data;
	</cfscript>
</cffunction>


<cffunction name="getJavaMemoryPoolInfo" returntype="array" output="false">
	<cfscript>
		var memoryPools = createObject("java","java.lang.management.ManagementFactory").getMemoryPoolMXBeans().toArray();
		var data = arrayNew();

		 for(i=1;i LTE ArrayLen(memoryPools);i++){
			data[i].name = memoryPools[i].getName();
			data[i].type = memoryPools[i].getType().toString();
			data[i].currentUsed = memoryPools[i].getUsage().getUsed();
			data[i].currentCommited = memoryPools[i].getUsage().getCommitted();
			data[i].currentMax = memoryPools[i].getUsage().getMax();
			data[i].currentPercent = round((data[i].currentUsed/data[i].currentMax) * 100) ;
			data[i].peakUsed = memoryPools[i].getPeakUsage().getUsed();
			data[i].peakCommited = memoryPools[i].getPeakUsage().getCommitted();
			data[i].peakMax = memoryPools[i].getPeakUsage().getMax();
			data[i].peakPercent = round((data[i].peakUsed/data[i].peakMax) * 100) ;

 		}

		return data;
	</cfscript>
</cffunction>

<cffunction name="getJavaMemoryInfo" returntype="struct" output="false">
	<cfscript>
		var runtime = createObject("java","java.lang.Runtime").getRuntime();
		var data = structNew();

		data.freeMemory = runtime.freeMemory();
		data.maxMemory = runtime.maxMemory();
		data.totalMemory = runtime.totalMemory();
		data.heapMemory = runtime.totalMemory()-runtime.freeMemory();

		return data;
	</cfscript>
</cffunction>
<cffunction name="getProcessorCount" returntype="numeric" output="false">
	<cfscript>
		var runtime = createObject("java","java.lang.Runtime").getRuntime();
		return runtime.availableProcessors();
	</cfscript>
</cffunction>

