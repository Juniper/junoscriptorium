/*
 * $Id: main-leaf.js,v 1.1 2007/10/17 18:34:09 phil Exp $
 *
 * This is the main code thread that gets us started.
 * - Make an XSLT processor
 * - Make a transform (target) document
 * - Load the XSLT document
 * - Run the transformation
 * - Nuke the original document
 * - Stuff the output of the transformation into the document
 * - Look at the load-files section to see what files to load
 * - Load them
 * - Celebrate!!
 */

var xhtmlns = "http://www.w3.org/1999/xhtml";

// Create an XSLT processor instance
var processor = new XSLTProcessor();

// Create an empty XML document for the XSLT transform
var transform = document.implementation.createDocument("", "", null);
transform.onload = loadTransform;
transform.load("../../../../../web/jstm.xslt");

// Triggered once the XSLT document is loaded
function loadTransform()
{
    // Attach the transform to the processor
    processor.importStylesheet(transform);
    source = document.implementation.createDocument("", "", null);
    source.load(document.baseURI);
    source.onload = runTransform;
}

//Triggered once the source document is loaded
function runTransform()
{
    // Run the transform, creating a fragment output subtree that can
    // be inserted back into the main page document object (given in
    // the second argument) If you want to create a full output
    // document rather than a subtree for insertion into another
    // document, use the transformToDocument method rather than
    // transformToFragment.
    processor.setParameter(null, "filename", document.baseURI);
    var doc = processor.transformToDocument(source, document);

    var root = document.documentElement;
    if (true) {
	var childNodes = root.childNodes;
	// dbg.pr("removing count: " + childNodes.length);
	while (childNodes.length > 0) {
	    // dbg.pr("removing: " + childNodes[0].nodeName);
	    root.removeChild(childNodes[0]);
	}
    }

    var frag = doc.documentElement;
    childNodes = frag.childNodes;
    var count = childNodes.length;
    for (var i = 0; i < count; i++) {
	// dbg.pr("appending: " + childNodes[0].nodeName);
	root.appendChild(childNodes[0]);
    }

    dbg.close();
    dbg.pr("beginning debug output");

    var files = getLoadFiles(document)

    for (var i = 0; i < files.length; i++) {
	var fn = files[i].getAttribute("filename");
	var id = files[i].getAttribute("target");

	dbg.pr("load-file: " + fn + " -> " + id);
	var obj = new loadFile.loadFile(fn, id);
    }

    var title = document.getElementById("title");
    if (title && title.childNodes) {
	document.title = "JUNOScriptorium: " + title.childNodes[0].nodeValue;
    }
}

function getLoadFiles(node)
{
    dbg.pr("start");
    var answer = new Array();
    var els = node.getElementById("load-files");
    dbg.pr("els " + els);
    els = els.childNodes;
    var elsLen = els.length;
    dbg.pr("len " + elsLen);
    for (var i = 0; i < elsLen; i++) {
	dbg.pr("found " + els[i].className + " " + els[i].nodeName);
	if (els[i].nodeName == "div")
	    answer.push(els[i]);
    }

    dbg.pr("glen " + answer.length);
    return answer;
}

var loadFile = new Object();

loadFile.loadFile = function (name, id) {
    this.name = name;
    this.id = id;
    this.url = name;

    dbg.pr("loading ... " + this.url);
    this.item = new load.loader(this, this.url);
}

loadFile.loadFile.prototype = {
    on_load : function (loader, request) {
	dbg.pr("loadFile: loaded");

	var div = document.getElementById(this.id);
	div.innerHTML = loader.escape(request.responseText);

	/*
         * Trim the height of file windows to 80% of the screen.
         * Not sure I like this, but long config files are boring
         */
	if (window.innerHeight * 0.80 > div.scrollHeight) {
	    div.style.height = div.scrollHeight + "px"; 
	} else {
	    div.style.height = window.innerHeight * 0.80 + "px";
	}
    },

    non_error : function (loader) {
	dbg.pr("loadFile: error");
    },
}
