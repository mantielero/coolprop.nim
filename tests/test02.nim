# nim cpp -r test02
import coolprop
import std/unittest

const
  eps = 1.0e-2 ## Epsilon used for float comparisons.

proc `=~` *(x, y: float): bool =
  result = abs(x - y) < eps

suite "Testing the low level interface":
  #echo "suite setup: run once before the tests"
  setup:
    var water = factory("HEOS", "Water")
    water.update(PQ_INPUTS, 101325, 0) # SI units

  test "checking values":
    # give up and stop if this fails
    assert water.t        =~ 373.124
    assert water.rhomass  =~ 958.367
    assert water.rhomolar =~ 53197.515
    assert water.hmass    =~ 419057.733
    assert water.hmolar   =~ 7549.437    
    assert water.smass    =~ 1306.921
    assert water.smolar   =~ 23.545      


#---------------
#[
In [1]: import CoolProp

In [2]: CoolProp.CoolProp.generate_update_pair(CoolProp.iT, 300, CoolProp.iDmolar, 1e-6)
Out[2]: (11, 1e-06, 300.0)

In [3]: CoolProp.DmolarT_INPUTS
Out[3]: 11
]#
#--------------------
#[
In [4]: import CoolProp

In [5]: HEOS = CoolProp.AbstractState("HEOS", "Water")

In [6]: HEOS.update(CoolProp.DmolarT_INPUTS, 1e-6, 300)

In [7]: HEOS.p()
Out[7]: 0.002494311404279685

In [8]: [HEOS.keyed_output(k) for k in [CoolProp.iP, CoolProp.iHmass, CoolProp.iHmolar]]
Out[8]: [0.002494311404279685, 2551431.0685640117, 45964.71448370705]
]#

#---------------
#[
In [9]: import CoolProp

In [10]: HEOS = CoolProp.AbstractState("HEOS", "Water")

# Do a flash call that is a very low density state point, definitely vapor
In [11]: %timeit HEOS.update(CoolProp.DmolarT_INPUTS, 1e-6, 300)
10.6 us +- 40.8 ns per loop (mean +- std. dev. of 7 runs, 100000 loops each)

# Specify the phase - for some inputs (especially density-temperature), this will result in a
# more direct evaluation of the equation of state without checking the saturation boundary
In [12]: HEOS.specify_phase(CoolProp.iphase_gas)

# We try it again - a bit faster
In [13]: %timeit HEOS.update(CoolProp.DmolarT_INPUTS, 1e-6, 300)
10.6 us +- 21.8 ns per loop (mean +- std. dev. of 7 runs, 100000 loops each)

# Reset the specification of phase
In [14]: HEOS.specify_phase(CoolProp.iphase_not_imposed)

# A mixture of methane and ethane
In [15]: HEOS = CoolProp.AbstractState("HEOS", "Methane&Ethane")

# Set the mole fractions of the mixture
In [16]: HEOS.set_mole_fractions([0.2,0.8])

# Do the dewpoint calculation
In [17]: HEOS.update(CoolProp.PQ_INPUTS, 101325, 1)

# Liquid phase molar density
In [18]: HEOS.saturated_liquid_keyed_output(CoolProp.iDmolar)
Out[18]: 18274.948846938456

# Vapor phase molar density
In [19]: HEOS.saturated_vapor_keyed_output(CoolProp.iDmolar)
Out[19]: 69.503104630333

# Liquid phase mole fractions
In [20]: HEOS.mole_fractions_liquid()
Out[20]: [0.006106791215290547, 0.9938932087847094]

# Vapor phase mole fractions -
# Should be the bulk composition back since we are doing a dewpoint calculation
In [21]: HEOS.mole_fractions_vapor()
Out[21]: [0.19999999999999996, 0.7999999999999999]
]#
#------------------
#[
# Imposing the single-phase gas region
In [22]: HEOS.specify_phase(CoolProp.iphase_gas)


# Reset the specification of phase
In [23]: HEOS.specify_phase(CoolProp.iphase_not_imposed)

# Or, more simply
In [24]: HEOS.unspecify_phase()
]#

#------------------
#[
In [25]: import CoolProp

In [26]: HEOS = CoolProp.AbstractState("HEOS", "Water")

In [27]: HEOS.update(CoolProp.PT_INPUTS, 101325, 300)

In [28]: HEOS.cpmass()
Out[28]: 4180.635776556088

In [29]: HEOS.first_partial_deriv(CoolProp.iHmass, CoolProp.iT, CoolProp.iP)
Out[29]: 4180.635776556087

In [30]: %timeit HEOS.first_partial_deriv(CoolProp.iHmass, CoolProp.iT, CoolProp.iP)
547 ns +- 2.81 ns per loop (mean +- std. dev. of 7 runs, 1000000 loops each)

# See how much faster this is?
In [31]: %timeit CoolProp.CoolProp.PropsSI('d(Hmass)/d(T)|P', 'P', 101325, 'T', 300, 'Water')
184 us +- 769 ns per loop (mean +- std. dev. of 7 runs, 10000 loops each)

In [32]: HEOS.first_partial_deriv(CoolProp.iSmass, CoolProp.iT, CoolProp.iDmass)
Out[32]: 13.767247481714938

# In the same way you can do second partial derivatives
# This is the second mixed partial derivative of entropy with respect to density and temperature
In [33]: HEOS.second_partial_deriv(CoolProp.iSmass, CoolProp.iT, CoolProp.iDmass, CoolProp.iDmass, CoolProp.iT)
Out[33]: -0.02448973694624097

# This is the second partial derivative of entropy with respect to density at constant temperature
In [33]: HEOS.second_partial_deriv(CoolProp.iSmass,CoolProp.iDmass,CoolProp.iT,CoolProp.iDmass,CoolProp.iT)
Out[34]: -0.007229077393211042
]#

#----------------
#[
In [35]: import CoolProp

In [36]: HEOS = CoolProp.AbstractState("HEOS", "Water")

In [37]: HEOS.update(CoolProp.QT_INPUTS, 0, 300)

# First saturation derivative calculated analytically
In [38]: HEOS.first_saturation_deriv(CoolProp.iP, CoolProp.iT)
Out[38]: 207.90345997878387

In [39]: HEOS.update(CoolProp.QT_INPUTS, 0, 300 + 0.001); p2 = HEOS.p()

In [40]: HEOS.update(CoolProp.QT_INPUTS, 0, 300 - 0.001); p1 = HEOS.p()

# First saturation derivative calculated numerically
In [41]: (p2-p1)/(2*0.001)
Out[41]: 207.9174217212767

In [42]: HEOS.update(CoolProp.QT_INPUTS, 0.1, 300)

# The d(Dmass)/d(Hmass)|P two-phase derivative
In [43]: HEOS.first_two_phase_deriv(CoolProp.iDmass, CoolProp.iHmass, CoolProp.iP)
Out[43]: -1.0494114658359386e-06

# The d(Dmass)/d(Hmass)|P two-phase derivative using splines
In [44]: HEOS.first_two_phase_deriv_splined(CoolProp.iDmass, CoolProp.iHmass, CoolProp.iP, 0.3)
Out[44]: -0.0018169665165181214
]#
#---------------
#[
In [45]: import CoolProp as CP

# This one doesn't see the change in reference state
In [46]: AS1 = CoolProp.AbstractState('HEOS','n-Propane');

In [47]: AS1.update(CoolProp.QT_INPUTS, 0, 233.15);

In [48]: CoolProp.CoolProp.set_reference_state('n-Propane','ASHRAE')

# This one gets the update in the reference state
In [49]: AS2 = CoolProp.AbstractState('HEOS','n-Propane');

In [50]: AS2.update(CoolProp.QT_INPUTS, 0, 233.15);

# Note how the AS1 has its default value (change in reference state is not seen)
# and AS2 does see the new reference state
In [51]: print('{0}, {1}'.format(AS1.hmass(), AS2.hmass()))
105123.27213761522, 2.928438593838672e-11

# Back to the original value
In [52]: CoolProp.CoolProp.set_reference_state('n-Propane','DEF')
]#
#--------------
#[
In [53]: import CoolProp

In [54]: REFPROP = CoolProp.AbstractState("REFPROP", "WATER")

In [55]: REFPROP.update(CoolProp.DmolarT_INPUTS, 1e-6, 300)

In [56]: REFPROP.p(), REFPROP.hmass(), REFPROP.hmolar()
Out[56]: (0.0024943114042796856, 2551431.068564326, 45964.71448371271)

In [57]: [REFPROP.keyed_output(k) for k in [CoolProp.iP, CoolProp.iHmass, CoolProp.iHmolar]]
Out[57]: [0.0024943114042796856, 2551431.068564326, 45964.71448371271]
]#
#---------------
#[
julia> import CoolProp

julia> PT_INPUTS = CoolProp.get_input_pair_index("PT_INPUTS")
7

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
#---------------
#[
#include "CoolPropLib.h"
#include "CoolPropTools.h"
#include <vector>
#include <time.h>

int main(){
    double t1, t2;
    const long buffersize = 500;
    long errcode = 0;
    char buffer[buffersize];
    long handle = AbstractState_factory("BICUBIC&HEOS","Water", &errcode, buffer, buffersize);
    long _HmassP = get_input_pair_index("HmassP_INPUTS");
    long _Dmass = get_param_index("Dmass");
    long len = 20000;
    std::vector<double> h = linspace(700000.0, 1500000.0, len);
    std::vector<double> p = linspace(2.8e6, 3.0e6, len);
    double summer = 0;
    t1 = clock();
    for (long i = 0; i < len; ++i){
        AbstractState_update(handle, _HmassP, h[i], p[i], &errcode, buffer, buffersize);
        summer += AbstractState_keyed_output(handle, _Dmass, &errcode, buffer, buffersize);
    }
    t2 = clock();
    std::cout << format("value(all): %0.13g, %g us/call\n", summer, ((double)(t2-t1))/CLOCKS_PER_SEC/double(len)*1e6);
    return EXIT_SUCCESS;
}
]#

#[
value(all): 8339004.432514, 0.8 us/call
]#

#----------------
#[
#include "CoolPropLib.h"
#include "CoolPropTools.h"
#include <vector>
#include <time.h>

int main(){
    const long buffer_size = 1000, length = 100000;
    long ierr;
    char herr[buffer_size];
    long handle = AbstractState_factory("BICUBIC&HEOS", "Water", &ierr, herr, buffer_size);
    std::vector<double> T(length), p(length), rhomolar(length), hmolar(length), smolar(length);
    std::vector<double> input1 = linspace(700000.0, 1500000.0, length);
    std::vector<double> input2 = linspace(2.8e6, 3.0e6, length);
    long input_pair = get_input_pair_index("HmassP_INPUTS");
    double t1 = clock();
    AbstractState_update_and_common_out(handle, input_pair, &(input1[0]), &(input2[0]), length, 
                                        &(T[0]), &(p[0]), &(rhomolar[0]), &(hmolar[0]), &(smolar[0]), 
                                        &ierr, herr, buffer_size);
    double t2 = clock();
    std::cout << format("value(commons): %g us/call\n", ((double)(t2-t1))/CLOCKS_PER_SEC/double(length)*1e6);

    std::vector<long> outputs(5);
    outputs[0] = get_param_index("T");
    outputs[1] = get_param_index("P");
    outputs[2] = get_param_index("Dmolar");
    outputs[3] = get_param_index("Hmolar");
    outputs[4] = get_param_index("Smolar");
    std::vector<double> out1(length), out2(length), out3(length), out4(length), out5(length);
    t1 = clock();
    AbstractState_update_and_5_out(handle, input_pair, &(input1[0]), &(input2[0]), length,
        &(outputs[0]), &(out1[0]), &(out2[0]), &(out3[0]), &(out4[0]), &(out5[0]),
        &ierr, herr, buffer_size);
    t2 = clock();
    std::cout << format("value(user-specified): %g us/call\n", ((double)(t2-t1))/CLOCKS_PER_SEC/double(length)*1e6);
}
]#

#[
value(commons): 0.78 us/call
value(user-specified): 0.78 us/call
]#