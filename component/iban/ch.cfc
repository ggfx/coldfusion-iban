<cfcomponent extends="iban">

	<cffunction name="create_bban"
		access="public" output="false" hint="iban length 21, means 17 places">
		<cfargument name="ban" type="string" required="true" hint="Bank Account Number max 12 alphanumeric places">
		<cfargument name="iid" type="string" required="true" hint="Institute Identification max 5 digits">
		<cfscript>
			var local = structNew();
			local.error = false;
			local.bban_clean = bban_cleaner(arguments.ban);
			if (len(local.bban_clean) LT 12) {
				local.bban_clean = repeatString("0",12-len(local.bban_clean)) & local.bban_clean;
			}
			if (len(local.bban_clean) GT 12) {
				local.error = true;
				local.ban = "BAN is not has more than 12 places";
			}
			if (Not IsNumeric(arguments.iid) OR len(arguments.iid) GT 5) {
				local.error = true;
				local.iid = "IID is not numeric or has more than 5 digits";
			}

			if (local.error IS true) return local;

			return numberFormat(arguments.iid,"00000") & local.bban_clean;
		</cfscript>
	</cffunction>

</cfcomponent>