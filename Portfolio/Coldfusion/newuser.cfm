<cfparam name ="form.firstname" default="">
<cfparam name ="form.lastname" default="">
<cfparam name ="form.email" default="">
<cfparam name="form.username" default="">
<cfparam name="form.password" default="">

<cfparam name="session.user_id" default="0">

<cfif session.user_id eq 0>
<cflocation url="login.cfm" addtoken="false">
</cfif>

<cfquery name="UserInfo" datasource="zipProject">
	select user_id
	from UserInfo
	where username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
	</cfquery>

<cfif UserInfo.recordcount lt 1>
<cfif len(#form.username#) gt 0>
<cfquery name="UserInfo" datasource="zipProject">

	Insert into UserInfo (firstname, lastname, email, username, password)
	values	(<cfqueryparam value="#form.firstname#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#form.lastname#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">,
		 	<cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar">)

	</cfquery>
		<script>
         alert('Username has been created!');
         window.location.assign('/zip');
  </script>
	<cfabort> <!--- Tells the progra to stop once the execution is done --->
	<!--- <cflocation url="/zip"> --->
	</cfif>
<cfelse>
<script>
alert('Username already taken');
</script>
</cfif>

<!doctype html>
<html>
<cfinclude template="header.cfm">


<form method = post>
	<table border = 3>
<tr>
<td>firstname:</td> <td><input type="text" name="firstname"></td>
</tr>
<td>lastname:</td> <td><input type="text" name="lastname"></td>
</tr>
<td>email:</td> <td><input type="text" name="email"></td>
</tr>
<tr>
<td>Username:</td> <td><input type="text" name="username"></td>
</tr>
<tr>
<td>Password:</td><td style ="width:150"><input type="password" name="password"></td>
</tr>
<td>
	<input type="submit" name="Create" value="Create">
</td>
</tr>
	</table>
	</form>
	</html>

<!--- Logout.cfm --->
	<cfset session.user_id = "0">
	<cflocation url="/zip">
