#[

julia> cpmass = CoolProp.get_param_index("C")
34

julia> handle = CoolProp.AbstractState_factory("HEOS", "Water")
0

julia> CoolProp.AbstractState_update(handle,PT_INPUTS,101325, 300)

julia> CoolProp.AbstractState_keyed_output(handle,cpmass)
4180.635776569655

julia> CoolProp.AbstractState_free(handle)

julia> handle = CoolProp.AbstractState_factory("HEOS", "Water&Ethanol")
1

julia> PQ_INPUTS = CoolProp.get_input_pair_index("PQ_INPUTS")
2

julia> T = CoolProp.get_param_index("T")
18

julia> CoolProp.AbstractState_set_fractions(handle, [0.4, 0.6])

julia> CoolProp.AbstractState_update(handle,PQ_INPUTS,101325, 0)

julia> CoolProp.AbstractState_keyed_output(handle,T)
352.3522142890429

julia> CoolProp.AbstractState_free(handle)
]#
import coolprop
import std/[strformat, times]


# This one doesn't see the change in reference state
#var as1 = newAbstractState("HEOS","n-Propane")

#echo getInputPairIndex( "PT_INPUTS" )
echo get_input_pair_index("PT_INPUTS")

var cpmass = get_param_index("C")

# LOW LEVEL API
# TODO: the following is not ok
const 
  buffer_size = 1000
  length      = 100000
var 
  ierr:clong = 0
  herr = newString(buffer_size)
  #herr:array[char,buffer_size]
var handle = AbstractState_factory(
       "BICUBIC&HEOS".cstring, 
       "Water".cstring, 
       ierr.addr, 
       herr.cstring, 
       buffer_size.clong)
# var errCode:ptr clong
# var messageBuffer: cstring
# var bufferLength: clong
# var handle = AbstractState_factory("HEOS", "Water", errCode, messageBuffer, bufferLength)

#[
proc AbstractState_factory*(backend: cstring; fluids: cstring; errcode: ptr clong;
                           message_buffer: cstring; buffer_length: clong): clong {.
    importcpp: "AbstractState_factory(@)".}

]#