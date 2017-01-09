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
	<cfset variables.status="Signed off by Systems Administration. ">
	<cfif $.content('Kickoff_Request') neq '' and $.content('Kickoff_Meeting_Date') eq ''>
		<cfset variables.Status = variables.status & "Kick off requested on ">
		<cfset variables.StatusDate = #Dateformat($.content('Kickoff_Request'),'m/d/yyyy')#>
	</cfif>
	<cfset variables.StatusDate="#DateFormat($.content('Systems_Request_Signoff_Date'),'m/d/yyyy')#">
</cfif>

<!--- KICKED OFF --->
<cfif #$.content('Kickoff_Meeting_Date')# lte Now() and #$.content('Kickoff_Meeting_Date')# neq "">
	<cfset variables.status="Kicked off  ">
	<!--- <cfif $.content('Kickoff_Request') neq '' and $.content('Kickoff_Meeting_Date') eq ''>
		<cfset variables.Status = variables.status & "on ">
		<cfset variables.StatusDate = #Dateformat($.content('Kickoff_Meeting_Date'),'m/d/yyyy')#>
	</cfif> --->
	<cfset variables.StatusDate="#DateFormat($.content('Kickoff_Meeting_Date'),'m/d/yyyy')#">
<!--- <cfelse>
	<cfsavecontent variable="SendKickoffRequest">
		<a href="mailto:webmaster@illinoiscomptroller.gov">Send Email to #$.content('SAP_Assigned')# requesting kickoff</a>
	</cfsavecontent> --->
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
	<cfset variables.StatusDate="#DateFormat($.content('Migrated_To_Production_Date'),'m/d/yyyy')#">
<cfelse>
	<cfset variables.MigratedToProduction = "No">

</cfif>


<!---
<cfset DaysWorkingOnThis=dateDiff("d", variables.startDate, variables.statusdate)>

--->
<cfset DaysWorkingOnThis=dateDiff("d", variables.startDate, now())>
<!---
Status is Design Document Approved: Testing if Design_Doc_Completed_Date is in the past and
Status is Ready to Migrate if Syste_Test_Meeting_Date is not null and in the past and Design_Doc_Completed_Date is i

--->

			<h3>Status of Request: #$.content('status')# - (#variables.status# <cfif variables.statusdate neq "">
				on #variables.statusdate#<cfif variables.nextStatus neq "">)
					; Currently #variables.nextStatus#
				</cfif>)
			</cfif></h3>
			<cfif $.content('Kickoff_Meeting_Date') neq "" and DaysWorkingOnThis gt "0">

				<h4>Total Days since Kickoff: <!--- #DaysWorkingOnThis# --->
				<!--- Check to ensure date has been entered --->
			<cfif isDate($.content('Kickoff_Meeting_Date'))>
				#Dateformat($.content('Kickoff_Meeting_Date'),'m/d/yyyy')# (#dateDiff('d',$.content('Kickoff_Meeting_Date'),Now())# days ago)
			<cfelse>
				Not yet entered into system.
			</cfif>
				</h4>

				<!--- <h4>Total Days since Kickoff: #DaysWorkingOnThis#</h4> --->
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
					 <td>#$.content('SAP_Assigned')# <!---#SendKickoffRequest#---></td> 
				</tr>
</table>
			<h1>Official Documentation</h1>

<cfscript>
	content=$.content();
		// Get an iterator of the documentation and artifacts as children this Systems Request.
		iterator = content.getKidsIterator();
		iterator.setNextN(1);
</cfscript>
<cfoutput>

<cfset i="0">
<cfset j="0">

<cfset arrayMigrations=ArrayNew(2)>
<cfset arrayTestResults=ArrayNew(2)>

<cfloop from="1" to="#iterator.pageCount()#" index="p">
	<cfset iterator.setPage(p)>
	<!--- <ul> --->
		<cfloop condition="iterator.hasNext()">

			<cfset item=iterator.next()>

			<cfset variables.TypeOfDocument = item.getValue('subtype')>

				<!--- What type of document is this? --->
			<cfswitch expression="#variables.TypeOfDocument#">

				<cfcase value="System Request Form">

					<cfsavecontent variable="variables.SRFormContent">

					<table>
						<tr>
							<th colspan="2" align="center" style="text-align:center; vertical-align:middle;">Date Received</th>
							<th>&nbsp;</th>
						<tr>
							<th>SysAdmin</th><th>I.T.</th><th>File</th>
						</tr>
						<cfset variables.DateReceivedBySA = "#DateFormat(item.getValue('DateReceivedBySA'),'m/d/yyyy')#">
						<cfset variables.DateReceivedByIT = "#DateFormat(item.getValue('DateReceivedByIT'),'m/d/yyyy')#">
						<tr>
							<td>#variables.DateReceivedBySA#</td>
							<td>#variables.DateReceivedByIT#</td>
							<td><a href="#item.getURL()#">#HTMLEditFormat(item.getMenuTitle())#
					</a></td>
						</tr>
					</table>
					</cfsavecontent>
				</cfcase>
				<cfcase value="Migration Form">

					<cfset i = i+1>

					<!--- <cfset arrayMigrations=ArrayNew(2)> --->

					<cfset arrayMigrations[i][1] = "#item.getValue('Region')#">
					<cfset arrayMigrations[i][2] = "#HTMLEditFormat(item.getMenuTitle())#">
					<cfset arrayMigrations[i][3] = "#item.getURL()#">
					<cfset arrayMigrations[i][4] = "#item.getValue('Date_Migrated')#">

				</cfcase>
				<cfdefaultcase>

				</cfdefaultcase>
				<cfcase value="Design Document">
					<cfsavecontent variable="variables.DesignDocContent">	<!--- Using CFSaveContent rather than an array here since there is only one design doc --->

					<table>
						<tr>
							<th>Upload Date</th>
							<th>Ready Date</th>
							<th>Vote Date</th>
							<th>Approved Date</th>
							<th>Version</th>
							<th>Download</th>
							<th>Notes</th>
						</tr>
						<tr>
							<cfset variables.DDCompletedDate="#item.getValue('DesignDocCompletedDate')#">
							<cfset variables.DDVotingDate="#item.getValue('DesignDocSentForVotingDate')#">
							<cfset variables.DDApprovedDate="#item.getValue('ApprovedDate')#">
							<cfset variables.DDUploadDate="#item.getValue('lastUpdate')#">
							<cfset variables.summary = "#item.getValue('summary')#">

							<td>#Dateformat(variables.DDUploadDate,"m/d/yyyy")# (#item.getValue('lastUpdateBy')#)</td>
							<td><cfif variables.DDCompletedDate eq "">DRAFT<CFELSE>#Dateformat(variables.DDCompletedDate,"m/d/yyyy")#</cfif>
							</td>
							<td><cfif variables.DDCompletedDate eq "">DRAFT<CFELSE>#Dateformat(variables.DDVotingDate,"m/d/yyyy")#</cfif>
							</td>
							<td><cfif variables.DDCompletedDate eq "">DRAFT<CFELSE>#Dateformat(variables.DDApprovedDate,"m/d/yyyy")#</cfif>
							</td>
							<td>#item.getValue('majorversion')#.#item.getValue('minorversion')#</td>
							<td><a href="#item.getURL()#">#HTMLEditFormat(item.getMenuTitle())#</a></td>
							<td>#variables.summary#</td>
						</tr>
					</table>
					<!--- <cfdump var="#item.getContentBean()#">	  --->
					</cfsavecontent>

				</cfcase>
				<!--- if there become multiple test scripts, this cfsavecontent for test scripts will be changed to an array, like test results --->
				<cfcase value="Test Script">

					<cfsavecontent variable="variables.TSFormContent">

					<table>
						<tr>

							<th>Test Script</th>
						</tr>

						<tr>

							<td><a href="#item.getURL()#">#HTMLEditFormat(item.getMenuTitle())#</a></td>
						</tr>
					</table>
					</cfsavecontent>
				</cfcase>
				<cfcase value="Test Results">

						<cfset j = j+1>

						<cfset arrayTestResults[j][1] = "#item.getTRReadyDate()#"> 					<!--- "TRReadyDate" is an Attribute. Both item.getTRReadyDate() and item.getValue('TRReadyDate') will work --->
						<cfset arrayTestResults[j][2] = "#item.getValue('TRVotingDate')#">	<!--- Here is an example of the other way you can get a value --->
						<cfset arrayTestResults[j][3] = "#item.getValue('TRApprovedDate')#">
						<cfset arrayTestResults[j][4] = "#item.getTestingType()#">
						<cfset arrayTestResults[j][5] = "#item.getURL()#">
						<cfset arrayTestResults[j][6] = "#item.getMenuTitle()#">

				</cfcase>
			</cfswitch>
			<!--- </li> --->
		</cfloop>
	<!--- </ul> --->
</cfloop>

			<h3>Systems Request Form</h3>
			<cfif not isDefined("variables.SRFormContent")>
				<p>Content not yet available.</p>
			<cfelse>
				#variables.SRFormContent#
			</cfif>

			<h3>Design Document</h3>
			<cfif not isDefined("variables.DesignDocContent")>
				<!--- Determine if Design Doc is needed --->
				<cfif $.content('Design_Doc_Necessary') eq "Yes">
				<p>Content not yet available.</p>
				<cfelse>
				<p>Design Document Not Required for this SR.</p>
				</cfif>
			<cfelse>
				#variables.DesignDocContent#
			</cfif>

			<h3>Testing</h3>

 			<h4>Test Results</h4>

			<table>
				<tr>
					<th>Ready Date</th>
					<th>Vote Date</th>
					<th>Approved Date</th>
					<th>System or User?</th>
					<th>Download</th>
				</tr>
<cfloop array="#arrayTestResults#" index="k">
				<tr>
					<td>#DateFormat(k[1],'m/d/yyyy')#</td>
					 <td>#DateFormat(k[2],'m/d/yyyy')#</td>
					 <td>#DateFormat(k[3],'m/d/yyyy')#</td>
					 <td>
						 #k[4]#</td>
					<td><a href="#k[5]#">#k[6]#</a></td>
				</tr>
</cfloop>
</table>
			<h3>Migration Form(s)</h3>

			<!--- <cfdump var="#arrayMigrations#"> --->

			<!--- Position 1 is Region, Position 2 is Name of Document --->
			<table>
				<tr>
					<th>Region</th><th>Name of Form</th><th>Date Migrated</th>
				</tr>
			<!--- array loop in CF 2016 is 2,500x faster than CF 11 !!! --->
			<cfloop array="#arrayMigrations#" index="g">
				<tr>
					<td>#g[1]#</td>
					<td><a href="#g[3]#">#j[2]#</a></td>
					<td>#dateformat(g[4], 'm/d/yyyy')#</td>
				</tr>

			</cfloop>
			</table>
</cfoutput>



<div style="alert alert-info">
			<h3>Key Dates</h3>
			<ul>

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
