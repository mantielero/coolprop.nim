#[
The two-phase derivatives of Thorade [2] are implemented in the CoolProp::AbstractState::first_two_phase_deriv() function, and derivatives along the saturation curve in the functions CoolProp::AbstractState::first_saturation_deriv() and CoolProp::AbstractState::second_saturation_deriv(). Here are some examples of using these functions:











# The d(Dmass)/d(Hmass)|P two-phase derivative using splines
In [44]: HEOS.first_two_phase_deriv_splined(CoolProp.iDmass, CoolProp.iHmass, CoolProp.iP, 0.3)
Out[44]: -0.0018169665165181214
]#
import coolprop
#import std/[strformat, times]

var HEOS = newAbstractState("HEOS", "Water")
HEOS.update(QT_INPUTS, 0, 300)

# First saturation derivative calculated analytically
echo HEOS.first_saturation_deriv(iP, iT)

# First saturation derivative calculated numerically
HEOS.update(QT_INPUTS, 0, 300 + 0.001)
var p2 = HEOS.p()

HEOS.update(QT_INPUTS, 0, 300 - 0.001)
var p1 = HEOS.p()

echo (p2-p1)/(2.0*0.001)


# The d(Dmass)/d(Hmass)|P two-phase derivative
HEOS.update(QT_INPUTS, 0.1, 300)
echo HEOS.first_two_phase_deriv(iDmass, iHmass, iP)
    