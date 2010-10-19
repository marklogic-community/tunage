/* 
	Copyright 2008-2010 Mark Logic Corporation
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	    http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	
	@author Justin Makeig <jmakeig@marklogic.com>

*/

var ML = ML || {};
ML.Tunage = (function() {
	// Private singleton reference to the <audio> element
	var player = null;
	var currentTrack = null;
	
	// Local shortcuts to statics
	var D = YAHOO.util.Dom;
	var E = YAHOO.util.Event;
	
	// Event handler to play an individual song
	var handleTuneClick = function(evt) {
		var a = evt.target;
		console.log("Clicked track " + a.href);
		player.src = a.href;
		console.log("Playing " + player.src);
		D.getElementsByClassName("flip").forEach(function(t){
			D.removeClass(t, "flip");
		});
		player.play();
		currentTrack = a.parentNode.parentNode.parentNode; // div.result
		D.addClass(currentTrack, "flip");
		E.stopEvent(evt);
	}
	/*
	var handleAnchorClick = function(evt) {
		var a = evt.target;
		window.location = a.href;
		E.stopEvent(evt);
	}
	*/
	
	// Wire up the tune anchor elements (a.tune).
	E.onDOMReady(function() {
		// if((navigator.userAgent.indexOf('iPhone') != -1) || (navigator.userAgent.userAgent.indexOf('iPod') != -1)) return;
		player = document.getElementById("Player");
		var tunes = D.getElementsByClassName("tune");
		for(var i = 0, len = tunes.length; i < len; i++) {
			var t = tunes[i];
			E.addListener(t, "click", handleTuneClick);
		}
		
		/*
		var anchors = D.getElementsByTagName("a");
		for(var i = 0; i < anchors.length; i++) {
			E.addListener(anchors[i], "click", handleAnchorClick);
		}
		*/
	});
	
	// TODO: Migrate this to YUI
	$(document).ready(function(){
		// For each front, copy as a sibling and flag it with a back class
		$('.result .front').each(function() {
			var cloned = $(this).clone();
			cloned.removeClass('front').addClass('back');
			$(this).after(cloned);
		});	
	});
	
		
	return {
		getPlayer: function() { return player;},
		getCurrentTrack: function() { return currentTrack; }, 
		play: function(track) { /* TODO */ },
		pause: function() { /* TODO */ },
		next: function() { /* TODO */ },
		previous: function() { /* TODO */ }
	}
})();

