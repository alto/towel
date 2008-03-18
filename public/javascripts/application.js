// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function linkMe(which) {
    var link = which.getElementsByTagName("a")[which.getElementsByTagName("a").length-1];
    if(!link.onclick) location.href=link.href;
    else link.onclick();
}

function roundCorners() {
	settingsAll = {
		tl: { radius: 7 },
		tr: { radius: 7 },
		bl: { radius: 7 },
		br: { radius: 7 },
		antiAlias: true,
		autoPad: true,
		validTags: ["ul", "div"]
	}
	settingsLeft = {
		tl: { radius: 7 },
		tr: false,
		bl: { radius: 7 },
		br: false,
		antiAlias: true,
		autoPad: true,
		validTags: ["ul", "div"]
	}
	settingsRight = {
		tl: false,
		tr: { radius: 7 },
		bl: false,
		br: { radius: 7 },
		antiAlias: true,
		autoPad: true,
		validTags: ["ul", "div"]
	}
	var myBoxObject = new curvyCorners(settingsAll, "roundedFull");
	myBoxObject.applyCornersToAll();
	var myBoxObject2 = new curvyCorners(settingsAll, "roundedHalf");
	myBoxObject2.applyCornersToAll();
	var myBoxObject3 = new curvyCorners(settingsAll, "comments");
	myBoxObject3.applyCornersToAll();		
	var myBoxObject4 = new curvyCorners(settingsLeft, "detLeft");
	myBoxObject4.applyCornersToAll();
	var myBoxObject5 = new curvyCorners(settingsRight, "detRight");
	myBoxObject5.applyCornersToAll();
	var myBoxObject6 = new curvyCorners(settingsAll, "simEvents");
	myBoxObject6.applyCornersToAll();
}

function changeHeigth(a, b) {
	if (document.getElementById(a).offsetHeight > document.getElementById(b).offsetHeight) {
		document.getElementById(b).style.height = document.getElementById(a).offsetHeight +"px";
	}
	else if (document.getElementById(b).offsetHeight > document.getElementById(a).offsetHeight) {
		document.getElementById(a).style.height = document.getElementById(b).offsetHeight +"px";	
	}
	return false;
}

function fullLink(which) {
    var theLink = which.getElementsByTagName("a")[which.getElementsByTagName("a").length-2];
    if(!theLink.onclick) location.href=theLink.href;
    else theLink.onclick();
}