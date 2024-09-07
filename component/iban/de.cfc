<cfcomponent extends="iban">

	<cffunction name="init"
		access="public" output="false" hint="Constructor" returntype="any">
		<cfset this = super.init("DE")>
		<cfreturn this />
	</cffunction>

	<cffunction name="create_bban"
		access="public" output="false" hint="iban length 22, means 18 digits">
		<cfargument name="ban" type="string" required="true" hint="Bank Account Number max 10 digits">
		<cfargument name="iid" type="string" required="true" hint="Institute Identification always 8 digits">
		<cfscript>
			var local = structNew();
			local.error = false;
			if (Not IsNumeric(arguments.ban) OR len(arguments.ban) GT 10) {
				local.error = true;
				local.ban = "BAN is not numeric or has more than 10 digits";
			}
			if (Not IsNumeric(arguments.iid) OR len(arguments.iid) NEQ 8) {
				local.error = true;
				local.iid = "IID is not numeric or has not exactly 8 digits";
			}

			if (local.error IS true) return local;

			return numberFormat(arguments.iid,"00000000") & numberFormat(arguments.ban,"0000000000");
		</cfscript>
	</cffunction>

</cfcomponent>