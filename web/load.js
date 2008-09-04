/*
 * $Id: load.js,v 1.1 2007/10/17 18:34:09 phil Exp $
 */

var load = new Object();

load.base = "file:///p/photo/web"; /* Should be dynamic */

load.url = function (name) {
    return load.base + "/" + name;
}

load.READY_STATE_UNINITIALIZED = 0;
load.READY_STATE_LOADING = 1;
load.READY_STATE_LOADED = 2;
load.READY_STATE_INTERACTIVE = 3;
load.READY_STATE_COMPLETE = 4;

load.loader = function (owner, url, on_load, on_error) {
    this.owner = owner;
    this.url = url;
    this.on_load = on_load;
    this.on_error = on_error;

    this.start_loading(url);
}

load.loader.prototype = {
    start_loading : function (url) {
	dbg.pr("start_loading: " + url);
	if (window.XMLHttpRequest) {
	    this.request = new window.XMLHttpRequest();
	} else if (window.ActiveXObject) {
	    this.request = new ActiveXObject("Microsoft.XMLHTTP");
	}

	if (this.request) {
	    try {
		var local_this = this;
		this.request.onreadystatechange = function () {
		    local_this.state_change.call(local_this);
		}

		this.request.open("GET", url, true);
		this.request.send(null);

	    } catch (err) {
		this.error();
	    }
	}
    },

    state_change : function() {
	var request = this.request;
	var ready = request.readyState;
	dbg.pr("state_change: " + ready);

	if (ready == load.READY_STATE_COMPLETE) {
	    var status = request.status;
	    if (status == 200 || status == 0) {
		dbg.pr("finished loading: " + this.url
		      + " ;  content (" + request.responseText.length + ") : "
		      + request.responseText.substring(0, 20));

		if (this.on_load) {
		    this.on_load.call(this.owner, this, this.request);

		} else if (this.owner.on_load) {
		    this.owner.on_load.call(this.owner, this, this.request);
		}

	    } else {
		this.error();
	    }
	}
    },

    error : function() {
	if (this.on_error) {
	    this.on_error.call(this.owner, this);

	} else if (this.owner.on_error) {
	    this.owner.on_error.call(this.owner, this);

	} else {
	    alert("error fetching data"
		  + "\nURL = " + this.url 
		  + "\nreadyState = " + this.request.readyState 
		  + "\nstatus = " + this.request.status
		  + "\nheaders = " + this.request.getAllResponseHeaders());
	}
    },

    escape : function (str) {
	return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/ /g, "&#160;");
    },
}

load.item = function (owner, name, action) {
    this.name = name;
    this.url = load.url(name);
    this.action = action;
    this.owner = owner;

    this.loader = new load.loader(this, this.url);
}

load.item.prototype = {
    on_load : function (loader, request) {
	dbg.pr("load.item.on_load: [" + this.name + "]: "
	       + request.responseText.substring(0, 10));

	var data = eval( "( { " + request.responseText + " } )");

	var obj;
	var action = this.action ? this.action : "open";

	for (var key in data) {
	    if (key == "album") {
		obj = new album.model(this.name, this.url, data[key]);

	    } else if (key == "photo") {
		obj = new photo.model(this.name, this.url, data[key]);

	    } else if (key == "stack") {
		obj = new stack.model(this.name, this.url, data[key]);
	    }

	    /*
	     * Let the object initialize itself
	     */
	    if (obj[action])
		obj[action].call(obj);

	    /*
	     * Inform the owner that the object's complete
	     */
	    if (this.owner && this.owner.child_birth)
		this.owner.child_birth(obj, loader);
	}
    },
}

load.populate = function (object, data) {
    for (var key in data) {
	if (!object[key])
	    object[key] = data[key];
    }
}
