<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="twoColSR depth#arrayLen($.event('crumbdata'))#">
<div id="container" class="#$.createCSSid($.content('menuTitle'))#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<article>
			<nav>#$.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#</nav>


<!----- SYSTEMS REQUEST CODE ------------>
<cfif $.content('Kickoff_Request') neq "">
	<cfset variables.StartDate="#$.content('Kickoff_Request')#">
<cfelseif $.content('Systems_Request_Signoff_Date') neq "">
	<cfset variables.StartDate="#$.content('Systems_Request_Signoff_Date')#">	<!--- dateAdd('yyyy',-2,Now()) --->
<cfelse>
	<cfset variables.startDate = "#Now()#">
</cfif>

<cfparam name="variables.status" default="Received by IT">
<cfparam name="variables.datesinceScriptApproved" default="">
<cfparam name="variables.nextStatus" default="">

<h2>SR #$.content('SystemsRequestNumber')#: #$.content('System_Title')#</h2>

#$.dspBody(body=$.content('Summary'),pageTitle=$.content(''),crumbList=0,showMetaImage=1)#

<cfset variables.StatusDate="">
<!--- RECEIVED BY SYSTEMS ADMIN --->
<cfif #$.content('Systems_Request_Signoff_Date')# neq "" and #$.content('Systems_Request_Signoff_Date')# lte Now()>
	<cfset variables.status="Signed off by Systems Administration ">
	<cfif $.content('Kickoff_Request') neq '' and $.content('Kickoff_Meeting_Date') eq ''>
		<cfset variables.Status = variables.status & "Kick off requested on ">
		<cfset variables.StatusDate = #Dateformat($.content('Kickoff_Request'),'m/d/yyyy')#>
	</cfif>
	<cfset variables.StatusDate="#DateFormat($.content('Systems_Request_Signoff_Date'),'m/d/yyyy')#">
</cfif>

<!--- KICKED OFF --->
<cfif #$.content('Kickoff_Meeting_Date')# lte Now()>
	<cfset variables.status="Kicked off  ">
	<!--- <cfif $.content('Kickoff_Request') neq '' and $.content('Kickoff_Meeting_Date') eq ''>
		<cfset variables.Status = variables.status & "on ">
		<cfset variables.StatusDate = #Dateformat($.content('Kickoff_Meeting_Date'),'m/d/yyyy')#>
	</cfif> --->
	<cfset variables.StatusDate="#DateFormat($.content('Kickoff_Meeting_Date'),'m/d/yyyy')#">
</cfif>

<!--- FUNCTIONAL COMPLETION DATE --->
<cfif #$.content('Functional_Completion_Date')# neq "" and #$.content('Functional_Completion_Date')# lte Now()>
	<cfset variables.status="Functional Portion of Document Completed">
	<cfset variables.StatusDate="#DateFormat($.content('Functional_Completion_Date'),'m/d/yyyy')#">
	<cfif $.content('functional_Completion_Date') neq "" and $.content('Script_Approved_Date') neq "">
		<cfset variables.datesinceScriptApproved = dateDiff("d", "#$.content('functional_Completion_Date')#", "#$.content('Script_Approved_Date')#")>
	</cfif>

</cfif>

<!--- DESIGN DOC COMPLETION DATE --->
<cfif #$.content('Design_Doc_Completed_Date')# neq "" and #$.content('Design_Doc_Completed_Date')# lte Now()>
	<cfset variables.status="Design Document Completed (Not Yet Approved)">
	<cfset variables.StatusDate="#DateFormat($.content('Design_Doc_Completed_Date'),'m/d/yyyy')#">
</cfif>

<!--- DESIGN DOC APPROVED DATE --->
<cfif #$.content('Design_Doc_Approved_Date')# neq "" and  #$.content('Design_Doc_Approved_Date')# lte Now()>
	<cfset variables.status="Design Document Signed">
	<cfset variables.StatusDate="#DateFormat($.content('Design_Doc_Approved_Date'),'m/d/yyyy')#">
	<cfset variables.nextStatus = "in Programming">
</cfif>

<!--- SCRIPT DOC APPROVED DATE --->
<cfif #$.content('Script_Approved_Date')# neq "" and #$.content('Script_Approved_Date')# lte Now()>
	<cfset variables.status="Script Approved">
	<cfset variables.nextStatus = "Ready for Migration to Production">
	<cfset variables.StatusDate="#DateFormat($.content('Script_Approved_Date'),'m/d/yyyy')#">
</cfif>

<!--- UAT MIGRATION APPROVED DATE --->
<cfif #$.content('UATMigrationForm')# neq "" and #$.content('Date_Migrated_To_UAT')# lte Now()>
	<cfset variables.status="Migrated to UAT">
	<cfset variables.nextStatus = "Ready for continued testing/documentation/production migration">
	<cfset variables.StatusDate="#DateFormat($.content('Date_Migrated_To_UAT'),'m/d/yyyy')#">
</cfif>

<!--- SYSTEM TESTING APPROVED DATE
<cfif #$.content('System_Testing_Approved')# lte Now()>
	<cfset variables.status="System Testing Approved">
	<cfset variables.StatusDate="#DateFormat($.content('System_Testing_Approved'),'m/d/yyyy')#">
</cfif>--->

<!--- System_Test_Meeting_Date --->
<cfif #$.content('System_Test_Meeting_Date')# neq "" and  #$.content('System_Test_Meeting_Date')# lte Now()>
	<cfset variables.status="System Testing Approved">
	<cfset variables.StatusDate="#DateFormat($.content('System_Test_Meeting_Date'),'m/d/yyyy')#">
</cfif>

<!--- Migrated to Production? --->
<cfif #$.content('Migrated_To_Production_Date')# neq "" and  #$.content('Migrated_To_Production_Date')# LTE #Now()#>
	<cfset variables.MigratedToProduction = "Yes">
	<cfset variables.status="Migrated to Production">
	<cfset variables.nextStatus = "">
	<cfset variables.StatusDate="#DateFormat($.content('Migrated_To_Production_Date'),'m/d/yy')#">
<cfelse>
	<cfset variables.MigratedToProduction = "No">

</cfif>


<!---
<cfset DaysWorkingOnThis=dateDiff("d", variables.startDate, variables.statusdate)>

--->
<cfset DaysWorkingOnThis=dateDiff("d", variables.startDate, now())>
<!---
Status is Design Document Approved: Testing if Design_Doc_Completed_Date is in the past and
Status is Ready to Migrate if System_Test_Meeting_Date is not null and in the past and Design_Doc_Completed_Date is i

--->

			<h3>Status of Request: #variables.status# <cfif variables.statusdate neq "">
				on #variables.statusdate#<cfif variables.nextStatus neq "">
					; Currently #variables.nextStatus#
				</cfif>
			</cfif></h3>
			<cfif $.content('Kickoff_Meeting_Date') neq "" and DaysWorkingOnThis gt "0">
				<h4>Total Days since Kickoff: #DaysWorkingOnThis#</h4>
			</cfif>

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
			<h1>Official Documentation</h1>

<cfscript>
	content=$.content();

		// Get an iterator of the node's child content.
		iterator = content.getKidsIterator();

		iterator.setNextN(1);
</cfscript>
<cfoutput>	<cfset variables.numberOfMigrationForms = "0">
<cfloop from="1" to="#iterator.pageCount()#" index="p">
	<cfset iterator.setPage(p)>
	<!--- <ul> --->

		<cfloop condition="iterator.hasNext()" group="#variables.TypeOfDocument#">

			<cfset item=iterator.next()>

			<cfset variables.TypeOfDocument = item.getValue('subtype')>

			<cfswitch expression="#variables.TypeOfDocument#">
				<cfcase value="System Request Form">

					<cfsavecontent variable="variables.SRFormContent">
					<a href="#item.getURL()#">
					#HTMLEditFormat(item.getMenuTitle())#
					</a>
					<table>
						<tr>
							<th>Date Received Systems Admin</th><th>Date Received I.T.</th>
						</tr>
						<tr>
							<td>#item.getValue('DateReceivedBySA')#</td>
							<td>#item.getValue('DateReceivedByIT')#</td>
						</tr>
					</table>
					</cfsavecontent>
				</cfcase>
				<cfcase value="Migration Form">

					<cfset variables.numberOfMigrationForms = variables.numberOfMigrationForms + 1>

					<cfsavecontent variable="variables.MigrationFormContent#variables.numberOfMigrationForms#">

					<p>#variables.numberOfMigrationForms#: Download <a href="#item.getURL()#">#HTMLEditFormat(item.getMenuTitle())#</a>
					<table>
						<tr>
							<th>Region</th>
							<th>Date Requested</th>
							<th>Date Migrated</th>
							<th>Date Verified</th>
						</tr>
							<td>#item.getValue('Region')#</td>
							<cfset variables.MFRequestedDate="#item.getValue('Date_Requested')#">
							<td>#Dateformat(variables.MFRequestedDate,"m/d/yyyy")#</td>
							<cfset variables.MFMigratedDate="#item.getValue('Date_Migrated')#">
							<td>#Dateformat(variables.MFMigratedDate,"m/d/yyyy")#</td>
							<cfset variables.MFVerifiedDate="#item.getValue('Date_Verified')#">
							<td>#Dateformat(variables.MFVerifiedDate,"m/d/yyyy")#</td>
						</tr>
					</table>

					</cfsavecontent>
				</cfcase>
				<cfdefaultcase>
					Who knows
				</cfdefaultcase>
				<cfcase value="Design Document">
					<cfsavecontent variable="variables.DesignDocContent">
					<p>Download <a href="#item.getURL()#">
					<!--- #iterator.currentIndex()#:  --->
					#HTMLEditFormat(item.getMenuTitle())#
					 </a>
					<table>
						<tr>
							<th>Approved Date</th>
						</tr>
						<tr><cfset variables.DDApprovedDate="#item.getValue('ApprovedDate')#">
							<td>#Dateformat(variables.DDApprovedDate,"m/d/yyyy")#</td>
						</tr>
					</table>
					</cfsavecontent>

				</cfcase>
			</cfswitch>
			<!--- </li> --->
		</cfloop>
	<!--- </ul> --->
</cfloop>

			<h3>Systems Request Form</h3>
			<cfif not isDefined("variables.SRFormContent")>
				<p>Content Not Available</p>
			<cfelse>
				#variables.SRFormContent#
			</cfif>

			<h3>Design Document</h3>
			<cfif not isDefined("variables.DesignDocContent")>
				<p>Content Not Available</p>
			<cfelse>
				#variables.DesignDocContent#
			</cfif>


			<h3>Migration Form(s)</h3>


NUMBER OF MIGRATION FORMS: #variables.numberOfMigrationForms#
<!--- xxxxxx<cfdump var="#listlen(variables.numberOfMigrationForms)#">xxxxxx
<cfabort> --->
<cfloop list="#variables.numberOfMigrationForms#" index="i">
	<hr>
#i#

</cfloop>
<!---
<!--- this is such a bad way to do this but I am running out of time --->
<cfif variables.numberofmigrationforms gt 0>
	#variables.MigrationFormContent1#
</cfif>

<cfif variables.numberofmigrationforms gt 1>
	#variables.MigrationFormContent2#
</cfif> --->

<!------> <cfloop from="1" to="#variables.numberOfMigrationForms#" index="i">
<b>#i#</b><br>
<!---  #variables.MigrationFormContent#[i]## --->
</cfloop>
</cfoutput>

			<!--- REVISIONS COMING SOON --->
			<!---
			<ul>
			<cfif $.content('System_Request_Form') is not "">
				<li><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('System_Request_Form')#">Systems Request Form</a></li>
			<cfelse>
				<li>Systems Request Form <b>not yet on file</b></li>
			</cfif>


			<cfif $.content('Completed_Design_Document_File') is not "">
				<li><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Completed_Design_Document_File')#">Design Document</a>
				<cfif $.content('Design_Doc_Approved_Date') neq "">
				 Completed on #Dateformat($.content('Design_Doc_Approved_Date'),'m/d/yyyy')#
				 <cfelse>
				 (DRAFT) Not Yet Completed
				</cfif>
				</li>
			<cfelse>
				<li>Design Document <b>not yet on file</b>. </li>
			</cfif>

			<cfif $.content('UATMigrationForm') is not "">
				<li><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('UATMigrationForm')#">UAT Migration Form</a>
				<!--- <cfif $.content('Script_Approved_Date') neq "">
				 UAT Migration Approved on #Dateformat($.content('Script_Approved_Date'),'m/d/yyyy')#
				</cfif> --->
				</li>
			<cfelse>
				<li>UAT Script <b>not yet on file</b>. </li>
			</cfif>

			<cfif $.content('Completed_UAT_Script_File') is not "">
				<li><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Completed_UAT_Script_File')#">UAT Script</a>
				<cfif $.content('Script_Approved_Date') neq "">
				 Script Approved on #Dateformat($.content('Script_Approved_Date'),'m/d/yyyy')#
				</cfif>
				</li>
			<cfelse>
				<li>UAT Script <b>not yet on file</b>. </li>
			</cfif>

			<cfif $.content('Completed_Test_Results_File') is not "">
				<li><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Completed_Test_Results_File')#">Test Results</a>
				<cfif $.content('System_Test_Meeting_Date') neq "">
				 Completed on #Dateformat($.content('System_Test_Meeting_Date'),'m/d/yyyy')#
				</cfif>
				</li>
			<cfelse>
				<li>Completed Test Results <b>not yet on file</b>.</li>
			</cfif>

			<cfif $.content('Scanned_Migration_Form') is not "">
				<li><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Scanned_Migration_Form')#">Migration Form</a>
				<cfif $.content('Migrated_To_Production_Date') neq "">
				 Completed on #Dateformat($.content('Migrated_To_Production_Date'),'m/d/yyyy')#
				</cfif>
				</li>
			<cfelse>
				<li>Migration Form <b>not yet on file</b>.</li>
			</cfif>

			</ul>
			--->

<!--- </cfif> --->



<!--- <p><a target="_blank" href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Scanned_Migration_Form')#">
Migration Form</a></p> --->

<div style="alert alert-info">
			<h3>Key Dates</h3>
			<ul>
			<li>Received by Systems Administration:
			<!--- Check to ensure date has been entered --->
			<cfif isDate($.content('Received_By_Systems_Admin'))>
				#Dateformat($.content('Received_By_Systems_Admin'),'m/d/yyyy')# (#dateDiff('d',$.content('Received_By_Systems_Admin'),Now())# days ago)
			<cfelse>
				Not yet entered into system.
			</cfif>
			</li></li>

			<li>Systems Administration Signoff:
			<!--- Check to ensure date has been entered --->
			<cfif isDate($.content('Systems_Request_Signoff_Date'))>
				#Dateformat($.content('Systems_Request_Signoff_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Systems_Request_Signoff_Date'),Now())# days ago)
			<cfelse>
				Not yet entered into system.
			</cfif>

			<li>Kickoff Requested by IT:
			<!--- Check to ensure date has been entered --->
			<cfif isDate($.content('Kickoff_Request'))>
				#Dateformat($.content('Kickoff_Request'),'m/d/yyyy')# (#dateDiff('d',$.content('Kickoff_Request'),Now())# days ago)
			<cfelse>
				Not yet entered into system.
			</cfif>

			<li>Kickoff Meeting Held:
			<!--- Check to ensure date has been entered --->
			<cfif isDate($.content('Kickoff_Meeting_Date'))>
				#Dateformat($.content('Kickoff_Meeting_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Kickoff_Meeting_Date'),Now())# days ago)
			<cfelse>
				Not yet entered into system.
			</cfif>

			<!--- <cfif variables.datesinceScriptApproved neq "">
				...#variables.datesinceScriptApproved# Days Later...
			</cfif> ---></li>
			<cfif $.content('Functional_Completion_Date') is not "">
			<li>Functional Portion Completion Date: #Dateformat($.content('Functional_Completion_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Functional_Completion_Date'),Now())# days ago)
			</li>
			</cfif>

			<cfif $.content('Design_Doc_Completed_Date') is not "">
				<li>Design Doc Completed on #Dateformat($.content('Design_Doc_Completed_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Design_Doc_Completed_Date'),Now())# days ago)<!--- . <a href="#$.globalConfig('context')#/tasks/render/file/?fileID=#$.content('Completed_Design_Document_File')#">Download Design Document</a>. ---> </li>
			</cfif>

			<cfif $.content('Design_Doc_Approved_Date') is not "">
				<li>Design Doc Approved Date: #Dateformat($.content('Design_Doc_Approved_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Design_Doc_Approved_Date'),Now())# days ago)</li>

			</cfif>
			<cfif $.content('Script_Approved_Date') neq "">
							<li>Script Approved on #Dateformat($.content('Script_Approved_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Script_Approved_Date'),Now())# days ago)</li>
			</cfif>
			<cfif $.content('System_Test_Meeting_Date') neq "">
				<li>System Testing Approved on #Dateformat($.content('System_Test_Meeting_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('System_Test_Meeting_Date'),Now())# days ago)</li>
			</cfif>
			<cfif $.content('Migrated_To_Production_Date') neq "">
							<li>Migrated to Production: #Dateformat($.content('Migrated_To_Production_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Migrated_To_Production_Date'),Now())# days ago)</li>
			</cfif>
			</ul>

</div>
		</article>
	<!--- </div>
	<hr> --->

	<!--- Test Script Approved? - #variables.ScriptApproved#  -/ #$.content('Script_Approved_Date')#<br>
	System Testing completed? - #variables.SystemTestingCompleted# - / #DateFormat($.content('System_Test_Meeting_Date'))#<br>
	Migrated to production? - #variables.MigratedToProduction# - / #$.content('Migrated_To_Production_Date')# --->










<!----- END SYSTEMS REQUEST CODE ------------>

			<!--- #$.dspObjects(2)# --->
		<!--- </article> --->
		<aside id="right">
			#$.dspObjects(3)#
		</aside>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>
