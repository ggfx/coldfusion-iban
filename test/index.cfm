<cfscript>
    param name="form.iban"  default="";
    param name="form.ktnr"  default="";
    param name="form.blz"   default="";
    param name="form.locale" default="DE";
    if (structKeyExists(form,"convert")
        && len(form.ktnr) > 0
        && len(form.blz) == 8) {
        obj_iban = new component.iban.de();
        result = obj_iban.create_iban(form.ktnr,form.blz);
        if (structKeyExists(result, "error")) {
            writeOutput('<pre class="mt-2 mb-3 p-1 border border-warning rounded">#serializeJSON(result)#</pre>');
        } else {
            writeOutput('<div class="input-group input-group mb-1 mt-3"><span class="input-group-text">IBAN</span><input type="text" class="form-control is-valid" value="#result.iban#" readonly /></div><pre class="mb-3 p-1 border border-primary rounded">Prüfziffer: #result.pz#<br/>Checksum: #result.checksum#</pre>');
        }
        abort;
    }
    if (structKeyExists(form,"validate")
        && len(form.iban) > 0) {
        obj_iban = new component.iban.iban();
        validation = ( obj_iban.validate_iban(form.iban) == 1 ) ? "valid" : "invalid";
        writeOutput('<input hx-swap="outerHTML" hx-target="this" type="text" class="form-control is-#validation#" name="iban" id="iban" placeholder="XY00123456781234567890" value="#htmlEditFormat(form.iban)#" required/>');
        abort;
    }
</cfscript>
<!doctype html>
<html lang="en">
    <head>
        <title>IBAN Tests</title>
        <!-- Required meta tags -->
        <meta charset="utf-8" />
        <meta
            name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no"
        />
        <!-- Bootstrap CSS v5.2.1 -->
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
            crossorigin="anonymous"
        />
        <script src="https://unpkg.com/htmx.org@2.0.2" integrity="sha384-Y7hw+L/jvKeWIRRkqWYfPcvVxHzVzn5REgzbawhxAuQGwX1XWe70vji+VSeHOThJ" crossorigin="anonymous"></script>
    </head>

    <body>
        <main class="container py-4">
            <div class="border border-info rounded p-3 mb-3 shadow">
            <cfoutput>
                <form hx-post="/" hx-target="##iban" hx-swap="outerHTML">
                    <div class="mb-3">
                        <label for="iban" class="form-label">IBAN Validator</label>
                        <input
                            type="text"
                            class="form-control"
                            name="iban"
                            id="iban"
                            placeholder="XY00123456781234567890"
                            value="#htmlEditFormat(form.iban)#"
                            required
                        />
                    </div>
                    <button type="submit" name="validate" class="btn btn-primary">validate IBAN</button>
                </form>
                <div class="border-bottom border-info mb-3">&nbsp;</div>
                <form hx-post="/" hx-target="##conversion" hx-swap="innerHTML">
                    <div class="mb-3">
                        <label for="ktnr" class="form-label">Bank account number (Germany)</label>
                        <input
                            type="number"
                            class="form-control"
                            name="ktnr"
                            id="ktnr"
                            placeholder="12345678"
                            value="#htmlEditFormat(form.ktnr)#"
                            required
                        />
                    </div>
                    <div class="mb-3">
                        <label for="blz" class="form-label">Bank code/institude identifier</label>
                        <input
                            type="number"
                            class="form-control"
                            name="blz"
                            id="blz"
                            max="99999999"
                            placeholder="12345678"
                            value="#htmlEditFormat(form.blz)#"
                            required
                        />
                    </div>
                    <button type="submit" name="convert" class="btn btn-primary">convert to IBAN</button>
                    <div id="conversion"></div>
                </form>
            </cfoutput>
            </div>
        </main>
    </body>
</html>
