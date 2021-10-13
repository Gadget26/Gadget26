<cfparam name="form.poi_name" default="">
<cfparam name="form.address" default="">
<cfparam name="form.name" default="">
<cfparam name="form.primary_city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.employees" default="">
<cfparam name="form.format" default="PDF">
<cfparam name="form.page_number" default="1">
<cfparam name="form.Page_Size" default="50">
<cfparam name="form.totalpagenum" default="">
<cfparam name="form.zipcode" default="">
<cfparam name="form.Radius" default="10">
<cfset session.zipcode = "#form.zipcode#">
<cfset session.Radius = "#form.Radius#">

<cfparam name="session.user_id" default="0">

<cfif session.user_id eq 0>
<cflocation url="login.cfm" addtoken="false">
</cfif>


<cfquery name="Zipcodes" datasource="zipProject">
	SELECT  TOP 50 POI_Name, POI.Address, Primary_city, State, Zipcodes.Zip, POI.Employees
	FROM 	Zipcodes
	JOIN 	POI
	ON		Zipcodes.zip = POI.Zip
	WHERE   1=1
		<cfif form.poi_name neq ""> and POI_Name = <cfqueryparam value= "#form.poi_name#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif form.address neq ""> and POI.address = <cfqueryparam value= "#form.address#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif form.primary_city neq ""> and primary_city = <cfqueryparam value= "#form.primary_city#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif form.state neq ""> and state = <cfqueryparam value= "#form.state#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif form.zipcode neq ""> and Zipcodes.Zip = <cfqueryparam value= "#form.zipcode#" cfsqltype="cf_sql_integer"></cfif>
		<cfif form.employees neq ""> and POI.Employees = <cfqueryparam value= "#form.employees#" cfsqltype="cf_sql_integer"></cfif>

</cfquery>

<cfif form.format eq "Excel">
	<cfheader name="Content-Disposition" value="filename=Report.xls">
	<cfcontent type="application/x-msexcel" reset="true">
	<cfinclude template="reporttable.cfm">
</cfif>

<cfif form.format eq "PDF">
	<cfdocument format = "PDF">
		<cfinclude template="reporttable.cfm">
	</cfdocument>
</cfif>

<cfif form.format eq "HTML">
		<cfinclude template="reporttable.cfm">
</cfif>

<cfif form.format eq "Word">
	<cfheader name="Content-Disposition" value="filename=Report.doc">
	<cfcontent type="application/msword" reset="true">
	<cfinclude template="reporttable.cfm">
</cfif>

Reporttable
<table border = 0>
	<tr class="<cfif (zipcodes.currentRow MOD 2 EQ 0)>ui-state-active<cfelse>ui-state-default</cfif>">
	    <td>Poi Name</td>
	    <td>Address</td>
	    <td>City</td>
		<td>State</td>
		<td>Zip</td>
		<td>Employees</td>
	</tr>

<cfoutput query="zipcodes">

	<Tr class="<cfif (zipcodes.currentRow MOD 2 EQ 0)>ui-state-default<cfelse>ui-state-active</cfif>">
		<td>#poi_name#</td>
		<cfif address eq "">
              <td>&nbsp;</td>
                     <cfelse>
              <td>#address#</td>
                     </cfif>

		<td>#primary_city#</td>
		<td>#state#</td>
		<td>#Zip#</td>
		<td align='right'>#Employees#</td>

	</Tr>

</cfoutput>
</table>
