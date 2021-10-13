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

<!doctype html>
<html>
<cfinclude template="header.cfm">

<!--- Calls the nextpage function --->
<form method = post id="frm" action="reportoutput.cfm" target="Report">
	<table border = 0>
<tr><td>Name:</td> <td><input type="text" name="poi_name" value=<cfoutput>"#form.poi_name#"</cfoutput>></tr>
<tr><td>Address:</td> <td><input type="text" name="address" value=<cfoutput>"#form.address#"</cfoutput>></td></tr>
<tr><td>City:</td> <td><input type="text" name="primary_city" value=<cfoutput>"#form.primary_city#"</cfoutput>></td></tr>
<tr><td>State:</td> <td><input type="text" name="state" value=<cfoutput>"#form.state#"</cfoutput>></td></tr>
<tr><td>Zipcode:</td> <td><input type="text" name="zipcode" value=<cfoutput>"#form.zipcode#"</cfoutput>></td>
	<td>Radius:</td> <td><select name = "Radius">
  	<option value="10" <cfif form.radius eq 10>selected</cfif>>10 miles</option>
  	<option value="20" <cfif form.radius eq 20>selected</cfif>>20 miles </option>
  	<option value="50" <cfif form.radius eq 50>selected</cfif>>50 miles</option>
  	<option value="100" <cfif form.radius eq 100>selected</cfif>>100 miles</option></td></select></tr>
<tr><td>Employees:</td> <td><input type="text" name="employees" min="0" max="50" value=<cfoutput>"#form.employees#"</cfoutput>></tr>
<tr><td>Format:</td> <td><select name = "format">
  	<option value="PDF" <cfif form.format eq "PDF">selected</cfif>>PDF</option>
  	<option value="Excel" <cfif form.format eq "Excel">selected</cfif>>Excel</option>
  	<option value="HTML" <cfif form.format eq "HTML">selected</cfif>>HTML</option>
  	<option value="Word" <cfif form.format eq "Word">selected</cfif>>Word</option></td></tr></select>
<tr>
<td>&nbsp;</td>
<td>
	<button onclick="NextPage(1);"> Search </button>
</td>
</tr>
	</table>
	</form>


<!--- <cfquery name="Zipcodes" datasource="zipProject">
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

<cfif form.format eq "PDF">
	<cfdocument format = "PDF"/>
	</cfif>

<cfif form.format eq "Excel">
		<cfdocument format = "Excel"/>
</cfif>

<cfinclude template="reportoutput.cfm"> --->
</html>
