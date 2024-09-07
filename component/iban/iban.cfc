<!---
	iban.cfc (https://github.com/ggfx/coldfusion-iban)
	Component for converting Bank Account Number (BAN) and Institute Identifier (IID) to the International Bank Account Number (IBAN)
	-	 create_iban: creates IBAN from BAN and IID
	-	 validate_iban:  validates the correctness of an IBAN

	@Author	Cornelius Rittner
	@Website http://ggfx.org
	@Date	24.01.2014
--->
<cfcomponent displayname="iban" output="false" hint="converts bank account number and institute identifier to international bank account number">

	<cfset variables.cc = "">

	<cffunction name="init"
		access="public" output="false" hint="Constructor" returntype="iban">
		<cfargument name="cc" type="string" required="false" default="DE" hint="Alpha-2 Country Code ISO 3166">
		<cfset variables.cc = arguments.cc>
		<!--- <cfargument name="path_to_bic_directory" type="string" required="false" hint="Path to the flatfile database of BIC numbers, e.g. expandPath('./BIC-BLZ_20131209.txt')">
		<cfif structKeyExists(arguments,"path_to_bic_directory") AND arguments.path_to_bic_directory NEQ "" AND fileExists(arguments.path_to_bic_directory)>
			<cfset variables.path_to_bic_directory = arguments.path_to_bic_directory>
		</cfif> --->
		<cfreturn this />
	</cffunction>

<!---
	Main Functions
--->

	<cffunction name="create_iban"
		access="public" output="false" hint="Main function" returntype="any">
		<cfargument name="ban" type="string" required="true" hint="Bank Account Number">
		<cfargument name="iid" type="string" required="true" hint="Institute Identifier">
		<cfargument name="return_type" type="string" default="struct" hint="can be: struct, else returns only the iban">
		<cfscript>
			var bban = this.create_bban(ban:arguments.ban,iid:arguments.iid);
			var checksum = 0;
			var pz = 0;
			var iban = 0;
			if (isStruct(bban)) {
				// Error occured
				return bban;
			} else {
				// BBAN ok
				checksum = bban & variables.cc & "00";
				pz = this.create_pz(checksum);
				iban = ucase(variables.cc) & pz & bban;
				if (arguments.return_type EQ "struct") {
					return local;
				} else {
					return local.iban;
				}
			}
		</cfscript>
	</cffunction>

	<cffunction name="validate_iban"
		access="public" output="false" hint="validate iban, the result for a valid iban has to be 1">
		<cfargument name="iban" type="string" required="true">
		<cfscript>
			var local = structNew();
			local.checksum = right(arguments.iban,len(arguments.iban)-4) & left(arguments.iban,4);
			return this.create_pz(local.checksum,true);
		</cfscript>
	</cffunction>

<!---
	Helper functions
--->

	<cffunction name="bban_cleaner"
		access="package" output="false" hint="removes special chars">
		<cfargument name="bban_dirty" type="string" required="true">
		<cfscript>
			return reReplace(ucase(arguments.bban_dirty),"[^A-Z0-9]","","all");
		</cfscript>
	</cffunction>

	<cffunction name="create_pz"
		access="public" output="false" hint="either creats error checking number or validates checksum">
		<cfargument name="checksum" type="string" required="true">
		<cfargument name="validate" type="boolean" default="false">
		<cfscript>
			var local = structNew();
			local.alpha_list = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
			local.num_list = "10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36";
			local.modulo = createObject("java", "java.math.BigInteger").valueOf("97");

			local.checksum = replaceList(ucase(arguments.checksum),local.alpha_list,local.num_list);
			local.checkbig = createObject("java", "java.math.BigInteger").init(JavaCast("String", local.checksum));
			if (arguments.validate IS true) {
				return local.checkbig.remainder(modulo);
			} else {
				local.pz = numberFormat(98 - local.checkbig.remainder(modulo),"00");
				return local.pz;
			}
		</cfscript>
	</cffunction>

</cfcomponent>