/*
 * $Id: top.js,v 1.2 2007/10/17 20:28:00 phil Exp $
 */

var xhtmlns = "http://www.w3.org/1999/xhtml";

var directory = new Object();

directory.directory = function (parent, path, name, id, recurse) {
    this.parent = parent;
    this.path = path;
    this.name = name;
    this.url = "../" + path;
    this.id = id;
    this.recurse = recurse;
}

directory.directory.prototype = {
    load : function () {
	dbg.pr("loading directory " + this.path);
	this.loader = new load.loader(this, this.url);
    },

    click : function () {
	var div = document.getElementById("contents-" + this.id);
	
	if (div.firstChild) {
	    div.innerHTML = null;
	} else {
	    this.load();
	}
    },

    on_load : function (loader, request) {
	dbg.pr("directory loaded: " + this.name);

	var lines = request.responseText.split(/[\r\n]/m);
	var div = document.getElementById("contents-" + this.id);

	for (var i = 0; i < lines.length; i++) {
	    dbg.pr("result: " + lines[i]);
	    var info = lines[i].split(/201: ([^ ]+) ([0-9]+) ([^ ]+) ([^ ]+)/);
	    if (!info[1])
		continue;
	    if (info[1] == "CVS")
		continue;
	    dbg.pr(info[4] + ":: " + info[1]);

	    var target = this.path + "/" + info[1];

	    if (info[4] == "DIRECTORY") {
		/* Skip the 'Authors' directory */
		if (info[1] == "Authors")
		    continue;

		var results = "";
		results += '<div id="' + target + '" class="directory"'
		    + ' xmlns="http://www.w3.org/1999/xhtml">\n';
		results += '<a href="#" id="link-' + target + '">\n';
		results += '<div id="title-' + target + '" class="title">' + info[1] + '</div>\n';
		results += '</a>\n';
		results += '<div id="help-' + target + '" class="help"/>\n';
		results += '<div id="contents-' + target +
		    '" class="contents"/>\n';
		results += '</div>\n';
		div.innerHTML += results;

		/* First make a directory object for this directory */
		var newp = new directory.directory(this, target, info[1],
						       target, false);

		this.find_info(newp, target, info[1]);

		document.getElementById("link-" + target).onclick =
		    function() {
			var dir = newp;
			dbg.pr("expanding " + target);
			newp.click();
		    };

	    } else if (info[4] == "FILE") {
		if (info[1] == this.name + ".xml") {
		    dbg.pr("found info for " + info[1]);

		    document.location.href = this.url + "/" + info[1];
		}
	    }
	}

	/*
	 * This needs to calculate the value based on wrapping lines
	 */
	div.style.height = div.scrollHeight + "px";
    },

    get_info : function (target, name) {
	
    },

    find_info : function (dirp, target, name) {
	

	/* Then try to load the info file */
	var infop = new directory.file(dirp, target + "/" + "Info.xml",
				       "Info.xml");
    },
}

directory.file = function (parent, path, file) {
    this.parent = parent;
    this.path = path;
    this.file = file;
    this.url = "../" + path;

    dbg.pr("loading file " + this.path);
    this.loader = new load.loader(this, this.url);
}

directory.file.prototype = {
    on_load : function (loader, request) {
	dbg.pr("file loaded: " + this.path);

	/*
	 * We record the doc with our parent, so it can lookup
	 * subdirectories.
	 */
	var doc = request.responseXML;
	this.parent.info = doc;

	dbg.pr("div: path " + this.parent.path);
	var div = doc.getElementById(this.parent.path);
	dbg.pr("div: name " + div.nodeName);

	var desc = div.getElementsByTagName("description")[0];
	dbg.pr("div: found " + desc.firstChild.data);

	var title = document.getElementById("help-" + this.parent.path);
	title.innerHTML += loader.escape(desc.firstChild.data);
    },

    on_error : function (loader) {
	dbg.pr("file failed: " + this.path);
    }
}

var top_dir = new directory.directory(null, "library",
				      "library", "top", false);
top_dir.load();
