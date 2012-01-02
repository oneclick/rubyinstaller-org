/**
	script.js
	==============
	
	Nobleskine for Lavena
	---------------------
	
*/
	
var ruby = function(){
	
	var bundle = {
		jquery_lib : 'https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js'
	},  settings = {
		isCufonActive : true
	};
	
	// Call Cufon
	cufon();
	
	// Call jQuery from Google CDN only if needed
	if (typeof jQuery != 'undefined') {
		init();
	} else {
		$script([bundle.jquery_lib], 'bundle');
		$script.ready('bundle', function() {
			init();
		});
	}
	
	// Init()
	function init() {
		notes();
	}
	
	// Cufon()
	function cufon() {
		
		var els = getElementsByClass('fR');
		
		if (settings.isCufonActive) {
			Cufon.replace(els, {hover:true});
		}
		// Fallback cos by default, we turn off the visibility for elements using Cufon
		else {
			for (var i = els.length-1; i >= 0; i--) {
				els[i].style.visibility = 'visible';
			}
		}	
	}
	
	// Notes()
	function notes() {
		$('.trigger').click(function(e) {
			e.preventDefault();
			var trigger = $(this),
				release = $(this).parents('.release'),
				pre = release.find('.notes'),
				label = pre.is(':visible') ? 'Show notes' : 'Hide notes';
			pre.slideToggle(200);
			trigger.text(label);
		});
	}
	
}();

/* Handy functions */
/* getElementsByClass by Dustin Diaz */
function getElementsByClass(g,e,a){var d=new Array();if(e==null){e=document}if(a==null){a="*"}var c=e.getElementsByTagName(a);var b=c.length;var f=new RegExp("(^|\\\\s)"+g+"(\\\\s|$)");for(i=0,j=0;i<b;i++){if(f.test(c[i].className)){d[j]=c[i];j++}}return d};