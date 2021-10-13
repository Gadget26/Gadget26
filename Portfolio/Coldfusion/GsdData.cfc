<cfcomponent displayname="GsdData" output="false" ExtDirect="true" extends="toJSON" hint="All common data for the GSD app (dropdowns). Countries, Regions, Job Types, etc.">

<!--- SALES PERSON --->

<!--- Each function affects the SalesPersons field/drop down data --->
<cffunction name="getFirstNames" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of first names">
	<cfargument name="data">
	<!--- <cfdump var="#arguments.data.filter[1].value#"><cfabort> --->
	<cfparam name="arguments.data.firstName" default="" type="string" />
	<cfparam name="arguments.data.lastName" default="" type="string" />

	<!--- <cfif isdefined('arguments.data.query')>
		<cfset arguments.data.firstName = arguments.data.query>
	</cfif> --->

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.firstName = arguments.data.filterValue>
	</cfif>

	<cfquery name="firstNames" datasource="dsnGSD2">
		exec usp_FirstName_Salespersons
			@first_name = '#arguments.data.firstName#'
		   ,@last_name = '#arguments.data.lastName#'
	</cfquery>

	<cfif firstNames.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "first_name">
		<cfset _args.colValues = "#trim(arguments.data.firstName)#">
		<cfset _args.colDataType = "VarChar">
		<cfset firstNames = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfreturn queryToJSON(firstNames,'result') />
</cffunction>

<cffunction name="getLastNames" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of last names">
	<cfargument name="data">
	<cfparam name="arguments.data.firstName" default="" type="string" />
	<cfparam name="arguments.data.lastName" default="" type="string" />

	<!--- <cfif isdefined('arguments.data.query')>
		<cfset arguments.data.lastName = arguments.data.query>
	</cfif> --->

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.lastName = arguments.data.filterValue>
	</cfif>

	<cfquery name="lastNames" datasource="dsnGSD2">
		exec usp_FirstName_Salespersons
			@last_name = '#arguments.data.lastName#'
			,@first_name = '#arguments.data.firstName#'
	</cfquery>

	<cfif lastNames.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "last_name">
		<cfset _args.colValues = "#trim(arguments.data.lastName)#">
		<cfset _args.colDataType = "VarChar">
		<cfset lastNames = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfif lastNames.RecordCount EQ 0>
		<cfset lastNames = QueryNew("last_name", "VarChar")>
		<cfset tempRow = QueryAddRow(lastNames, 1)>
		<cfset tempSetCell = QuerySetCell(lastNames, "first_name", "#trim(arguments.data.firstName)#", 1)>
	</cfif>

	<cfreturn queryToJSON(lastNames,'result') />
</cffunction>

<cffunction name="getCountries" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of country names and ids">
	<cfargument name="data">
	<cfparam name="arguments.data.country" default="" type="string" />

	<cfif isdefined('arguments.data.query')>
		<cfset arguments.data.country = arguments.data.query>
	</cfif>

	<!--- <cfquery name="query" datasource="dsnGSD2">
          EXEC	 [usp_get_salesperson_hierarchy]
          @ResourceId = '#trim(arguments.data.ResourceId)#'
        </cfquery>
    <cfreturn queryToJSON(query,'result') /> --->

	<cfquery name="countries" datasource="dsnGSD2">
			exec usp_getCountries_Salespersons
				@country = '#arguments.data.country#'
	</cfquery>


	<cfif countries.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "country_id,country_name">
		<cfset _args.colValues = "#trim(arguments.data.country)#,#trim(arguments.data.country)#">
		<cfset _args.colDataType = "VarChar,VarChar">
		<cfset countries = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>


	<cfreturn queryToJSON(countries,'result') />
</cffunction>

<cffunction name="getStates" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of states, the abbreviation, and the country id">
	<cfargument name="data">
	<cfparam name="arguments.data.country" default="" type="string" />
	<cfparam name="arguments.data.state" default="" type="string" />

	<!--- <cfdump var="#data#"><cfabort> --->
	<cfif isdefined('arguments.data.query')>
		<cfset arguments.data.state = arguments.data.query>
	</cfif>

	<cfquery name="states" datasource="dsnGSD2">
			exec usp_getStates_Salespersons
				@country_id = '#arguments.data.country#'
				,@state_id = '#arguments.data.state#'
	</cfquery>

	<!--- <cfdump var="#states#"><cfabort> --->

	<cfif states.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "state_name,state">
		<cfset _args.colValues = "#trim(arguments.data.state)#,#trim(arguments.data.state)#">
		<cfset _args.colDataType = "VarChar,VarChar">
		<cfset states = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfreturn queryToJSON(states,'result') />
</cffunction>

<cffunction name="getCities" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of cities">
	<cfargument name="data">
	<cfparam name="arguments.data.city" default="" type="string" />
	<cfparam name="arguments.data.state" default="" type="string" />
	<cfparam name="arguments.data.country" default="" type="string" />

	<!--- <cfif isdefined('arguments.data.query')>
		<cfset arguments.data.city = arguments.data.query>
	</cfif> --->

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.city = arguments.data.filterValue>
	</cfif>

	<cfquery name="cities" datasource="dsnGSD2">
			exec usp_getCities_Salespersons
				@country = '#arguments.data.country#'
				,@state = '#arguments.data.state#'
				,@city = '#arguments.data.city#'
	</cfquery>

	<cfif cities.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "city">
		<cfset _args.colValues = "#trim(arguments.data.city)#">
		<cfset _args.colDataType = "VarChar">
		<cfset cities = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>


	<cfreturn queryToJSON(cities,'result') />
</cffunction>

<cffunction name="getZipcodes" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of zip and postal codes">
	<cfargument name="data">
	<cfparam name="arguments.data.zipcode" default="" type="string" />
	<cfparam name="arguments.data.city" default="" type="string" />
	<cfparam name="arguments.data.state" default="" type="string" />
	<cfparam name="arguments.data.country" default="" type="string" />
	<cfparam name="arguments.data.panel" default="" type="string" />

	<!--- <cfif isdefined('arguments.data.query')>
		<cfset arguments.data.zipcode = arguments.data.query>
	</cfif> --->

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.zipcode = arguments.data.filterValue>
	</cfif>

	<!--- US only for BD ECM --->
	<cfif arguments.data.panel is "bdEcm">
		<cfset arguments.data.country = 'US'>
	</cfif>

	<cfquery name="zipcodes" datasource="dsnGSD2">
			exec usp_getZipcodes_Salespersons
				@country = '#arguments.data.country#'
				,@state = '#arguments.data.state#'
				,@city = '#arguments.data.city#'
				,@zips = '#arguments.data.zipcode#'
	</cfquery>

	<cfif zipcodes.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "zipcode">
		<cfset _args.colValues = "#trim(arguments.data.zipcode)#">
		<cfset _args.colDataType = "VarChar">
		<cfset zipcodes = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfreturn queryToJSON(zipcodes,'result') />
</cffunction>

<cffunction name="getRegions" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of regions">
	<cfargument name="data">
	<cfparam name="arguments.data.region_id" default="" type="string" />

	<cfquery name="regions" datasource="dsnGSD2">
			exec usp_getRegions_Salespersons
				@region_id = '#arguments.data.region_id#'
	</cfquery>

	<cfreturn queryToJSON(regions,'result') />
</cffunction>

<cffunction name="getDistricts" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of districts">
	<cfargument name="data">
	<cfparam name="arguments.data.region_id" default="" type="string" />

	<cfquery name="districts" datasource="dsnGSD2">
			exec usp_getDistrict_Salespersons
				@region_id = '#arguments.data.region_id#'
	</cfquery>

	<cfreturn queryToJSON(districts,'result') />
</cffunction>

<!--- This function also affects the World clock drop down data --->
<cffunction name="getSalesGroups" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of sales groups">
	<!--- <cfargument name="domOrInt" default="domestic" hint="Domestic|International"> --->
	<cfargument name="data" hint="Sales Group mapping categories">

	<cfquery name="salesGroups" datasource="dsnGSD2">
			exec usp_getSalesGroups_Salespersons
	</cfquery>

	<cfreturn queryToJSON(salesGroups,'result') />
</cffunction>

<cffunction name="getSalesJobTypes" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of sales job types">
  <cfargument name="data">
  <cfparam name="arguments.data.SLS_GRP_CD" default="" type="string" />

	<cfquery name="salesJobTypes" datasource="dsnGSD2">
			exec usp_getSalesJob_Salespersons
				@SLS_GRP_CD = '#arguments.data.SLS_GRP_CD#'
	</cfquery>

	<cfreturn queryToJSON(salesJobTypes,'result') />
</cffunction>

<!--- This function affects the search results from the SalesPersons filters --->
<cffunction name="salesPersonSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="sales person grid search results">
	<cfargument name="data" required="true" hint="param struct">

  	<!---<cfdump var="#data#"><cfabort>--->
	<!--- RFC JPC Change to use account table to pull in SR related to accounts in search creteria --->

		<cfquery name="searchResults" datasource="dsnGSD2">
			exec usp_getSearchResults_Salespersons
				   @first_name = '#trim(arguments.data.firstName)#'
				  ,@last_name = '#trim(arguments.data.lastName)#'
				  ,@country = '#trim(arguments.data.country)#'
				  ,@state = '#trim(arguments.data.state)#'
				  ,@city = '#trim(arguments.data.city)#'
				  ,@zips = '#trim(arguments.data.zipcode)#'
				  ,@region = '#trim(arguments.data.region)#'
				  ,@district = '#trim(arguments.data.district)#'
				  <!--- ,@urlObj_id = '#trim(arguments.data.urlObj.id)#'
				  ,@resourceId = '#trim(arguments.data.resourceId)#' --->
				  ,@SLS_GRP_CD = '#trim(arguments.data.salesGroup)#'
				  ,@SalesJob_type = '#trim(arguments.data.salesJobType)#'
		</cfquery>

    <!---<cfdump var="#searchResults#"><cfabort>
     <cfabort>--->
	<cfreturn queryToJSON(searchResults,'result') />
</cffunction>

<!--- ACCOUNTS --->

<cffunction name="getAccountNames" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of account names">
	<cfargument name="data">
	<cfparam name="arguments.data.accountName" default="" type="string" />
	<cfparam name="arguments.data.accountNumber" default="" type="string" />

	<!--- <cfif isdefined('arguments.data.query')>
		<cfset arguments.data.accountName = arguments.data.query>
	</cfif> --->

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.accountName = arguments.data.filterValue>
	</cfif>

	<cfquery name="accountNames" datasource="dsnGSD2">
			exec usp_getAcctNames_Accounts
				@accountName = '#arguments.data.accountName#'
			   ,@accountNumber = '#arguments.data.accountNumber#'
	</cfquery>

	<cfif accountNames.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "account_name">
		<cfset _args.colValues = "#trim(arguments.data.accountName)#">
		<cfset _args.colDataType = "VarChar">
		<cfset accountNames = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfreturn queryToJSON(accountNames,'result') />
</cffunction>

<cffunction name="getAccountNumbers" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of account numbers">
	<cfargument name="data">
	<cfparam name="arguments.data.accountNumber" default="" type="string" />
	<cfparam name="arguments.data.accountName" default="" type="string" />
	<cfparam name="arguments.data.panel" default="" type="string" />

	<!--- <cfif isdefined('arguments.data.query')>
		<cfset arguments.data.accountNumber = arguments.data.query>
	</cfif>	 --->

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.accountNumber = arguments.data.filterValue>
	</cfif>

	<cfquery name="accountNumbers" datasource="dsnGSD2">
			exec usp_getAcctNumbers_Accounts
				@accountName = '#arguments.data.accountName#'
			   ,@accountNumber = '#arguments.data.accountNumber#'
			   ,@panel = '#arguments.data.panel#'
	</cfquery>

	<!--- <cfdump var="#arguments.data#"><cfabort> --->
	<cfif accountNumbers.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "account_number">
		<cfset _args.colValues = "#trim(arguments.data.accountNumber)#">
		<cfset _args.colDataType = "VarChar">
		<cfset accountNumbers = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfreturn queryToJSON(accountNumbers,'result') />
</cffunction>

<cffunction name="getSecondaryResources" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of resources that are secondaries on an account">
	<cfargument name="data">
	<cfparam name="arguments.data.accountNum" default="" type="string" />
	<cfparam name="arguments.data.parentNum" default="" type="string" />
	<cfparam name="arguments.data.egnNum" default="" type="string" />
	<!--- <cfdump var="#arguments.data#"><cfabort> --->

	<!--- dont allow both account num and parent/EGN num to be blank on this query --->
	<cfif arguments.data.accountNum is "" and arguments.data.parentNum is "" and arguments.data.egnNum is "">
		<cfreturn />
	</cfif>

	<cfquery name="secondaryResources" datasource="dsnGSD2">
			exec usp_getSecondaryResources_Accounts
				@parentNum = '#arguments.data.parentNum#'
			   ,@accountNumber = '#arguments.data.accountNum#'
			   ,@egnNum = '#arguments.data.egnNum#'
	</cfquery>

	<cfreturn queryToJSON(secondaryResources,'result') />
</cffunction>

<!--- This function affects the Accounts drop down data --->
<cffunction name="getAccountTypes" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of account types">
	<cfargument name="data">
	<cfparam name="arguments.data.accountType" default="" type="string" />


		<cfquery name="accountTypes" datasource="dsnGSD2">
				exec usp_getAccountTypes_Accounts
					@accountType = '#arguments.data.accountType#'
		</cfquery>

	<cfreturn queryToJSON(accountTypes,'result') />
</cffunction>

<!--- This function affects the search results from the Accounts filters --->
<cffunction name="accountSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
	<cfargument name="data" required="true" hint="param struct">
	<cfparam name="arguments.data.parentEgnNumber" default=""><!--- parent/EGN number paramed because it's only present sometimes --->
	<cfparam name="arguments.data.parentOrEgn" default=""><!--- parent_number || egn_number --->


	<cfquery name="searchResults" datasource="dsnGSD2">
			exec usp_getAccountSearch_Accounts
				@parentEgnNumber = '#trim(arguments.data.parentEgnNumber)#'
				,@accountNumber = '#trim(arguments.data.accountNumber)#'
				,@accountType = '#trim(arguments.data.accountType)#'
  				,@accountName = '#trim(arguments.data.accountName)#'
				,@country = '#trim(arguments.data.country)#'
				,@state = '#trim(arguments.data.state)#'
				,@city = '#trim(arguments.data.city)#'
				,@zips = '#trim(arguments.data.zipcode)#'
				,@Admin = '#session.Admin#'
	</cfquery>

    <!---<cfdump var="#searchResults#"><cfabort>--->
	<cfreturn queryToJSON(searchResults,'result') />
</cffunction>


  <cffunction name="accountDetails" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">

		 <cfquery name="searchResults" datasource="dsnGSD2">
			exec usp_getAcctDetails_Accounts
				@account_num = '#trim(arguments.data.account_num)#'
			   ,@Admin = '#session.Admin#'
		 </cfquery>



        <cfreturn queryToJSON(searchResults,'result') />

        </cffunction>

  <cffunction name="salesPersonDetails" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">

	   <cfquery name="searchResults" datasource="dsnGSD2">
			exec usp_getSPDetails_Accounts
				@resource_id = '#trim(arguments.data.resource_id)#'
		 </cfquery>

      <cfreturn queryToJSON(searchResults,'result') />

    </cffunction>
  <cffunction name="parentDetails" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">

		<cfquery name="searchResults" datasource="dsnGSD2">
				exec usp_getParentDetails_Accounts
					@parent_id = '#trim(arguments.data.parent_id)#'
				   ,@Admin = '#session.Admin#'
		</cfquery>

    <cfreturn queryToJSON(searchResults,'result') />

    </cffunction>
  <cffunction name="egnDetails" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">

		<cfquery name="searchResults" datasource="dsnGSD2">
			exec usp_getEGNDetails_Accounts
				@egn_id = '#trim(arguments.data.egn_id)#'
			   ,@Admin = '#session.Admin#'
		</cfquery>

      <cfreturn queryToJSON(searchResults,'result') />

    </cffunction>

 <!--- PARENT/EGN --->

<cffunction name="getParentEgnNames" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of parent/EGN names">
	<cfargument name="data">
	<cfparam name="arguments.data.parentEgnName" default="" type="string" />

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.parentEgnName = arguments.data.filterValue>
	</cfif>

	<cfquery name="parentEgnNames" datasource="dsnGSD2">
			exec usp_getNames_PEGN
				@parentEgnName = '#trim(arguments.data.parentEgnName)#'
			   ,@Admin = '#session.Admin#'
	</cfquery>

	<cfif parentEgnNames.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "parent_egn_name">
		<cfset _args.colValues = "#trim(arguments.data.parentEgnName)#">
		<cfset _args.colDataType = "VarChar">
		<cfset parentEgnNames = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfreturn queryToJSON(parentEgnNames,'result') />
</cffunction>

<cffunction name="getParentEgnNumbers" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of parent/EGN numbers">
	<cfargument name="data">
	<cfparam name="arguments.data.parentEgnNumber" default="" type="string" />

	<!--- <cfif isDefined('arguments.data.query')>
		<cfset arguments.data.parentEgnNumber = arguments.data.query>
	</cfif> --->

	<cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.parentEgnNumber = arguments.data.filterValue>
	</cfif>

	<cfquery name="parentEgnNumbers" datasource="dsnGSD2">
			exec usp_getNumbers_PEGN
				@parentEgnNumber = '#trim(arguments.data.parentEgnNumber)#'
			   ,@Admin = '#session.Admin#'
	</cfquery>


	<cfif parentEgnNumbers.RecordCount EQ 0>
		<cfset _args = StructNew()>
		<cfset _args.colNames = "parent_egn_name">
		<cfset _args.colValues = "#trim(arguments.data.parentEgnNumber)#">
		<cfset _args.colDataType = "VarChar">
		<cfset parentEgnNumbers = argValuesInQueryFormat(argumentCollection=_args)>
	</cfif>

	<cfreturn queryToJSON(parentEgnNumbers,'result') />
</cffunction>

<!--- This function affects the Parent/EGN (parent type) drop down data --->
<cffunction name="getParentTypes" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of parent types">
	<cfargument name="data">
	<cfparam name="arguments.data.parentType" default="" type="string" />

	<cfquery name="parentTypes" datasource="dsnGSD2">
			exec usp_getparentTypes_PEGN
				@parentType = '#arguments.data.parentType#'
			   ,@Admin = '#session.Admin#'
	</cfquery>

	<cfreturn queryToJSON(parentTypes,'result') />
</cffunction>

<cffunction name="getResourcesByParent" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of resources for a given parent">
	<cfargument name="data">
	<cfparam name="arguments.data.parentNumber" default="" type="string" />

	<cfquery name="resourcesByParent" datasource="dsnGSD2">
			exec usp_getparentTypes_PEGN
				@parentNumber = '#trim(arguments.data.parentNumber)#'
			   ,@Admin = '#session.Admin#'
	</cfquery>

	<cfreturn queryToJSON(resourcesByParent,'result') />
</cffunction>

<cffunction name="parentEgnSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="Parent EGN grid search results">
	<cfargument name="data" required="true" hint="param struct">
	<!--- <cfdump var="#arguments.data#"><cfabort> --->
	<cfparam name="arguments.data.parentOrEgn" default=""><!--- parent_number || egn_number --->

	<cfset MultiList = 0>
	<cfif arguments.data.parentEgnNumber neq "">
		<cfif FindOneOf(arguments.data.parentEgnNumber, ",")>
			<cfset MultiList = 1>
		</cfif>
	</cfif>
	<!--- <cfif MultiList EQ 1><!--- test --->
	<cfset arguments.data.parentEgnNumber = "1254">
	</cfif> --->

	<cfquery name="parentEgnSearchResults" datasource="dsnGSD2">
			exec usp_getSearchResults_PEGN
				@parentOrEgn = '#arguments.data.parentOrEgn#'
			   ,@parentEgnName = '#trim(arguments.data.parentEgnName)#'
			   ,@parentNumber = '#trim(arguments.data.parentEgnNumber)#'
			   ,@parentType = '#arguments.data.parentType#'
			   ,@MultiList = '#MultiList#'
			   ,@Admin = '#session.Admin#'
	</cfquery>

	 <!---<cfdump var="#parentEgnSearchResults#"><cfabort> --->
	<cfreturn queryToJSON(parentEgnSearchResults,'result') />
</cffunction>

<!--- BD ECM --->

<cffunction name="bdEcmSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="BD ECM search results">
	<cfargument name="data" required="true" hint="param struct">
	<!--- <cfdump var="#data#"><cfabort> --->

	<!--- <cfif isdefined('arguments.data.filterValue')>
		<cfset arguments.data.bdEcmZipcode = arguments.data.filterValue>
	</cfif> --->

		<cfquery name="bdEcmSearchResults" datasource="dsnGSD2">
			exec usp_getbdEcmSearch_BDECM
				@bdEcmZipcode = '#trim(arguments.data.bdEcmZipcode)#'
			   ,@bdEcmAccountNumber = '#trim(arguments.data.bdEcmAccountNumber)#'
			   ,@Admin = '#session.Admin#'
		</cfquery>

    	<!--- <cfdump var="#bdEcmSearchResults#"><cfabort> --->
	<cfreturn queryToJSON(bdEcmSearchResults,'result') />
</cffunction>

<!--- //New EGN to ACCT Search per Hamada - JPC 8/25/16 --->
<cffunction name="acctEgnSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="Account EGN grid search results">
	<cfargument name="data" required="true" hint="param struct">
	<!--- <cfdump var="#arguments.data#"><cfabort> --->
	<cfparam name="arguments.data.acctNum" default=""><!--- acct_number --->
	<cfparam name="arguments.data.acctName" default="">

	<cfquery name="acctEgnSearchResults" datasource="dsnGSD2">
		exec usp_getacctEgnSearchResults_BDECM
			@acctNum = '#arguments.data.acctNum#'
		   ,@acctName = '#arguments.data.acctName#'
		   ,@Admin = '#session.Admin#'
	</cfquery>

	 <!---<cfdump var="#parentEgnSearchResults#"><cfabort> --->
	<cfreturn queryToJSON(acctEgnSearchResults,'result') />
</cffunction>

<!--- TIMEZONE --->

<cffunction name="getTimeZones" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="returns a list of timezones">
	<cfargument name="data">
	<cfparam name="arguments.data.timezone_id" default="143" type="string">

	<cfquery name="timeZone" datasource="dsnGSD2">
		exec usp_getTimeZone_GSD
			@timezone_id = '#trim(arguments.data.timezone_id)#'
	</cfquery>

	<!--- get specific timezone and offset --->

	<!--- get tz from server --->
	<cfset server_timezone = createObject("java","java.util.TimeZone")>

	<!--- figure out the d/t for the timezone selected --->
	<cfparam name="timezone_dt" default="#dateadd('h', (server_timezone.getTimeZone(timeZone.timezone).getRawOffset() - server_timezone.getDefault().getRawOffSet()) / 3600000, now())#">

	<!--- compensate for any offsets --->
	<cfif timezone.offset neq 0>
		<cfset timezone_dt = dateadd('n', 60 * timeZone.offset, timezone_dt)>
	</cfif>

	<cfquery name="timeZones" datasource="dsnGSD2">
		exec usp_getTimeZoneList_GSD
			@tz_date = '#dateformat(timezone_dt, "YYYY-MM-DD")#'
		   ,@tz_time = '#timeformat(timezone_dt, "HH:MM:SS tt")#'
	</cfquery>

	<!--- get a list of all timezones and include the selected timezone if necessary --->

	<!--- <cfdump var='#GetLocaleDisplayName()#'><cfabort> --->
	<cfreturn queryToJSON(timeZones,'result') />
</cffunction>

<!--- MISC --->

<cffunction name="argValuesInQueryFormat" access="remote" returntype="query" output="true" hint="Built to allow empty recordsets to return typed data">
	<cfargument name="colNames" required="true" type="string" hint="Expects list of columnames">
	<cfargument name="colValues" required="true" type="string" hint="Expects list of values matching the columns on ColNames argument">
	<cfargument name="colDataType" required="true" type="string">

	<cfset colCount = ListLen(colNames,",")>

	<cfset tempQuery = QueryNew("#trim(arguments.colNames)#", "#trim(arguments.colDataType)#")>
	<cfset tempRow = QueryAddRow(tempQuery, 1)>

	<cftry>
		<cfloop index="idx" from="1" to="#colCount#">
			<cfset tempSetCell = QuerySetCell(tempQuery, "#ListGetAt(ColNames,idx,',')#", "#ListGetAt(ColValues,idx,',')#", 1)>
		</cfloop>
	<cfcatch></cfcatch>
	</cftry>

	<cfreturn tempQuery />
</cffunction>


  <cffunction name="qsAccountSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">
      <cfif arguments.data.IsAdvancedsearch eq "true">
        <cfquery name="searchResults" datasource="dsnGSD2">
          EXEC	 [usp_quickSearch_Accounts_advanced]
          @SearchString = '#trim(arguments.data.SearchString)#',
		  @admin = '#session.Admin#'
        </cfquery>
        <cfelse>
          <cfquery name="searchResults" datasource="dsnGSD2">
            EXEC	 [usp_quickSearch_Accounts]
            @SearchString = '#trim(arguments.data.SearchString)#',
			@admin = '#session.Admin#'
          </cfquery>
      </cfif>
        <cfreturn queryToJSON(searchResults,'result') />
      </cffunction>
  <cffunction name="qsParentSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">
      <cfif arguments.data.IsAdvancedsearch eq "true">
        <cfquery name="searchResults" datasource="dsnGSD2">
          EXEC	 [usp_quickSearch_Parents_advanced]
          @SearchString = '#trim(arguments.data.SearchString)#',
		  @admin = '#session.Admin#'
        </cfquery>
        <cfelse>
          <cfquery name="searchResults" datasource="dsnGSD2">
            EXEC	 [usp_quickSearch_Parents]
            @SearchString = '#trim(arguments.data.SearchString)#',
			@admin = '#session.Admin#'
          </cfquery>
      </cfif>
      <cfreturn queryToJSON(searchResults,'result') />
    </cffunction>

  <cffunction name="getSalesPersonHierarchy" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">
        <cfquery name="query" datasource="dsnGSD2">
          EXEC	 [usp_get_salesperson_hierarchy]
          @ResourceId = '#trim(arguments.data.ResourceId)#'
        </cfquery>
      <cfreturn queryToJSON(query,'result') />
    </cffunction>
  <cffunction name="qsSalesPersonsSearch" ExtDirect="true" access="remote" output="false" returntype="String" returnformat="plain" hint="accounts grid search results">
    <cfargument name="data" required="true" hint="param struct">
      <cfif arguments.data.IsAdvancedsearch eq "true">
        <cfquery name="searchResults" datasource="dsnGSD2">
          EXEC	 [usp_quickSearch_SalesPersons]
          @SearchString = '#trim(arguments.data.SearchString)#'
        </cfquery>
        <cfelse>
          <cfquery name="searchResults" datasource="dsnGSD2">
            EXEC	 [usp_quickSearch_SalesPersons]
            @SearchString = '#trim(arguments.data.SearchString)#'
          </cfquery>
        </cfif>
      <cfreturn queryToJSON(searchResults,'result') />
    </cffunction>
</cfcomponent>