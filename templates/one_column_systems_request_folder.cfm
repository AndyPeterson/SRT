<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="oneCol depth#arrayLen($.event('crumbdata'))#">
<div id="container" class="#$.createCSSid($.content('menuTitle'))#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<article>
			<nav>#$.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#</nav>
			<!--- #$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
			#$.dspObjects(2)# --->


<cfset variables.StartDate="#$.content('Kickoff_Request')#">	
<cfparam name="variables.status" default="Received by IT">


<h2>SR #$.content('SystemsRequestNumber')#: #$.content('System_Title')#</h2>

<cfset variables.StatusDate="">
<!--- RECEIVED BY SYSTEMS ADMIN --->
<cfif #$.content('Script_Approved_Date')# lte Now()>
	<cfset variables.status="Received by Systems Administration; Awaiting Kickoff">
	<cfset variables.StatusDate="#DateFormat($.content('Script_Approved_Date'),'m/d/yyyy')#">
</cfif>

<!--- FUNCTIONAL COMPLETION DATE --->
<cfif #$.content('Functional_Completion_Date')# lte Now()>
	<cfset variables.status="Functional Portion of Document Completed">
	<cfset variables.StatusDate="#DateFormat($.content('Functional_Completion_Date'),'m/d/yyyy')#">
	<cfset variables.datesinceScriptApproved = dateDiff("d", "#$.content('functional_Completion_Date')#", "#$.content('Script_Approved_Date')#")>
</cfif>

<!--- DESIGN DOC COMPLETION DATE --->
<cfif #$.content('Design_Doc_Completed_Date')# lte Now()>
	<cfset variables.status="Design Document Completed; Not Yet Signed">
	<cfset variables.StatusDate="#DateFormat($.content('Design_Doc_Completed_Date'),'m/d/yyyy')#">
</cfif>

<!--- DESIGN DOC APPROVED DATE --->
<cfif #$.content('Design_Doc_Approved_Date')# lte Now()>
	<cfset variables.status="Design Document Signed; Writing Script">
	<cfset variables.StatusDate="#DateFormat($.content('Design_Doc_Approved_Date'),'m/d/yyyy')#">
</cfif>

<!--- SCRIPT DOC APPROVED DATE --->
<cfif #$.content('Script_Approved_Date')# lte Now()>
	<cfset variables.status="Script Approved">
	<cfset variables.StatusDate="#DateFormat($.content('Script_Approved_Date'),'m/d/yyyy')#">
</cfif>

<!--- SYSTEM TESTING APPROVED DATE 
<cfif #$.content('System_Testing_Approved')# lte Now()>
	<cfset variables.status="System Testing Approved">
	<cfset variables.StatusDate="#DateFormat($.content('System_Testing_Approved'),'m/d/yyyy')#">
</cfif>--->

<!--- System_Test_Meeting_Date --->
<cfif #$.content('System_Test_Meeting_Date')# lte Now()>
	<cfset variables.status="System Test Meeting Date Held">
	<cfset variables.StatusDate="#DateFormat($.content('System_Test_Meeting_Date'),'m/d/yyyy')#">
</cfif>

<!--- Migrated to Production? --->
<cfif #$.content('Migrated_To_Production_Date')# LTE #Now()#>
	<cfset variables.MigratedToProduction = "Yes">
	<cfset variables.status="Migrated to Production">	
	<cfset variables.StatusDate="#DateFormat($.content('Migrated_To_Production_Date'),'m/d/yy')#">
<cfelse>
	<cfset variables.MigratedToProduction = "No">

</cfif>
<cfset DaysWorkingOnThis=dateDiff("d", variables.startDate, variables.statusdate)>

<!---  --->

<!---
Status is Design Document Approved: Testing if Design_Doc_Completed_Date is in the past and 
Status is Ready to Migrate if System_Test_Meeting_Date is not null and in the past and Design_Doc_Completed_Date is i

--->

			<h2 style="color:CRIMSON;">Status: #variables.status# <cfif variables.statusdate neq "">
				on #variables.statusdate#
			</cfif></h2>
			<h3 style="color:red;">Total Days: #DaysWorkingOnThis#</h3>
			<h3>Summary Information</h3>
			<table>
				<tr>
					<th>Assigned To</th>
					<th>Requested By</th>
					<th>SAP Assigned</th>
				</tr>
				<tr>
					<td>#$.content('Assigned_To')#</td>
					<td>#$.content('Submitted_By')#</td>
					<td>#$.content('SAP_Assigned')#</td>
				</tr>
</table>
			<h3>Official Documentation</h3>
			<p><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('System_Request_Form')#">
Systems Request Form</a></p>
<p>

	

	<a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Completed_Design_Document_File')#">
Design Document</a><cfif $.content('Design_Doc_Complete') is not ""> Completed on #Dateformat($.content('Design_Doc_Approved_Date'),'m/d/yyyy')#</cfif></p>


<p><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Scanned_Migration_Form')#">
Migration Form</a></p>

<div style="alert alert-info">
			<h3>Key Dates</h3>
			<p>Received by SA: #Dateformat($.content('Received_By_Systems_Admin'),'m/d/yyyy')#</p>
			<p>SA Signoff: #Dateformat($.content('Systems_Request_Signoff_Date'),'m/d/yyyy')#</p>
			<p><cfif variables.datesinceScriptApproved neq "">
				...#variables.datesinceScriptApproved# Days Later...
			</cfif>--- Functional Completion Date: #Dateformat($.content('Functional_Completion_Date'),'m/d/yyyy')#  </p>
			<p>Design Doc Approved Date: #Dateformat($.content('Design_Doc_Approved_Date'),'m/d/yyyy')#</p>
			<p>Script Approval: #Dateformat($.content('Script_Approved_Date'),'m/d/yyyy')#</p>
			<p>System Testing Approved?: <!--- #Dateformat($.content('System_Test_Meeting_Date'),'m/d/yyyy')# ---></p>
			<p>Migrated to Production: #Dateformat($.content('Migrated_To_Production_Date'),'m/d/yyyy')#</p>
</div>
		</article>
	</div>

	<cfoutput>
	Test Script Approved? <!--- #variables.ScriptApproved#  --->/ #$.content('Script_Approved_Date')#<br>
	System Testing completed? <!--- #variables.SystemTestingCompleted# ---> / #DateFormat($.content('System_Test_Meeting_Date'))#<br>
	Migrated to production? <!--- #variables.MigratedToProduction# ---> / #$.content('Migrated_To_Production_Date')#

</cfoutput>
	<cfinclude template="inc/footer.cfm" />
</div>

</cfoutput>