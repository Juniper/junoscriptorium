/*
 * dbg.js -- debug functions for js
 */

var xhtmlns = "http://www.w3.org/1999/xhtml";
var dbg = new Object();

dbg.log = null;

dbg.pr = function (data) {
    if (!dbg.log)
	dbg.log = document.getElementById("debug-log");

    if (dbg.log) {
	dbg.log.innerHTML += "\n" + data;
    }
}

dbg.dump = function (name, data) {
    dbg.pr(name + ":: ");
    for (var key in data) {
	try {
	    dbg.pr("-- '" + key + "' --> '"
		   + ((data[key] instanceof Function)
		      ? "[Function]" : data[key])
		   + "'");
	} catch (error) {
	    /* nothing */
	}
    }
}

/*
 * Initialize the debugging log div
 */
dbg.open = function () {
    dbg.log = document.getElementById("debug-log");
    if (dbg.log)
	return;

    /*
     * If we didn't find one, go make our own.
     * XXX This should to the style bits also.
     */
    dbg.log = document.createElementNS(xhtmlns, "div");
    dbg.log.setAttributeNS("", "class", "debug");

    var div2 = document.createElementNS(xhtmlns, "div");
    div2.setAttributeNS("", "class", "debug-container");
    div2.innerHTML = "<h3>Debug Log</h3>\n";
    div2.appendChild(dbg.log);

    document.documentElement.appendChild(div2);
}

dbg.close = function () {
    dbg.log = null;
}
