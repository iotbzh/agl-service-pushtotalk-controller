--[[
  Copyright (C) 2018 "IoT.bzh"
  Author Johann CAHIER <johann.cahier@iot.bzh>

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
    afb-client-demo 'localhost:2345/api?token=' pushtotalk_controller fake_direction {angle:45}
--]]


function _run_onload_(source)
    AFB:notice(source, "--InLua-- ENTER _run_onload_ CTLapp service sample\n")

    local err, response =AFB:servsync (source, "linux-joystick", "subscribe", { device = "/dev/input/js0", input_type="button", input_id='0'})
    if (err) then
       AFB:error(source, "--inlua-- Cannot subscribe to driver's button event: ", response)
       return 1
    end
    local err, response =AFB:servsync (source, "linux-joystick", "subscribe", { device = "/dev/input/js0", input_type="button", input_id="11"})
    if (err) then
       AFB:error(source, "--inlua-- Cannot subscribe to passenger's button event: ", response)
       return 1
    end

    return 0
end


function do_call_verbs(source, state, direction_args, alexa_args)
    if (state == "pressed") then
        local err, response =AFB:servsync (source, "agl_service_pushtotalk_controller", "fake_direction", direction_args)
        if (err) then
            AFB:fail(source, "ERROR: while calling SET DIRECTION verb")
            return 1
        end
        local err, response =AFB:servsync (source, "agl_service_pushtotalk_controller", "fake_alexa_listen", alexa_args)
        if (err) then
            AFB:fail(source, "ERROR: while calling ALEXA LISTEN verb")
            return 1
        end
    end
end

function driver_button_event(source, action, event)
    AFB:debug(source, "--InLua-- DRIVER RECV EVENT=%s (%s)", Dump_Table(event), action)
    do_call_verbs(source, event["state"], { angle = 45 }, nil)
end

function passenger_button_event(source, action, event)
    AFB:debug(source, "--InLua-- PASSENGER RECV EVENT=%s (%s)", Dump_Table(event), action)
    do_call_verbs(source, event["state"], { angle = 135 }, nil)
end


function fake_direction(source, args, query)
    if not query then
        AFB:fail(source, "--InLua-- ERROR: invalid parameters")
        return 1
    end

    AFB:notice(source, "--InLua--  fake_direction query=%s, args=%s",Dump_Table(query),Dump_Table(args))
    AFB:success(source, response)
    return 0
end

function fake_alexa_listen(source, args, query)
    if not query then
        AFB:fail(source, "--InLua-- ERROR: invalid parameters")
        return 1
    end

    AFB:notice(source, "--InLua--  fake_alexa_listen query=%s, args=%s",Dump_Table(query),Dump_Table(args))
    AFB:success(source, response)
    return 0
end


--[[
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
   end]]
