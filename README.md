# Symplectic-Publications-to-HTML

This XSLT script takes input from the Syplectic Elements API and converts it to HTML.

You will need to retrieve the API response from the Symplectic Publications API. The API responds with an extended ATOM document. Check the configuration of your API for the correct URL. This script uses 
<symplectic-api-endpoint>/publications-api/users/username-/relationships?types=8,9&detail=full&per-page=1000

Supports:
 1. [Symplectic Elements][1] API version 3.7 at the moment. It will soon be tested with version 4.14.
 2. [XSLT v1.0][2]
 3. [xsltproc][3] XSLT processor

Tested with xsltproc and Saxon-HE 9.5.1.5.

[1]: http://symplectic.co.uk/products/elements/
[2]: http://www.w3.org/TR/xslt
[3]: http://en.wikipedia.org/wiki/Libxslt
