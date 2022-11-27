import coolprop
import std/strformat

var water = factory("HEOS", "Water")
water.update(PQ_INPUTS, 101325, 0) # SI units

echo &"T: {water.t:.3f} K"
echo &"rho: {water.rhomass:.3f} kg/m^3"
echo &"rho: {water.rhomolar:.3f} mol/m^3"
echo &"h: {water.hmass:.3f} J/kg"
echo &"h: {water.hmolar:.3f} J/mol"
echo &"s: {water.smass:.3f} J/kg/K"
echo &"s: {water.smolar:.3f} J/mol/K"