#[
Partial Derivatives
It is possible to get the partial derivatives in a very computationally efficient manner using the low-level interface, using something like (python here):

For more information, see the docs: CoolProp::AbstractState::first_partial_deriv() and CoolProp::AbstractState::second_partial_deriv()
]#
import coolprop
#import std/[strformat, times]

var HEOS = newAbstractState("HEOS", "Water")
HEOS.update(PT_INPUTS, 101325, 300)
echo HEOS.cpmass()
echo HEOS.first_partial_deriv(iHmass, iT, iP)
# vs
echo PropsSI("d(Hmass)/d(T)|P", "P", 101325.0, "T", 300, "Water")  # slower

echo HEOS.first_partial_deriv(iSmass, iT, iDmass)

# In the same way you can do second partial derivatives
# This is the second mixed partial derivative of entropy with respect to density and temperature
echo HEOS.second_partial_deriv(iSmass, iT, iDmass, iDmass, iT)

# This is the second partial derivative of entropy with respect to density at constant temperature
echo HEOS.second_partial_deriv(iSmass, iDmass, iT, iDmass, iT)

