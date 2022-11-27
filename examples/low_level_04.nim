#[
Things only in the low-level interface
You might reasonably ask at this point why we would want to use the low-level interface as opposed to the “simple” high-level interface. In the first example, if you wanted to calculate all these output parameters using the high-level interface, it would require several calls to the pressure-quality flash routine, which is extremely slow as it requires a complex iteration to find the phases that are in equilibrium. Furthermore, there is a lot of functionality that is only accessible through the low-level interface. Here are a few examples of things that can be done in the low-level interface that cannot be done in the high-level interface:















]#
import coolprop
import std/[strformat, times]

var HEOS = newAbstractState("HEOS", "Water")
let time = cpuTime()

# Do a flash call that is a very low density state point, definitely vapor
HEOS.update(DmolarT_INPUTS, 1e-6, 300)
echo "Time taken: ", cpuTime() - time


# Specify the phase - for some inputs (especially density-temperature), this will result in a
# more direct evaluation of the equation of state without checking the saturation boundary
HEOS.specify_phase(iphase_gas)

# We try it again - a bit faster
HEOS.update(DmolarT_INPUTS, 1e-6, 300)

# Reset the specification of phase
HEOS.specify_phase(iphase_not_imposed)


# A mixture of methane and ethane
HEOS = newAbstractState("HEOS", "Methane&Ethane")


# Set the mole fractions of the mixture
HEOS.setMoleFractions(@[0.2,0.8])

# Do the dewpoint calculation
HEOS.update(PQ_INPUTS, 101325, 1)

# Liquid phase molar density
echo HEOS.saturated_liquid_keyed_output(iDmolar)

# Vapor phase molar density
echo HEOS.saturated_vapor_keyed_output(iDmolar)
#Out[19]: 69.503104630333


# Liquid phase mole fractions
echo HEOS.moleFractionsLiquid()

# Vapor phase mole fractions -
# Should be the bulk composition back since we are doing a dewpoint calculation
echo HEOS.moleFractionsVapor()
#Out[21]: [0.19999999999999996, 0.7999999999999999]
#[
echo HEOS.p  # 0.002494311404279685
for k in @[iP, iHmass, iHmolar]:
  echo HEOS.keyed_output(k)
]#
#[
0.002494311404279685
2551431.068564012
45964.71448370705
]#