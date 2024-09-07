<cfcomponent extends="iban">

	<cffunction access="public" returntype="any" name="create_bban"
		output="false" hint="iban length 21, means 17 places">
		<cfargument name="ban" type="string" required="true" hint="Bank Account Number max 12 alphanumeric places">
		<cfargument name="iid" type="string" required="true" hint="Institute Identification max 5 digits">
		<cfscript>
			var error = false;
			var msg = "";
			var bban_clean = bban_cleaner(arguments.ban);
			if (len(bban_clean) LT 12) {
				bban_clean = repeatString("0",12-len(bban_clean)) & bban_clean;
			}
			if (len(bban_clean) GT 12) {
				error = true;
				msg = "BAN is not has more than 12 places";
			}
			if (Not IsNumeric(arguments.iid) OR len(arguments.iid) GT 5) {
				error = true;
				msg = "IID is not numeric or has more than 5 digits";
			}

			if (error IS true) return local;

			return numberFormat(arguments.iid,"00000") & local.bban_clean;
		</cfscript>
	</cffunction>

</cfcomponent>