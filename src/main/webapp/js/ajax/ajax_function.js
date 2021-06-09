/*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************/
/*
* Returns an new XMLHttpRequest object, or false if the browser
* doesn't support it
*/
function newXMLHttpRequest() {

	var xmlreq = false;

	// Create XMLHttpRequest object in non-Microsoft browsers
	if (window.XMLHttpRequest) {
		xmlreq = new XMLHttpRequest();
	} 
	else if (window.ActiveXObject) {
		try {
		// Try to create XMLHttpRequest in later versions
		// of Internet Explorer
		xmlreq = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
		// Failed to create required ActiveXObject
			try {
			// Try version supported by older versions
			// of Internet Explorer
			xmlreq = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
			// Unable to create an XMLHttpRequest by any means
			xmlreq = false;
			}
		}
	}
	return xmlreq;
}

/*
* Returns a function that waits for the specified XMLHttpRequest
* to complete, then passes it XML response to the given handler function.
* req - The XMLHttpRequest whose state is changing
* responseXmlHandler - Function to pass the XML response to
*/
function getReadyStateHandler(req, responseXmlHandler) {
	// Return an anonymous function that listens to the XMLHttpRequest instance
	
	return function () {
		// If the request's status is "complete"
		//alert('here is getReadyStateHandler --->' + req.readyState);
		if (req.readyState == 4) {
		// Check that we received a successful response from the server
			if (req.status == 200) {
				// Pass the XML payload of the response to the handler function.
				//alert(req.responseText);
				responseXmlHandler(req.responseXML);
			} 
			else {
				// An HTTP problem has occurred
				//alert("HTTP error "+req.status+": "+req.statusText);
			}
		}
	}
}


// If you plan on doing anything outside of North America, then you'd better encode the things you pass back and forth
// the escape() method in Javascript is deprecated -- should use encodeURIComponent if available
function encode( uri ) {
    if (encodeURIComponent) {
        return encodeURIComponent(uri);
    }

    if (escape) {
        return escape(uri);
    }
}

function decode( uri ) {
    uri = uri.replace(/\+/g, ' ');
    
    if (decodeURIComponent) {
        return decodeURIComponent(uri);
    }

    if (unescape) {
        return unescape(uri);
    }

    return uri;
}


// build a string containing every field on the passed form
// skip disabled controls
function getFormValues( form ) {
    //var form = $(form);
    var field = "";
    var value = "";
    var valueString = "";
    var replaceID = "";
    var parentNode = form.parentNode;

    for (var i = 0; i < form.elements.length; i++) {
        var field = form.elements[i];

        if (!field.disabled) {
            filedName = encode(field.name);
            if (field.type == 'select') {
                if (field.selectedIndex > -1) {
                    value = field.options[field.selectedIndex].value;
                }
				else{
					value = '';
				}
            }
			else if(field.type == 'checkbox') {
                if (field.checked) {
                    value = 'on';
                }
				else{
					value = 'off';
				}
			}
			else {
                value = field.value;
            }

            valueString += ((i) ? '&' : '') + field.name + '=' + encode(value);
        }
    }

    return valueString
}