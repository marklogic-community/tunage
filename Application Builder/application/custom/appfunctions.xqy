xquery version "1.0-ml";

(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)

(:

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

:)

module namespace app = "custom-app-settings";

import module namespace asc="http://marklogic.com/appservices/component" at "/lib/standard.xqy";

import module namespace config="http://marklogic.com/appservices/config" at "/lib/config.xqy";

import module namespace search = "http://marklogic.com/appservices/search" 
    at "/MarkLogic/appservices/search/search.xqy";
import module namespace trans = "http://marklogic.com/translate" 
    at "/MarkLogic/appservices/utils/translate.xqy";
import module namespace render="http://marklogic.com/renderapi" 
    at "/MarkLogic/appservices/utils/renderapi.xqy";
import module namespace boot="http://marklogic.com/appservices/bootstrap" 
    at "/MarkLogic/appservices/appbuilder/bootstrap.xqy";

declare namespace proj ="http://marklogic.com/appservices/project";
declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare namespace label = "http://marklogic.com/xqutils/labels";
declare namespace slots = "http://marklogic.com/appservices/slots";

declare namespace t="http://marklogic.com/demo/tunes";

declare option xdmp:mapping "false";

(: -------------------------------------------:)
(: These variables can be used to override or extend values :)
(: from /lib/config.xqy :)

declare variable $FACET-LIMIT := ();
declare variable $INTRO-OPTIONS := ();
declare variable $LABELS := ();
declare variable $OPTIONS := ();
declare variable $ADDITIONAL-OPTIONS := ();
declare variable $ADDITIONAL-INTRO-OPTIONS := $ADDITIONAL-OPTIONS;
declare variable $ADDITIONAL-CSS := (
   <link xmlns='http://www.w3.org/1999/xhtml' rel='stylesheet' type='text/css' href='/custom/appcss.css'/>,
   <link xmlns='http://www.w3.org/1999/xhtml' media="handheld, only screen and (max-device-width: 480px)"  href="/custom/mobile.css" type="text/css" rel="stylesheet" />,
   (:<link xmlns='http://www.w3.org/1999/xhtml' rel="apple-touch-icon-precomposed" href="/custom/tunage.png" />,:)
   <meta xmlns='http://www.w3.org/1999/xhtml' name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=0;" />(:,:)
	 (:<meta xmlns='http://www.w3.org/1999/xhtml' name="apple-mobile-web-app-capable" content="yes" />,:)
	 (:<meta xmlns='http://www.w3.org/1999/xhtml' name="apple-mobile-web-app-status-bar-style" content="black" />:)
   );
declare variable $ADDITIONAL-JS := (
	 <script xmlns='http://www.w3.org/1999/xhtml' type="text/javascript" src="/custom/jquery.min.js">//</script>,
   <script xmlns='http://www.w3.org/1999/xhtml' src='/custom/appjs.js' type='text/javascript'>//</script>
   );





(:~
 : Toolbar containing snippet toggle and sort menu controls.
 :)
declare function app:toolbar()
as element(div)
{
<div class="toolbar">
    {
    if ($config:CONTEXT/*:view eq "detail")
    then ()
    else
     (
      xdmp:apply($config:result-toggle),
      xdmp:apply($config:sort-menu),
      <audio id="Player" controls="controls"/>
     )
    }
</div>
};




(:~
 : Emit Doctype declaration.
 :)
declare function app:doctype()
{
  '<!DOCTYPE html>'
};


(:~
 : Content for help page on application.

declare function app:help()
as element(div)
{
    <div class="static help">
        <h2>Help</h2>
        <p>You should declare app:help in appfunctions.xqy</p>
    </div>
};
:)



(:~
 : Transform a single result.
 :)
declare function app:transform-result($result as element(search:result))
{
    let $doc:= doc($result/@uri)
    return
      <div class="result" id="{$result/@uri}">
      	<div class="front">
        <h3>
        	<a class="tune" href="/custom/tune.xqy?id={fn:encode-for-uri(fn:data($doc/t:TRACK/t:Persistent_ID))}">“{fn:data($doc/t:TRACK/t:Name)}”</a> 
        	by 
        	<a href='/search?q=artist:"{xdmp:url-encode(fn:data($doc/t:TRACK/t:Artist))}"' class="artist">{fn:data($doc/t:TRACK/t:Artist)}</a> 
        	<span class="details purchased">{if($doc/t:TRACK/t:Purchased) then "$" else ""}</span>
        	<span class="details protected">{if($doc/t:TRACK/t:Protected) then "⌧" else ""}</span>
        	<span class="details kind">{fn:upper-case(fn:tokenize($doc/t:TRACK/t:Location, "\.")[last()])}</span>
        </h3>
        <div class="album">{$doc/t:TRACK/t:Album} 
        {if($doc/t:TRACK/t:Year) 
        	then fn:concat(" (",fn:data($doc/t:TRACK/t:Year),")")
        	else ()
        }</div>
        <div class="trackMeta">
        	{if($doc/t:TRACK/t:Rating) then
        	<span class="rating">
        	{
        		fn:concat(
        			fn:string-join(for $star in (1 to xs:int($doc/t:TRACK/t:Rating div 20)) return "✭ ", ""), 
        			if($doc/t:TRACK/t:Rating mod 20 gt 0) then "½" else ""
        		)
        	}
        	</span>
        	else ()
        	}
        	{if($doc/t:TRACK/t:Play_Count) then
					<span class="playCount">Played {fn:data($doc/t:TRACK/t:Play_Count)} times</span>
					else () 
					}
        </div>
        {(:if($doc/t:TRACK/t:Comments) then
        <p>{$doc/t:TRACK/t:Comments}</p>
        else () 
        :)}
       </div>
     </div>
};
