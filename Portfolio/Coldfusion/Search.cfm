<cfparam name="form.poi_name" default="">
<cfparam name="form.page_number" default="1">
<cfparam name="form.Page_Size" default="50">
<cfparam name="form.totalpagenum" default="">

<cfparam name="session.user_id" default="0">

<cfif session.user_id eq 0>
<cflocation url="login.cfm" addtoken="false">
</cfif>

<!doctype html>
<html>
<cfinclude template="header.cfm">

<script>
function NextPage(page){
	document.getElementById('page_number').value = page;
	document.getElementById('frm').submit();
}

</script>

<form method = post id="frm">				<!--- Calls the nextpage function --->
	<input type=hidden id = "page_number" name="page_number" value="<cfoutput>#form.page_number#</cfoutput>">

	<table border = 0>
<tr>
<td>Name:</td> <td><input type="text" name="poi_name" value=<cfoutput>"#form.poi_name#"</cfoutput>></td>
</tr>
<td>
	<input type="submit" name="Submit" value="Submit" button onclick="NextPage(1);">
</td>
</tr>
	</table>
	</form>

<!--- Sql statement to pull data       --->
<cfstoredproc procedure="getZipByName" datasource="zipProject">
<cfprocparam cfsqltype="cf_sql_varchar" value="#form.poi_name#">
<cfprocparam cfsqltype="cf_sql_varchar" value="#form.page_number#">
<cfprocparam cfsqltype="cf_sql_varchar" value="#form.page_size#">
<cfprocparam cfsqltype="cf_sql_varchar" value="zip">
<cfprocparam cfsqltype="cf_sql_varchar" value="desc">

<cfprocresult    name = "poi"   resultSet = "1">

</cfstoredproc>

<style>
	    .odd {
        background-color: #C2D6FF;
    }
    .even {
        background-color: #FFFFFF;
    }
</style>

<cfif poi.recordcount gt 0>
<cfset #totalpagenum# = (poi.Row_Count \ #form.Page_Size#) + 1>
<cfelse>
<cfset #totalpagenum# = 1>
</cfif>

<cfoutput>
	<cfif form.page_number neq "1" >
	<cfset backpagenum = form.page_number - 1>			<!--- Set page back one --->
<button onclick="NextPage(#backpagenum#);" >Back</button>
<cfelse>
<cfset backpagenum = 1>			<!--- Set page back one --->
<!--- <button onclick="NextPage(#backpagenum#);" >Back</button> --->
</cfif>

#form.page_number# of #totalpagenum#

	<!--- <cfif (poi.Row_Count MOD form.page_size neq 0)> --->

	<cfif (form.page_number * form.page_size) lt poi.Row_Count>
	<cfset nextpagenum = form.page_number + 1>			<!--- Set page forward one --->
	<button onclick="NextPage(#nextpagenum#);" >Next</button>
</cfif>
</cfoutput>
<table border = 0>
	<tr class="<cfif (poi.currentRow MOD 2 EQ 0)>ui-state-active<cfelse>ui-state-default</cfif>">
	    <td>Poi Name</td>
	    <td>Address</td>
	    <td>City</td>
		<td>State</td>
		<td>Zip</td>
		<td>Employees</td>
	</tr>

<cfoutput query="poi">

	<Tr class="<cfif (poi.currentRow MOD 2 EQ 0)>ui-state-default<cfelse>ui-state-active</cfif>" onclick="openEditForm(#poi_id#);">
		<td id=#poi_id#_poi_name>#poi_name#</td>
		<cfif address eq "">
              <td id=#poi_id#_address>&nbsp;</td>
                     <cfelse>
              <td id=#poi_id#_address>#address#</td>
                     </cfif>

		<td id=#poi_id#_primary_city>#Primary_city#</td>
		<td id=#poi_id#_state>#state#</td>
		<td id=#poi_id#_Zip>#zip#</td>
		<td>#Employees#</td>
	</Tr>

</cfoutput>
</table>
<cfinclude template="updatepoi.cfm">
</html>
