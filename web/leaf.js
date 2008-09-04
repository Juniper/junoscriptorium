/*
 * $Id: leaf.js,v 1.1 2007/10/17 18:34:09 phil Exp $
 * 
 * This script adds the other scripts to the current document
 */

var xhtmlns = "http://www.w3.org/1999/xhtml";
var root = document.documentElement;
var base = "../../../../../web/";

add_script("dbg.js");
add_script("load.js");
add_script("main-leaf.js");
add_stylesheet("jstm.css");

function add_script (filename)
{
    var scr = document.createElementNS(xhtmlns, "script");
    scr.setAttributeNS("", "type", "text/javascript");
    scr.setAttributeNS("", "src", base + filename);
    root.appendChild(scr);
}

function add_stylesheet (filename)
{
    var value ='type="text/css" href="' + base + filename + '"';
    var stl = document.createProcessingInstruction("xml-stylesheet", value);
    document.insertBefore(stl, document.firstChild);
}
