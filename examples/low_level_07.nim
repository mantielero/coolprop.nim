#[
Reference States
To begin with, you should read the high-level docs about the reference state. Those docs are also applicable to the low-level interface.

Warning

As with the high-level interface, calling set_reference_stateS (or set_reference_state in python) should be called right at the beginning of your code, and not changed again later on.

Importantly, once an AbstractState-derived instance has been generated from the factory function, it DOES NOT pick up the change in the reference state. This is intentional, but you should watch out for this behavior.

Here is an example showing how to change the reference state and demonstrating the potential issues

]#
import coolprop
import std/[strformat, times]


# This one doesn't see the change in reference state
var as1 = newAbstractState("HEOS","n-Propane")


as1.update( QT_INPUTS, 0, 233.15)

# TODO: I don't see the purpose (the API doesn't match)
discard set_reference_stateS("n-Propane","ASHRAE")



# This one gets the update in the reference state
var as2 = newAbstractState("HEOS","n-Propane")

as2.update(QT_INPUTS, 0, 233.15)


# Note how the AS1 has its default value (change in reference state is not seen)
# and AS2 does see the new reference state
echo &"{as1.hmass}, {as2.hmass}"


# Back to the original value
discard set_reference_stateS("n-Propane","DEF")