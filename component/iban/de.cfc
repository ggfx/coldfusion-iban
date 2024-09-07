<cfcomponent extends="iban">

	<cffunction access="public" returntype="any" name="init"
		output="false" hint="Constructor" >
		<cfset this = super.init("DE")>
		<cfreturn this />
	</cffunction>

	<cffunction access="public" returntype="any" name="create_bban"
		output="false" hint="iban length 22, means 18 digits">
		<cfargument name="ban" type="string" required="true" hint="Bank Account Number max 10 digits">
		<cfargument name="iid" type="string" required="true" hint="Institute Identification always 8 digits">
		<cfscript>
			var error = false;
			var msg = "";
			if (Not IsNumeric(arguments.ban) OR len(arguments.ban) GT 10) {
				error = true;
				msg = "BAN is not numeric or has more than 10 digits";
			}
			if (Not IsNumeric(arguments.iid) OR len(arguments.iid) NEQ 8) {
				error = true;
				msg = "IID is not numeric or has not exactly 8 digits";
			}

			if (error IS true) return local;

			return numberFormat(arguments.iid,"00000000") & numberFormat(arguments.ban,"0000000000");
		</cfscript>
	</cffunction>

</cfcomponent>