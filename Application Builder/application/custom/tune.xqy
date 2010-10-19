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

xquery version "1.0-ml";

declare namespace t="http://marklogic.com/demo/tunes";

let $id := xdmp:url-decode(xdmp:get-request-field("id"))
let $file := fn:substring-after(
	xdmp:url-decode(/t:TRACK[t:Persistent_ID eq $id]/t:Location),
	"file://localhost"
)
let $ext := fn:lower-case(fn:tokenize($file, "\.")[position() = last()])
let $mimes := map:map()
let $_ := (
	map:put($mimes, "mp3", "audio/mpeg"), 
	map:put($mimes, "m4a", "audio/mp4a-latm"),
	map:put($mimes, "m4b", "audio/mp4a-latm"),
	map:put($mimes, "m4p", "audio/mp4a-latm"),
	map:put($mimes, "wav", "audio/x-wav")
)
return (
	xdmp:set-response-content-type(map:get($mimes, $ext)),
	xdmp:document-get($file),
	xdmp:log(fn:concat("Sent ", $file))
)