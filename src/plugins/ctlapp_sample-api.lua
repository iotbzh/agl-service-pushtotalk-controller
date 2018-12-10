--[[
  Copyright (C) 2018 "IoT.bzh"
  Author Fulup Ar Foll <fulup@iot.bzh>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.


  NOTE: strict mode: every global variables should be prefixed by '_'

  Test commands:
    afb-client-demo 'localhost:1111/api?token=XXX&uuid=magic' ctlapp_sample display
--]]


function _run_onload_(source)
    AFB:notice(source, "--InLua-- ENTER _run_onload_ CTLapp service sample\n")

    local err, response =AFB:servsync (source, "homescreen", "subscribe", { event = "on_screen_message"})
    if (err) then
       AFB:error(source, "--inlua-- Cannot subscribe to on_screen_message")
       return 1
    end

    return 0
end

function _evt_catcher_(source, action, event)
    AFB:notice(source, "RECV EVENT=%s", Dump_Table(event))
end

function _display_application_(source, args, query)
    if not query or not query.application or query.application == "" then
        AFB:fail(source, "ERROR: invalid parameters")
        return 1
    end

    AFB:notice(source, "--InLua-- ENTER _display_application_ query=%s, args=%s",Dump_Table(query),Dump_Table(args))
    AFB:notice(source, "--InLua-- ENTER _display_application_ query=%s",query.application)


    if query.version then
        query.version = "0.1"
    end

    local err, response =AFB:servsync (source, "afm-main", "once", query.application.."@0.1" )
     if (err) then
        AFB:fail(source, "ERROR: AfmMain fail to start application %s@%s", query.application, query.version)
        return 1
    end

    local err, response =AFB:servsync (source, "homescreen", "tap_shortcut", { application_name = query.application})
    if (err) then
       AFB:fail(source, "ERROR: Homescreen fail to display application %s@", query.application)
       return 1
   end

    AFB:success(source, response)
    return 0
end
