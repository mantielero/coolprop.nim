{.passL:"-lCoolProp -ldl".}
{.passC:"-std=c++11 -Wall -O2 -DCOOLPROP_LIB  -I/usr/include/fmt -I/usr/include/CoolProp".}
import cppstl
##
##  AbstractState.h
##
##   Created on: 21 Dec 2013
##       Author: jowr
##

import DataStructures
export DataStructures
#import
#  CachedElement, Exceptions, DataStructures, PhaseEnvelope, crossplatform_shared_ptr
#import
#  crossplatform_shared_ptr
## / This structure holds values obtained while tracing the spinodal curve
## / (most often in the process of finding critical points, but not only)
type
  CoolPropDbl* = cdouble


{.push header: "AbstractState.h".}
type
  SpinodalData* {.importcpp: "CoolProp::SpinodalData",
                 bycopy.} = object
    tau* {.importc: "tau".}: CppVector[cdouble] ## /< The reciprocal reduced temperature (\f$\tau=T_r/T\f$)
    delta* {.importc: "delta".}: CppVector[cdouble] ## /< The reduced density (\f$\delta=\rho/\rho_r\f$)
    M1* {.importc: "M1".}: CppVector[cdouble] ## /< The determinant of the scaled matrix for the second criticality condition


## / This simple class holds the values for guesses for use in some solvers
## / that have the ability to use guess values intelligently

type
  GuessesStructure* {.importcpp: "CoolProp::GuessesStructure", bycopy.} = object
    T* {.importc: "T".}: cdouble ## /< temperature in K
    p* {.importc: "p".}: cdouble ## /< pressure in Pa
    rhomolar* {.importc: "rhomolar".}: cdouble ## /< molar density in mol/m^3
    hmolar* {.importc: "hmolar".}: cdouble ## /< molar enthalpy in J/mol
    smolar* {.importc: "smolar".}: cdouble ## /< molar entropy in J/mol/K
    rhomolar_liq* {.importc: "rhomolar_liq".}: cdouble ## /< molar density of the liquid phase in mol/m^3
    rhomolar_vap* {.importc: "rhomolar_vap".}: cdouble ## /< molar density of the vapor phase in mol/m^3
    x* {.importc: "x".}: CppVector[cdouble] ## /< molar composition of the liquid phase
    y* {.importc: "y".}: CppVector[cdouble] ## /< molar composition of the vapor phase


proc constructGuessesStructure*(): GuessesStructure {.constructor,
    importcpp: "CoolProp::GuessesStructure(@)".}
proc clear*(this: var GuessesStructure) {.importcpp: "clear".}
## ! The mother of all state classes
## !
## This class provides the basic properties based on interrelations of the
## properties, their derivatives and the Helmholtz energy terms. It does not
## provide the mechanism to update the values. This has to be implemented in
## a subclass. Most functions are defined as virtual functions allowing us
## redefine them later, for example to implement the TTSE technique. The
## functions defined here are always used as a fall-back.
##
## This base class does not perform any checks on the two-phase conditions and
## alike. Most of the functions defined here only apply to compressible single
## state substances. Make sure you are aware of all the assumptions we made
## when using this class.
##
## Add build table function to Abstract State
## Interpolator inherit AS implemented by TTSE BICUBIC
##
##

type
  AbstractState* {.importcpp: "CoolProp::AbstractState",
                  byref.} = object ## / Some administrative variables
    ## /< The key for the phase from CoolProp::phases enum
    ## /< If the phase is imposed, the imposed phase index
    ## / Molar mass [mol/kg]
    ## / Universal gas constant [J/mol/K]
    ## / Bulk values
    ## / Transport properties
    ## / Residual properties
    ## / Excess properties
    ## / Ancillary values
    ## / Smoothing values
    ## / Cached low-level elements for in-place calculation of other properties
    ## / Two-Phase variables
    ##  ----------------------------------------
    ##  Property accessors to be optionally implemented by the backend
    ##  for properties that are not always calculated
    ##  ----------------------------------------
    ## / Using this backend, calculate the molar enthalpy in J/mol


proc constructAbstractState*(): AbstractState {.constructor,
    importcpp: "CoolProp::AbstractState(@)".}
proc destroyAbstractState*(this: var AbstractState) {.
    importcpp: "#.~AbstractState()".}


proc factory*(backend: CppString; fluid_names: CppString): ptr AbstractState {.
    importcpp: "CoolProp::AbstractState::factory(@)".}
  ##  @brief A factory function to return a pointer to a new-allocated instance of one of the backends.
  ##  @param backend The backend in use, "HEOS", "REFPROP", etc.
  ##  @param fluid_names A vector of strings of the fluid names
  ##  @return A pointer to the instance generated
  ##
  ##  Several backends are possible:
  ##
  ##  1. "?" : The backend is unknown, we will parse the fluid string to determine the backend to be used.  Probably will use HEOS backend (see below)
  ##  2. "HEOS" : The Helmholtz Equation of State backend for use with pure and pseudo-pure fluids, and mixtures, all of which are based on multi-parameter Helmholtz Energy equations of state.  The fluid part of the string should then either be
  ##     1. A pure or pseudo-pure fluid name (eg. "PROPANE" or "R410A"), yielding a HelmholtzEOSBackend instance.
  ##     2. A string that encodes the components of the mixture with a "&" between them (e.g. "R32&R125"), yielding a HelmholtzEOSMixtureBackend instance.
  ##
  ##  3. "REFPROP" : The REFPROP backend will be used.  The fluid part of the string should then either be
  ##     1. A pure or pseudo-pure fluid name (eg. "PROPANE" or "R410A"), yielding a REFPROPBackend instance.
  ##     2. A string that encodes the components of the mixture with a "&" between them (e.g. "R32&R125"), yielding a REFPROPMixtureBackend instance.
  ##
  ##  4. "INCOMP": The incompressible backend will be used
  ##  5. "TTSE&XXXX": The TTSE backend will be used, and the tables will be generated using the XXXX backend where XXXX is one of the base backends("HEOS", "REFPROP", etc. )
  ##  6. "BICUBIC&XXXX": The Bicubic backend will be used, and the tables will be generated using the XXXX backend where XXXX is one of the base backends("HEOS", "REFPROP", etc. )
  ##
  ##  Very Important!! : Use a smart pointer to manage the pointer returned.  In older versions of C++, you can use std::tr1::smart_ptr. In C++2011 you can use std::shared_ptr
  ##

proc factory*(backend: string; fluid_names: CppVector[string]): ptr AbstractState {.
    importcpp: "CoolProp::AbstractState::factory(@)".}

proc set_T*(this: var AbstractState; T: CoolPropDbl) {.importcpp: "set_T".}

proc backend_name*(this: var AbstractState): string {.importcpp: "backend_name".}

proc using_mole_fractions*(this: var AbstractState): bool {.
    importcpp: "using_mole_fractions".}

proc using_mass_fractions*(this: var AbstractState): bool {.
    importcpp: "using_mass_fractions".}

proc using_volu_fractions*(this: var AbstractState): bool {.
    importcpp: "using_volu_fractions".}

proc set_mole_fractions*(this: var AbstractState;
                        mole_fractions: CppVector[CoolPropDbl]) {.
    importcpp: "set_mole_fractions".}

proc set_mass_fractions*(this: var AbstractState;
                        mass_fractions: CppVector[CoolPropDbl]) {.
    importcpp: "set_mass_fractions".}

proc set_volu_fractions*(this: var AbstractState;
                        mass_fractions: CppVector[CoolPropDbl]) {.
    importcpp: "set_volu_fractions".}

proc set_reference_stateS*(this: var AbstractState; reference_state: string) {.
    importcpp: "set_reference_stateS".}

proc set_reference_stateD*(this: var AbstractState; T: cdouble; rhomolar: cdouble;
                          hmolar0: cdouble; smolar0: cdouble) {.
    importcpp: "set_reference_stateD".}

# when not defined(COOLPROPDBL_MAPS_TO_DOUBLE):
#   proc set_mole_fractions*(this: var AbstractState; mole_fractions: CppVector[cdouble]) {.
#       importcpp: "set_mole_fractions".}
# when not defined(COOLPROPDBL_MAPS_TO_DOUBLE):
#   proc set_mass_fractions*(this: var AbstractState; mass_fractions: CppVector[cdouble]) {.
#       importcpp: "set_mass_fractions".}
# when not defined(COOLPROPDBL_MAPS_TO_DOUBLE):
#   proc set_volu_fractions*(this: var AbstractState; volu_fractions: CppVector[cdouble]) {.
#       importcpp: "set_volu_fractions".}
# when defined(EMSCRIPTEN):
#   proc set_mole_fractions_double*(this: var AbstractState;
#                                  mole_fractions: CppVector[cdouble]) {.
#       importcpp: "set_mole_fractions_double".}

proc mole_fractions_liquid*(this: var AbstractState): CppVector[CoolPropDbl] {.
    importcpp: "mole_fractions_liquid".}

  ## / Get the mole fractions of the equilibrium liquid phase (but as a double for use in SWIG wrapper)
proc mole_fractions_liquid_double*(this: var AbstractState): CppVector[cdouble] {.
    importcpp: "mole_fractions_liquid_double".}

  ## / Get the mole fractions of the equilibrium vapor phase
proc mole_fractions_vapor*(this: var AbstractState): CppVector[CoolPropDbl] {.
    importcpp: "mole_fractions_vapor".}

  ## / Get the mole fractions of the equilibrium vapor phase (but as a double for use in SWIG wrapper)
proc mole_fractions_vapor_double*(this: var AbstractState): CppVector[cdouble] {.
    importcpp: "mole_fractions_vapor_double".}

  ## / Get the mole fractions of the fluid
proc get_mole_fractions*(this: var AbstractState): CppVector[CoolPropDbl] {.
    importcpp: "get_mole_fractions".}

proc get_mass_fractions*(this: var AbstractState): CppVector[CoolPropDbl] {.
    importcpp: "get_mass_fractions".}

  ## / Update the state using two state variables
proc update*(this: var AbstractState; input_pair: input_pairs; Value1: cdouble;
            Value2: cdouble) {.importcpp: "update".}

proc update_with_guesses*(this: var AbstractState; input_pair: input_pairs;
                         Value1: cdouble; Value2: cdouble; guesses: GuessesStructure) {.
    importcpp: "update_with_guesses".}

  ## / A function that says whether the backend instance can be instantiated in the high-level interface
  ## / In general this should be true, except for some other backends (especially the tabular backends)
  ## / To disable use in high-level interface, implement this function and return false
proc available_in_high_level*(this: var AbstractState): bool {.
    importcpp: "available_in_high_level".}

proc fluid_param_string*(this: var AbstractState; a2: string): string {.
    importcpp: "fluid_param_string".}

proc fluid_names*(this: var AbstractState): CppVector[string] {.
    importcpp: "fluid_names".}

proc get_fluid_constant*(this: AbstractState; i: uint; param: parameters): cdouble {.
    noSideEffect, importcpp: "get_fluid_constant".}

proc set_binary_interaction_double*(this: var AbstractState; CAS1: string;
                                   CAS2: string; parameter: string; value: cdouble) {.
    importcpp: "set_binary_interaction_double".}

  ## / Set binary mixture floating point parameter (EXPERT USE ONLY!!!)
proc set_binary_interaction_double*(this: var AbstractState; i: uint; j: uint;
                                   parameter: string; value: cdouble) {.
    importcpp: "set_binary_interaction_double".}

  ## / Set binary mixture string parameter (EXPERT USE ONLY!!!)
proc set_binary_interaction_string*(this: var AbstractState; CAS1: string;
                                   CAS2: string; parameter: string; value: string) {.
    importcpp: "set_binary_interaction_string".}

  ## / Set binary mixture string parameter (EXPERT USE ONLY!!!)
proc set_binary_interaction_string*(this: var AbstractState; i: uint; j: uint;
                                   parameter: string; value: string) {.
    importcpp: "set_binary_interaction_string".}

  ## / Get binary mixture double value (EXPERT USE ONLY!!!)
proc get_binary_interaction_double*(this: var AbstractState; CAS1: string;
                                   CAS2: string; parameter: string): cdouble {.
    importcpp: "get_binary_interaction_double".}
  ## / Get binary mixture double value (EXPERT USE ONLY!!!)
proc get_binary_interaction_double*(this: var AbstractState; i: uint; j: uint;
                                   parameter: string): cdouble {.
    importcpp: "get_binary_interaction_double".}
  ## / Get binary mixture string value (EXPERT USE ONLY!!!)
proc get_binary_interaction_string*(this: var AbstractState; CAS1: string;
                                   CAS2: string; parameter: string): string {.
    importcpp: "get_binary_interaction_string".}
  ## / Apply a simple mixing rule (EXPERT USE ONLY!!!)
proc apply_simple_mixing_rule*(this: var AbstractState; i: uint; j: uint;
                              model: string) {.
    importcpp: "apply_simple_mixing_rule".}
  ## / Set the cubic alpha function's constants:
proc set_cubic_alpha_C*(this: var AbstractState; i: cuint; parameter: string;
                       c1: cdouble; c2: cdouble; c3: cdouble) {.
    importcpp: "set_cubic_alpha_C".}
  ## / Set fluid parameter (currently the volume translation parameter for cubic)
proc set_fluid_parameter_double*(this: var AbstractState; i: cuint;
                                parameter: string; value: cdouble) {.
    importcpp: "set_fluid_parameter_double".}
  ## / Double fluid parameter (currently the volume translation parameter for cubic)
proc get_fluid_parameter_double*(this: var AbstractState; i: cuint;
                                parameter: string): cdouble {.
    importcpp: "get_fluid_parameter_double".}
  ## / Clear all the cached values
proc clear*(this: var AbstractState): bool {.importcpp: "clear".}
proc clear_comp_change*(this: var AbstractState): bool {.
    importcpp: "clear_comp_change".}
proc get_reducing_state*(this: var AbstractState): SimpleState {.
    importcpp: "get_reducing_state".}
  ## / Get a desired state point - backend dependent
proc get_state*(this: var AbstractState; state: string): SimpleState {.
    importcpp: "get_state".}
  ## / Get the minimum temperature in K
proc Tmin*(this: var AbstractState): cdouble {.importcpp: "Tmin".}
proc Tmax*(this: var AbstractState): cdouble {.importcpp: "Tmax".}
proc pmax*(this: var AbstractState): cdouble {.importcpp: "pmax".}
proc Ttriple*(this: var AbstractState): cdouble {.importcpp: "Ttriple".}
proc phase*(this: var AbstractState): phases {.importcpp: "phase".}
  ## / Specify the phase for all further calculations with this state class
proc specify_phase*(this: var AbstractState; phase: phases) {.
    importcpp: "specify_phase".}
  ## / Unspecify the phase and go back to calculating it based on the inputs
proc unspecify_phase*(this: var AbstractState) {.importcpp: "unspecify_phase".}
  ## / Return the critical temperature in K
proc T_critical*(this: var AbstractState): cdouble {.importcpp: "T_critical".}
proc p_critical*(this: var AbstractState): cdouble {.importcpp: "p_critical".}
proc rhomolar_critical*(this: var AbstractState): cdouble {.
    importcpp: "rhomolar_critical".}
proc rhomass_critical*(this: var AbstractState): cdouble {.
    importcpp: "rhomass_critical".}
proc all_critical_points*(this: var AbstractState): CppVector[CriticalState] {.
    importcpp: "all_critical_points".}
  ## / Construct the spinodal curve for the mixture (or pure fluid)
proc build_spinodal*(this: var AbstractState) {.importcpp: "build_spinodal".}
  ## / Get the data from the spinodal curve constructed in the call to build_spinodal()
proc get_spinodal_data*(this: var AbstractState): SpinodalData {.
    importcpp: "get_spinodal_data".}
  ## / Calculate the criticality contour values \f$\mathcal{L}_1^*\f$ and \f$\mathcal{M}_1^*\f$
proc criticality_contour_values*(this: var AbstractState; L1star: var cdouble;
                                M1star: var cdouble) {.
    importcpp: "criticality_contour_values".}
proc tangent_plane_distance*(this: var AbstractState; T: cdouble; p: cdouble;
                            w: CppVector[cdouble]; rhomolar_guess: cdouble = -1): cdouble {.
    importcpp: "tangent_plane_distance".}
  ## / Return the reducing point temperature in K
proc T_reducing*(this: var AbstractState): cdouble {.importcpp: "T_reducing".}
proc rhomolar_reducing*(this: var AbstractState): cdouble {.
    importcpp: "rhomolar_reducing".}
proc rhomass_reducing*(this: var AbstractState): cdouble {.
    importcpp: "rhomass_reducing".}
proc p_triple*(this: var AbstractState): cdouble {.importcpp: "p_triple".}
proc name*(this: var AbstractState): string {.importcpp: "name".}
  ## / Return the description - backend dependent
proc description*(this: var AbstractState): string {.importcpp: "description".}
  ## / Return the dipole moment in C-m (1 D = 3.33564e-30 C-m)
proc dipole_moment*(this: var AbstractState): cdouble {.importcpp: "dipole_moment".}
proc keyed_output*(this: var AbstractState; key: parameters): cdouble {.
    importcpp: "keyed_output".}
proc trivial_keyed_output*(this: var AbstractState; key: parameters): cdouble {.
    importcpp: "trivial_keyed_output".}
proc saturated_liquid_keyed_output*(this: var AbstractState; key: parameters): cdouble {.
    importcpp: "saturated_liquid_keyed_output".}
  ## / Get an output from the saturated vapor state by key
proc saturated_vapor_keyed_output*(this: var AbstractState; key: parameters): cdouble {.
    importcpp: "saturated_vapor_keyed_output".}

#OK
proc t*(this: var AbstractState): cdouble {.importcpp: "T".}
  ## return the temperature in K
  
#OK
proc rhomolar*(this: var AbstractState): cdouble {.importcpp: "rhomolar".}
  ## return the molar density in mol/m^3

#OK
proc rhomass*(this: var AbstractState): cdouble {.importcpp: "rhomass".}
  ## return the mass density in kg/m^3
  

proc p*(this: var AbstractState): cdouble {.importcpp: "p".}
  ## return the pressure in Pa

proc Q*(this: var AbstractState): cdouble {.importcpp: "Q".}
  ## return the vapor quality (mol/mol); Q = 0 for saturated liquid

proc tau*(this: var AbstractState): cdouble {.importcpp: "tau".}
  ## Return the reciprocal of the reduced temperature (\f$\tau = T_c/T\f$)


proc delta*(this: var AbstractState): cdouble {.importcpp: "delta".}

proc molar_mass*(this: var AbstractState): cdouble {.importcpp: "molar_mass".}

proc acentric_factor*(this: var AbstractState): cdouble {.
    importcpp: "acentric_factor".}

proc gas_constant*(this: var AbstractState): cdouble {.importcpp: "gas_constant".}

proc Bvirial*(this: var AbstractState): cdouble {.importcpp: "Bvirial".}

proc dBvirial_dT*(this: var AbstractState): cdouble {.importcpp: "dBvirial_dT".}

proc Cvirial*(this: var AbstractState): cdouble {.importcpp: "Cvirial".}

proc dCvirial_dT*(this: var AbstractState): cdouble {.importcpp: "dCvirial_dT".}

proc compressibility_factor*(this: var AbstractState): cdouble {.
    importcpp: "compressibility_factor".}

#OK
proc hmolar*(this: var AbstractState): cdouble {.importcpp: "hmolar".}


proc hmolar_residual*(this: var AbstractState): cdouble {.
    importcpp: "hmolar_residual".}

#OK
proc hmass*(this: var AbstractState): cdouble {.importcpp: "hmass".}
  ## / Return the excess molar enthalpy in J/mol

proc hmolar_excess*(this: var AbstractState): cdouble {.importcpp: "hmolar_excess".}
proc hmass_excess*(this: var AbstractState): cdouble {.importcpp: "hmass_excess".}

#OK    
proc smolar*(this: var AbstractState): cdouble {.importcpp: "smolar".}
  ## Return the molar entropy in J/mol/K
  
proc smolar_residual*(this: var AbstractState): cdouble {.
    importcpp: "smolar_residual".}

#OK 
proc smass*(this: var AbstractState): cdouble {.importcpp: "smass".}


  ## / Return the molar entropy in J/mol/K
proc smolar_excess*(this: var AbstractState): cdouble {.importcpp: "smolar_excess".}
proc smass_excess*(this: var AbstractState): cdouble {.importcpp: "smass_excess".}
  ## / Return the molar internal energy in J/mol
proc umolar*(this: var AbstractState): cdouble {.importcpp: "umolar".}
proc umass*(this: var AbstractState): cdouble {.importcpp: "umass".}
  ## / Return the excess internal energy in J/mol
proc umolar_excess*(this: var AbstractState): cdouble {.importcpp: "umolar_excess".}
proc umass_excess*(this: var AbstractState): cdouble {.importcpp: "umass_excess".}
  ## / Return the molar constant pressure specific heat in J/mol/K
proc cpmolar*(this: var AbstractState): cdouble {.importcpp: "cpmolar".}
proc cpmass*(this: var AbstractState): cdouble {.importcpp: "cpmass".}
  ## / Return the molar constant pressure specific heat for ideal gas part only in J/mol/K
proc cp0molar*(this: var AbstractState): cdouble {.importcpp: "cp0molar".}
proc cp0mass*(this: var AbstractState): cdouble {.importcpp: "cp0mass".}
  ## / Return the molar constant volume specific heat in J/mol/K
proc cvmolar*(this: var AbstractState): cdouble {.importcpp: "cvmolar".}
proc cvmass*(this: var AbstractState): cdouble {.importcpp: "cvmass".}
  ## / Return the Gibbs energy in J/mol
proc gibbsmolar*(this: var AbstractState): cdouble {.importcpp: "gibbsmolar".}
proc gibbsmolar_residual*(this: var AbstractState): cdouble {.
    importcpp: "gibbsmolar_residual".}
proc gibbsmass*(this: var AbstractState): cdouble {.importcpp: "gibbsmass".}
  ## / Return the excess Gibbs energy in J/mol
proc gibbsmolar_excess*(this: var AbstractState): cdouble {.
    importcpp: "gibbsmolar_excess".}
proc gibbsmass_excess*(this: var AbstractState): cdouble {.
    importcpp: "gibbsmass_excess".}
  ## / Return the Helmholtz energy in J/mol
proc helmholtzmolar*(this: var AbstractState): cdouble {.importcpp: "helmholtzmolar".}
proc helmholtzmass*(this: var AbstractState): cdouble {.importcpp: "helmholtzmass".}
  ## / Return the excess Helmholtz energy in J/mol
proc helmholtzmolar_excess*(this: var AbstractState): cdouble {.
    importcpp: "helmholtzmolar_excess".}
proc helmholtzmass_excess*(this: var AbstractState): cdouble {.
    importcpp: "helmholtzmass_excess".}
  ## / Return the excess volume in m^3/mol
proc volumemolar_excess*(this: var AbstractState): cdouble {.
    importcpp: "volumemolar_excess".}
proc volumemass_excess*(this: var AbstractState): cdouble {.
    importcpp: "volumemass_excess".}
  ## / Return the speed of sound in m/s
proc speed_sound*(this: var AbstractState): cdouble {.importcpp: "speed_sound".}
proc isothermal_compressibility*(this: var AbstractState): cdouble {.
    importcpp: "isothermal_compressibility".}
proc isobaric_expansion_coefficient*(this: var AbstractState): cdouble {.
    importcpp: "isobaric_expansion_coefficient".}
proc isentropic_expansion_coefficient*(this: var AbstractState): cdouble {.
    importcpp: "isentropic_expansion_coefficient".}
proc fugacity_coefficient*(this: var AbstractState; i: uint): cdouble {.
    importcpp: "fugacity_coefficient".}
proc fugacity_coefficients*(this: var AbstractState): CppVector[cdouble] {.
    importcpp: "fugacity_coefficients".}
proc fugacity*(this: var AbstractState; i: uint): cdouble {.importcpp: "fugacity".}
proc chemical_potential*(this: var AbstractState; i: uint): cdouble {.
    importcpp: "chemical_potential".}
proc fundamental_derivative_of_gas_dynamics*(this: var AbstractState): cdouble {.
    importcpp: "fundamental_derivative_of_gas_dynamics".}
proc PIP*(this: var AbstractState): cdouble {.importcpp: "PIP".}
  ## / Calculate the "true" critical point for pure fluids where dpdrho|T and d2p/drho2|T are equal to zero
proc true_critical_point*(this: var AbstractState; T: var cdouble; rho: var cdouble) {.
    importcpp: "true_critical_point".}
proc ideal_curve*(this: var AbstractState; `type`: string; T: var CppVector[cdouble];
                 p: var CppVector[cdouble]) {.importcpp: "ideal_curve".}
  ##  ----------------------------------------
  ##     Partial derivatives
  ##  ----------------------------------------
  ## * \brief The first partial derivative in homogeneous phases
  ##
  ##  \f[ \left(\frac{\partial A}{\partial B}\right)_C = \frac{\left(\frac{\partial A}{\partial \tau}\right)_\delta\left(\frac{\partial C}{\partial \delta}\right)_\tau-\left(\frac{\partial A}{\partial \delta}\right)_\tau\left(\frac{\partial C}{\partial \tau}\right)_\delta}{\left(\frac{\partial B}{\partial \tau}\right)_\delta\left(\frac{\partial C}{\partial \delta}\right)_\tau-\left(\frac{\partial B}{\partial \delta}\right)_\tau\left(\frac{\partial C}{\partial \tau}\right)_\delta} = \frac{N}{D}\f]
  ##
proc first_partial_deriv*(this: var AbstractState; Of: parameters; Wrt: parameters;
                         Constant: parameters): CoolPropDbl {.
    importcpp: "first_partial_deriv".}
  ## * \brief The second partial derivative in homogeneous phases
  ##
  ##  The first partial derivative (\ref CoolProp::AbstractState::first_partial_deriv) can be expressed as
  ##
  ##  \f[ \left(\frac{\partial A}{\partial B}\right)_C = \frac{\left(\frac{\partial A}{\partial T}\right)_\rho\left(\frac{\partial C}{\partial \rho}\right)_T-\left(\frac{\partial A}{\partial \rho}\right)_T\left(\frac{\partial C}{\partial T}\right)_\rho}{\left(\frac{\partial B}{\partial T}\right)_\rho\left(\frac{\partial C}{\partial \rho}\right)_T-\left(\frac{\partial B}{\partial \rho}\right)_T\left(\frac{\partial C}{\partial T}\right)_\rho} = \frac{N}{D}\f]
  ##
  ##  and the second derivative can be expressed as
  ##
  ##  \f[
  ##  \frac{\partial}{\partial D}\left(\left(\frac{\partial A}{\partial B}\right)_C\right)_E = \frac{\frac{\partial}{\partial T}\left( \left(\frac{\partial A}{\partial B}\right)_C \right)_\rho\left(\frac{\partial E}{\partial \rho}\right)_T-\frac{\partial}{\partial \rho}\left(\left(\frac{\partial A}{\partial B}\right)_C\right)_T\left(\frac{\partial E}{\partial T}\right)_\rho}{\left(\frac{\partial D}{\partial T}\right)_\rho\left(\frac{\partial E}{\partial \rho}\right)_T-\left(\frac{\partial D}{\partial \rho}\right)_T\left(\frac{\partial E}{\partial T}\right)_\rho}
  ##  \f]
  ##
  ##  which can be expressed in parts as
  ##
  ##  \f[\left(\frac{\partial N}{\partial \rho}\right)_{T} = \left(\frac{\partial A}{\partial T}\right)_\rho\left(\frac{\partial^2 C}{\partial \rho^2}\right)_{T}+\left(\frac{\partial^2 A}{\partial T\partial\rho}\right)\left(\frac{\partial C}{\partial \rho}\right)_{T}-\left(\frac{\partial A}{\partial \rho}\right)_T\left(\frac{\partial^2 C}{\partial T\partial\rho}\right)-\left(\frac{\partial^2 A}{\partial \rho^2}\right)_{T}\left(\frac{\partial C}{\partial T}\right)_\rho\f]
  ##  \f[\left(\frac{\partial D}{\partial \rho}\right)_{T} = \left(\frac{\partial B}{\partial T}\right)_\rho\left(\frac{\partial^2 C}{\partial \rho^2}\right)_{T}+\left(\frac{\partial^2 B}{\partial T\partial\rho}\right)\left(\frac{\partial C}{\partial \rho}\right)_{T}-\left(\frac{\partial B}{\partial \rho}\right)_T\left(\frac{\partial^2 C}{\partial T\partial\rho}\right)-\left(\frac{\partial^2 B}{\partial \rho^2}\right)_{T}\left(\frac{\partial C}{\partial T}\right)_\rho\f]
  ##  \f[\left(\frac{\partial N}{\partial T}\right)_{\rho} = \left(\frac{\partial A}{\partial T}\right)_\rho\left(\frac{\partial^2 C}{\partial \rho\partial T}\right)+\left(\frac{\partial^2 A}{\partial T^2}\right)_\rho\left(\frac{\partial C}{\partial \rho}\right)_{T}-\left(\frac{\partial A}{\partial \rho}\right)_T\left(\frac{\partial^2 C}{\partial T^2}\right)_\rho-\left(\frac{\partial^2 A}{\partial \rho\partial T}\right)\left(\frac{\partial C}{\partial T}\right)_\rho\f]
  ##  \f[\left(\frac{\partial D}{\partial T}\right)_{\rho} = \left(\frac{\partial B}{\partial T}\right)_\rho\left(\frac{\partial^2 C}{\partial \rho\partial T}\right)+\left(\frac{\partial^2 B}{\partial T^2}\right)_\rho\left(\frac{\partial C}{\partial \rho}\right)_{T}-\left(\frac{\partial B}{\partial \rho}\right)_T\left(\frac{\partial^2 C}{\partial T^2}\right)_\rho-\left(\frac{\partial^2 B}{\partial \rho\partial T}\right)\left(\frac{\partial C}{\partial T}\right)_\rho\f]
  ##  \f[\frac{\partial}{\partial \rho}\left( \left(\frac{\partial A}{\partial B}\right)_C \right)_T = \frac{D\left(\frac{\partial N}{\partial \rho}\right)_{T}-N\left(\frac{\partial D}{\partial \rho}\right)_{\tau}}{D^2}\f]
  ##  \f[\frac{\partial}{\partial T}\left( \left(\frac{\partial A}{\partial B}\right)_C \right)_\rho = \frac{D\left(\frac{\partial N}{\partial T}\right)_{\rho}-N\left(\frac{\partial D}{\partial T}\right)_{\rho}}{D^2}\f]
  ##
  ##  The terms \f$ N \f$ and \f$ D \f$ are the numerator and denominator from \ref CoolProp::AbstractState::first_partial_deriv respectively
  ##
proc second_partial_deriv*(this: var AbstractState; Of1: parameters; Wrt1: parameters;
                          Constant1: parameters; Wrt2: parameters;
                          Constant2: parameters): CoolPropDbl {.
    importcpp: "second_partial_deriv".}
  ## * \brief The first partial derivative along the saturation curve
  ##
  ##  Implementing the algorithms and ideas of:
  ##  Matthis Thorade, Ali Saadat, "Partial derivatives of thermodynamic state properties for dynamic simulation",
  ##  Environmental Earth Sciences, December 2013, Volume 70, Issue 8, pp 3497-3503
  ##
  ##  Basically the idea is that the p-T derivative is given by Clapeyron relations:
  ##
  ##  \f[ \left(\frac{\partial T}{\partial p}\right)_{\sigma} = T\left(\frac{v'' - v'}{h'' - h'}\right)_{\sigma} \f]
  ##
  ##  and then other derivatives can be obtained along the saturation curve from
  ##
  ##  \f[ \left(\frac{\partial y}{\partial p}\right)_{\sigma} = \left(\frac{\partial y}{\partial p}\right)+\left(\frac{\partial y}{\partial T}\right)\left(\frac{\partial T}{\partial p}\right)_{\sigma} \f]
  ##
  ##  \f[ \left(\frac{\partial y}{\partial T}\right)_{\sigma} = \left(\frac{\partial y}{\partial T}\right)+\left(\frac{\partial y}{\partial p}\right)\left(\frac{\partial p}{\partial T}\right)_{\sigma} \f]
  ##
  ##  where derivatives without the \f$ \sigma \f$ are homogeneous (conventional) derivatives.
  ##
  ##  @param Of1 The parameter that the derivative is taken of
  ##  @param Wrt1 The parameter that the derivative is taken with respect to
  ##
proc first_saturation_deriv*(this: var AbstractState; Of1: parameters;
                            Wrt1: parameters): CoolPropDbl {.
    importcpp: "first_saturation_deriv".}
  ## * \brief The second partial derivative along the saturation curve
  ##
  ##  Implementing the algorithms and ideas of:
  ##  Matthis Thorade, Ali Saadat, "Partial derivatives of thermodynamic state properties for dynamic simulation",
  ##  Environmental Earth Sciences, December 2013, Volume 70, Issue 8, pp 3497-3503
  ##
  ##  Like with \ref first_saturation_deriv, we can express the derivative as
  ##  \f[ \left(\frac{\partial y}{\partial T}\right)_{\sigma} = \left(\frac{\partial y}{\partial T}\right)+\left(\frac{\partial y}{\partial p}\right)\left(\frac{\partial p}{\partial T}\right)_{\sigma} \f]
  ##
  ##  where \f$ y \f$ is already a saturation derivative. So you might end up with something like
  ##
  ##  \f[ \left(\frac{\partial \left(\frac{\partial T}{\partial p}\right)_{\sigma}}{\partial T}\right)_{\sigma} = \left(\frac{\partial \left(\frac{\partial T}{\partial p}\right)_{\sigma}}{\partial T}\right)+\left(\frac{\partial \left(\frac{\partial T}{\partial p}\right)_{\sigma}}{\partial p}\right)\left(\frac{\partial p}{\partial T}\right)_{\sigma} \f]
  ##
  ##  @param Of1 The parameter that the first derivative is taken of
  ##  @param Wrt1 The parameter that the first derivative is taken with respect to
  ##  @param Wrt2 The parameter that the second derivative is taken with respect to
  ##
proc second_saturation_deriv*(this: var AbstractState; Of1: parameters;
                             Wrt1: parameters; Wrt2: parameters): CoolPropDbl {.
    importcpp: "second_saturation_deriv".}
  ## *
  ##  @brief Calculate the first "two-phase" derivative as described by Thorade and Sadaat, EAS, 2013
  ##
  ##  Implementing the algorithms and ideas of:
  ##  Matthis Thorade, Ali Saadat, "Partial derivatives of thermodynamic state properties for dynamic simulation",
  ##  Environmental Earth Sciences, December 2013, Volume 70, Issue 8, pp 3497-3503
  ##
  ##  Spline evaluation is as described in:
  ##  S Quoilin, I Bell, A Desideri, P Dewallef, V Lemort,
  ##  "Methods to increase the robustness of finite-volume flow models in thermodynamic systems",
  ##  Energies 7 (3), 1621-1640
  ##
  ##  \note Not all derivatives are supported!
  ##
  ##  @param Of The parameter to be derived
  ##  @param Wrt The parameter that the derivative is taken with respect to
  ##  @param Constant The parameter that is held constant
  ##  @return
  ##
proc first_two_phase_deriv*(this: var AbstractState; Of: parameters; Wrt: parameters;
                           Constant: parameters): cdouble {.
    importcpp: "first_two_phase_deriv".}
  ## *
  ##  @brief Calculate the second "two-phase" derivative as described by Thorade and Sadaat, EAS, 2013
  ##
  ##  Implementing the algorithms and ideas of:
  ##  Matthis Thorade, Ali Saadat, "Partial derivatives of thermodynamic state properties for dynamic simulation",
  ##  Environmental Earth Sciences, December 2013, Volume 70, Issue 8, pp 3497-3503
  ##
  ##  \note Not all derivatives are supported!
  ##
  ##  @param Of The parameter to be derived
  ##  @param Wrt1 The parameter that the derivative is taken with respect to in the first derivative
  ##  @param Constant1 The parameter that is held constant in the first derivative
  ##  @param Wrt2 The parameter that the derivative is taken with respect to in the second derivative
  ##  @param Constant2 The parameter that is held constant in the second derivative
  ##  @return
  ##
proc second_two_phase_deriv*(this: var AbstractState; Of: parameters;
                            Wrt1: parameters; Constant1: parameters;
                            Wrt2: parameters; Constant2: parameters): cdouble {.
    importcpp: "second_two_phase_deriv".}
  ## *
  ##  @brief Calculate the first "two-phase" derivative as described by Thorade and Sadaat, EAS, 2013
  ##
  ##  Implementing the algorithms and ideas of:
  ##  Matthis Thorade, Ali Saadat, "Partial derivatives of thermodynamic state properties for dynamic simulation",
  ##  Environmental Earth Sciences, December 2013, Volume 70, Issue 8, pp 3497-3503
  ##
  ##  Spline evaluation is as described in:
  ##  S Quoilin, I Bell, A Desideri, P Dewallef, V Lemort,
  ##  "Methods to increase the robustness of finite-volume flow models in thermodynamic systems",
  ##  Energies 7 (3), 1621-1640
  ##
  ##  \note Not all derivatives are supported! If you need all three currently supported values (drho_dh__p, drho_dp__h and rho_spline), you should calculate drho_dp__h first to avoid duplicate calculations.
  ##
  ##  @param Of The parameter to be derived
  ##  @param Wrt The parameter that the derivative is taken with respect to
  ##  @param Constant The parameter that is held constant
  ##  @param x_end The end vapor quality at which the spline is defined (spline is active in [0, x_end])
  ##  @return
  ##
proc first_two_phase_deriv_splined*(this: var AbstractState; Of: parameters;
                                   Wrt: parameters; Constant: parameters;
                                   x_end: cdouble): cdouble {.
    importcpp: "first_two_phase_deriv_splined".}
  ##  ----------------------------------------
  ##     Phase envelope for mixtures
  ##  ----------------------------------------
  ## *
  ##  \brief Construct the phase envelope for a mixture
  ##
  ##  @param type currently a dummy variable that is not used
  ##
proc build_phase_envelope*(this: var AbstractState; `type`: string = "") {.
    importcpp: "build_phase_envelope".}
# proc get_phase_envelope_data*(this: var AbstractState): PhaseEnvelopeData {.
#     importcpp: "get_phase_envelope_data".}
  ##  ----------------------------------------
  ##     Ancillary equations
  ##  ----------------------------------------
  ## / Return true if the fluid has a melting line - default is false, but can be re-implemented by derived class
proc has_melting_line*(this: var AbstractState): bool {.
    importcpp: "has_melting_line".}
  ## / Return a value from the melting line
  ## / @param param The key for the parameter to be returned
  ## / @param given The key for the parameter that is given
  ## / @param value The value for the parameter that is given
proc melting_line*(this: var AbstractState; param: cint; given: cint; value: cdouble): cdouble {.
    importcpp: "melting_line".}
proc saturation_ancillary*(this: var AbstractState; param: parameters; Q: cint;
                          given: parameters; value: cdouble): cdouble {.
    importcpp: "saturation_ancillary".}
proc viscosity*(this: var AbstractState): cdouble {.importcpp: "viscosity".}
proc viscosity_contributions*(this: var AbstractState; dilute: var CoolPropDbl;
                             initial_density: var CoolPropDbl;
                             residual: var CoolPropDbl; critical: var CoolPropDbl) {.
    importcpp: "viscosity_contributions".}
  ## / Return the thermal conductivity in W/m/K
proc conductivity*(this: var AbstractState): cdouble {.importcpp: "conductivity".}
proc conductivity_contributions*(this: var AbstractState; dilute: var CoolPropDbl;
                                initial_density: var CoolPropDbl;
                                residual: var CoolPropDbl;
                                critical: var CoolPropDbl) {.
    importcpp: "conductivity_contributions".}
  ## / Return the surface tension in N/m
proc surface_tension*(this: var AbstractState): cdouble {.
    importcpp: "surface_tension".}
proc Prandtl*(this: var AbstractState): cdouble {.importcpp: "Prandtl".}
  ## *
  ##  @brief Find the conformal state needed for ECS
  ##  @param reference_fluid The reference fluid for which the conformal state will be calculated
  ##  @param T Temperature (initial guess must be provided, or < 0 to start with unity shape factors)
  ##  @param rhomolar Molar density (initial guess must be provided, or < 0 to start with unity shape factors)
  ##
proc conformal_state*(this: var AbstractState; reference_fluid: string;
                     T: var CoolPropDbl; rhomolar: var CoolPropDbl) {.
    importcpp: "conformal_state".}
  ## / \brief Change the equation of state for a given component to a specified EOS
  ## / @param i Index of the component to change (if a pure fluid, i=0)
  ## / @param EOS_name Name of the EOS to use (something like "SRK", "PR", "XiangDeiters", but backend-specific)
  ## / \note Calls the calc_change_EOS function of the implementation
proc change_EOS*(this: var AbstractState; i: uint; EOS_name: string) {.
    importcpp: "change_EOS".}
proc alpha0*(this: var AbstractState): CoolPropDbl {.importcpp: "alpha0".}
  ## / Return the term \f$ \alpha^0_{\delta} \f$
proc dalpha0_dDelta*(this: var AbstractState): CoolPropDbl {.
    importcpp: "dalpha0_dDelta".}
  ## / Return the term \f$ \alpha^0_{\tau} \f$
proc dalpha0_dTau*(this: var AbstractState): CoolPropDbl {.importcpp: "dalpha0_dTau".}
  ## / Return the term \f$ \alpha^0_{\delta\delta} \f$
proc d2alpha0_dDelta2*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d2alpha0_dDelta2".}
  ## / Return the term \f$ \alpha^0_{\delta\tau} \f$
proc d2alpha0_dDelta_dTau*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d2alpha0_dDelta_dTau".}
  ## / Return the term \f$ \alpha^0_{\tau\tau} \f$
proc d2alpha0_dTau2*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d2alpha0_dTau2".}
  ## / Return the term \f$ \alpha^0_{\tau\tau\tau} \f$
proc d3alpha0_dTau3*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alpha0_dTau3".}
  ## / Return the term \f$ \alpha^0_{\delta\tau\tau} \f$
proc d3alpha0_dDelta_dTau2*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alpha0_dDelta_dTau2".}
  ## / Return the term \f$ \alpha^0_{\delta\delta\tau} \f$
proc d3alpha0_dDelta2_dTau*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alpha0_dDelta2_dTau".}
  ## / Return the term \f$ \alpha^0_{\delta\delta\delta} \f$
proc d3alpha0_dDelta3*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alpha0_dDelta3".}
  ## / Return the term \f$ \alpha^r \f$
proc alphar*(this: var AbstractState): CoolPropDbl {.importcpp: "alphar".}
  ## / Return the term \f$ \alpha^r_{\delta} \f$
proc dalphar_dDelta*(this: var AbstractState): CoolPropDbl {.
    importcpp: "dalphar_dDelta".}
  ## / Return the term \f$ \alpha^r_{\tau} \f$
proc dalphar_dTau*(this: var AbstractState): CoolPropDbl {.importcpp: "dalphar_dTau".}
  ## / Return the term \f$ \alpha^r_{\delta\delta} \f$
proc d2alphar_dDelta2*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d2alphar_dDelta2".}
  ## / Return the term \f$ \alpha^r_{\delta\tau} \f$
proc d2alphar_dDelta_dTau*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d2alphar_dDelta_dTau".}
  ## / Return the term \f$ \alpha^r_{\tau\tau} \f$
proc d2alphar_dTau2*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d2alphar_dTau2".}
  ## / Return the term \f$ \alpha^r_{\delta\delta\delta} \f$
proc d3alphar_dDelta3*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alphar_dDelta3".}
  ## / Return the term \f$ \alpha^r_{\delta\delta\tau} \f$
proc d3alphar_dDelta2_dTau*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alphar_dDelta2_dTau".}
  ## / Return the term \f$ \alpha^r_{\delta\tau\tau} \f$
proc d3alphar_dDelta_dTau2*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alphar_dDelta_dTau2".}
  ## / Return the term \f$ \alpha^r_{\tau\tau\tau} \f$
proc d3alphar_dTau3*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d3alphar_dTau3".}
  ## / Return the term \f$ \alpha^r_{\delta\delta\delta\delta} \f$
proc d4alphar_dDelta4*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d4alphar_dDelta4".}
  ## / Return the term \f$ \alpha^r_{\delta\delta\delta\tau} \f$
proc d4alphar_dDelta3_dTau*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d4alphar_dDelta3_dTau".}
  ## / Return the term \f$ \alpha^r_{\delta\delta\tau\tau} \f$
proc d4alphar_dDelta2_dTau2*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d4alphar_dDelta2_dTau2".}
  ## / Return the term \f$ \alpha^r_{\delta\tau\tau\tau} \f$
proc d4alphar_dDelta_dTau3*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d4alphar_dDelta_dTau3".}
  ## / Return the term \f$ \alpha^r_{\tau\tau\tau\tau} \f$
proc d4alphar_dTau4*(this: var AbstractState): CoolPropDbl {.
    importcpp: "d4alphar_dTau4".}
## * An abstract AbstractState generator class
##
##   This class should be derived and statically initialized in a C++ file.  In the initializer,
##   the register_backend function should be called.  This will register the backend family, and
##   when this generator is looked up in the map, the get_AbstractState function will be used
##   to return an initialized instance
##

type
  AbstractStateGenerator* {.importcpp: "CoolProp::AbstractStateGenerator", bycopy.} = object


proc get_AbstractState*(this: var AbstractStateGenerator;
                       fluid_names: CppVector[string]): ptr AbstractState {.
    importcpp: "get_AbstractState".}
proc destroyAbstractStateGenerator*(this: var AbstractStateGenerator) {.
    importcpp: "#.~AbstractStateGenerator()".}
## * Register a backend in the backend library (statically defined in AbstractState.cpp and not
##   publicly accessible)
##

proc register_backend*(bf: backend_families;
                       gen: CppSharedPtr[AbstractStateGenerator]) {.
     importcpp: "CoolProp::register_backend(@)".}

type
  GeneratorInitializer*[T] {.importcpp: "CoolProp::GeneratorInitializer<\'0>", bycopy.} = object


proc constructGeneratorInitializer*[T](bf: backend_families): GeneratorInitializer[
    T] {.constructor, importcpp: "CoolProp::GeneratorInitializer<\'*0>(@)".}
##  namespace CoolProp
{.pop.}