<cfoutput>
<table background="#$.siteConfig('themeAssetPath')#/images/HeaderW800H100.png" border="0" cellspacing="0" cellpadding="0" width="100%" height="100" style="border:0px;">
<tr>
	
	<td width="50%" valign="middle" style="border:0px;">&nbsp;
	
	
	
	</td>


<td nowrap width="40%" align="right" valign="middle" style="border:0px;">

<!---<a class="topnav" href="../administration/login.cfm" target="right">admin</a></a> 

 <font class="divider">| <a class="topnav" href="../administration/feedback_form.cfm" target="right">feedback</a></a>




	
		<font class="divider">|
		<a href="javascript: emailPath();" class="topnav">email page</a>
	

&nbsp;

--->

</td>	


</tr>
</table>
	<!---<header class="clearfix">
		<hgroup>
		<h1><a href="#$.createHREF(filename='')#">#HTMLEditFormat($.siteConfig('site'))#</a></h1>
		<cfif len($.siteConfig('tagline'))><h2 class="tagline">#$.siteConfig('tagline')#</h2></cfif>
		</hgroup>
		
		<nav>
		<ul class="navUtility">
			<li><a href="#$.createHREF(filename='about-us')#">About Us</a></li>
			<li class="last"><a href="#$.createHREF(filename='contact')#">Contact</a></li>
		</ul>
		</nav>
		<form action="" id="searchForm">
			<fieldset>
				<input type="text" name="Keywords" id="txtKeywords" class="text" value="Search" onfocus="this.value=(this.value=='Search') ? '' : this.value;" onblur="this.value=(this.value=='') ? 'Search' : this.value;" />
				<input type="hidden" name="display" value="search" />
				<input type="hidden" name="newSearch" value="true" />
				<input type="hidden" name="noCache" value="1" />
				<input type="submit" class="submit" value="Go" />
			</fieldset>
		</form>
		<nav>
		<cf_CacheOMatic key="dspPrimaryNav#request.contentBean.getcontentID()#">
			#$.dspPrimaryNav(
				viewDepth="1",
				id="navPrimary",
				displayHome="Always",
				closePortals="true",
				showCurrentChildrenOnly="false"
				)#</cf_cacheomatic>
		<!--- Optional named arguments for Primary Nav are: displayHome="Always/Never/Conditional", openPortals/closePortals="contentid,contentid" (i.e. show specific sub-content in dropdown nav) --->
		</nav>
	</header>--->
</cfoutput>