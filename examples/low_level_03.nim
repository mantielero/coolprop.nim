#[
Keyed output versus accessor functions
The simple output functions like AbstractState::rhomolar() that are
mapped to keys in CoolProp::parameters can be either obtained using
the accessor function or by calling AbstractState::keyed_output(). 
The advantage of the keyed_output function is that you could in
principle iterate over several keys, rather than having to hard-code
calls to several accessor functions. For instance:

In [4]: import CoolProp

In [5]: HEOS = CoolProp.AbstractState("HEOS", "Water")

In [6]: HEOS.update(CoolProp.DmolarT_INPUTS, 1e-6, 300)

In [7]: HEOS.p()
Out[7]: 0.002494311404279685

In [8]: [HEOS.keyed_output(k) for k in [CoolProp.iP, CoolProp.iHmass, CoolProp.iHmolar]]
Out[8]: [0.002494311404279685, 2551431.0685640117, 45964.71448370705]
]#
import coolprop
import std/strformat

var HEOS = factory("HEOS", "Water")
HEOS.update(DmolarT_INPUTS, 1e-6, 300)
echo HEOS.p  # 0.002494311404279685
for k in @[iP, iHmass, iHmolar]:
  echo HEOS.keyed_output(k)

#[
0.002494311404279685
2551431.068564012
45964.71448370705
]#