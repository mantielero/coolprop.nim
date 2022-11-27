##
##  DataStructures.h
##
##   Created on: 21 Dec 2013
##       Author: jowr
##

#import
#  CPnumerics, Exceptions

type
  SimpleState* {.importcpp: "CoolProp::SimpleState", header: "DataStructures.h",
                bycopy.} = object of RootObj
    rhomolar* {.importc: "rhomolar".}: cdouble
    T* {.importc: "T".}: cdouble
    p* {.importc: "p".}: cdouble
    hmolar* {.importc: "hmolar".}: cdouble
    smolar* {.importc: "smolar".}: cdouble
    umolar* {.importc: "umolar".}: cdouble
    Q* {.importc: "Q".}: cdouble


proc constructSimpleState*(): SimpleState {.constructor,
    importcpp: "CoolProp::SimpleState(@)", header: "DataStructures.h".}
proc fill*(this: var SimpleState; v: cdouble) {.importcpp: "fill",
    header: "DataStructures.h".}
proc is_valid*(this: var SimpleState): bool {.importcpp: "is_valid",
    header: "DataStructures.h".}

type
  CriticalState* {.importcpp: "CoolProp::CriticalState",
                  header: "DataStructures.h", bycopy.} = object of SimpleState
    stable* {.importc: "stable".}: bool


proc constructCriticalState*(): CriticalState {.constructor,
    importcpp: "CoolProp::CriticalState(@)", header: "DataStructures.h".}
## / A modified class for the state point at the maximum saturation entropy on the vapor curve

type
  SsatSimpleState* {.importcpp: "CoolProp::SsatSimpleState",
                    header: "DataStructures.h", bycopy.} = object of SimpleState
    exists* {.importc: "exists".}: SsatSimpleStateSsatSimpleStateEnum

  SsatSimpleStateSsatSimpleStateEnum* {.size: sizeof(cint), importcpp: "CoolProp::SsatSimpleState::SsatSimpleStateEnum",
                                       header: "DataStructures.h".} = enum
    SSAT_MAX_NOT_SET = 0, SSAT_MAX_DOESNT_EXIST, SSAT_MAX_DOES_EXIST


proc constructSsatSimpleState*(): SsatSimpleState {.constructor,
    importcpp: "CoolProp::SsatSimpleState(@)", header: "DataStructures.h".}
## / --------------------------------------------------
## / Define some constants that will be used throughout
## / --------------------------------------------------
## / These are constants for the input and output parameters
## / The structure is taken directly from the AbstractState class.
##
##  !! If you add a parameter, update the map in the corresponding CPP file !!

type
  parameters* {.size: sizeof(cint), importcpp: "CoolProp::parameters",
               header: "DataStructures.h".} = enum
    INVALID_PARAMETER = 0,      ##  General parameters
    igas_constant,            ## /< Ideal-gas constant
    imolar_mass,              ## /< Molar mass
    iacentric_factor,         ## /< Acentric factor
    irhomolar_reducing,       ## /< Molar density used for the reducing state
    irhomolar_critical,       ## /< Molar density used for the critical point
    iT_reducing,              ## /< Temperature at the reducing state
    iT_critical,              ## /< Temperature at the critical point
    irhomass_reducing,        ## /< Mass density at the reducing state
    irhomass_critical,        ## /< Mass density at the critical point
    iP_critical,              ## /< Pressure at the critical point
    iP_reducing,              ## /< Pressure at the reducing point
    iT_triple,                ## /< Triple point temperature
    iP_triple,                ## /< Triple point pressure
    iT_min,                   ## /< Minimum temperature
    iT_max,                   ## /< Maximum temperature
    iP_max,                   ## /< Maximum pressure
    iP_min,                   ## /< Minimum pressure
    idipole_moment,           ## /< Dipole moment
                   ##  Bulk properties
    iT,                       ## /< Temperature
    iP,                       ## /< Pressure
    iQ,                       ## /< Vapor quality
    iTau,                     ## /< Reciprocal reduced temperature
    iDelta,                   ## /< Reduced density
           ##  Molar specific thermodynamic properties
    iDmolar,                  ## /< Mole-based density
    iHmolar,                  ## /< Mole-based enthalpy
    iSmolar,                  ## /< Mole-based entropy
    iCpmolar,                 ## /< Mole-based constant-pressure specific heat
    iCp0molar,                ## /< Mole-based ideal-gas constant-pressure specific heat
    iCvmolar,                 ## /< Mole-based constant-volume specific heat
    iUmolar,                  ## /< Mole-based internal energy
    iGmolar,                  ## /< Mole-based Gibbs energy
    iHelmholtzmolar,          ## /< Mole-based Helmholtz energy
    iHmolar_residual,         ## /< The residual molar enthalpy
    iSmolar_residual,         ## /< The residual molar entropy (as a function of temperature and density)
    iGmolar_residual,         ## /< The residual molar Gibbs energy
                     ##  Mass specific thermodynamic properties
    iDmass,                   ## /< Mass-based density
    iHmass,                   ## /< Mass-based enthalpy
    iSmass,                   ## /< Mass-based entropy
    iCpmass,                  ## /< Mass-based constant-pressure specific heat
    iCp0mass,                 ## /< Mass-based ideal-gas specific heat
    iCvmass,                  ## /< Mass-based constant-volume specific heat
    iUmass,                   ## /< Mass-based internal energy
    iGmass,                   ## /< Mass-based Gibbs energy
    iHelmholtzmass,           ## /< Mass-based Helmholtz energy
                   ##  Transport properties
    iviscosity,               ## /< Viscosity
    iconductivity,            ## /< Thermal conductivity
    isurface_tension,         ## /< Surface tension
    iPrandtl,                 ## /< The Prandtl number
             ##  Derivative-based terms
    ispeed_sound,             ## /< Speed of sound
    iisothermal_compressibility, ## /< Isothermal compressibility
    iisobaric_expansion_coefficient, ## /< Isobaric expansion coefficient
    iisentropic_expansion_coefficient, ## /< Isentropic expansion coefficient
                                      ##  Fundamental derivative of gas dynamics
    ifundamental_derivative_of_gas_dynamics, ## /< The fundamental derivative of gas dynamics
                                            ##  Derivatives of the residual non-dimensionalized Helmholtz energy with respect to the EOS variables
    ialphar, idalphar_dtau_constdelta, idalphar_ddelta_consttau, ##  Derivatives of the ideal-gas non-dimensionalized Helmholtz energy with respect to the EOS variables
    ialpha0, idalpha0_dtau_constdelta, idalpha0_ddelta_consttau,
    id2alpha0_ddelta2_consttau, id3alpha0_ddelta3_consttau, ##  Other functions and derivatives
    iBvirial,                 ## /< Second virial coefficient
    iCvirial,                 ## /< Third virial coefficient
    idBvirial_dT,             ## /< Derivative of second virial coefficient with temperature
    idCvirial_dT,             ## /< Derivative of third virial coefficient with temperature
    iZ,                       ## /< The compressibility factor Z = p*v/(R*T)
    iPIP, ## /< The phase identification parameter of Venkatarathnam and Oellrich
         ##  Accessors for incompressibles
    ifraction_min,            ## /< The minimum fraction (mole, mass, volume) for incompressibles
    ifraction_max,            ## /< The maximum fraction (mole,mass,volume) for incompressibles
    iT_freeze,                ## /< The freezing temperature for incompressibles
              ##  Environmental parameters
    iGWP20,                   ## /< The 20-year global warming potential
    iGWP100,                  ## /< The 100-year global warming potential
    iGWP500,                  ## /< The 500-year global warming potential
    iFH,                      ## /< Fire hazard index
    iHH,                      ## /< Health hazard index
    iPH,                      ## /< Physical hazard index
    iODP,                     ## /< Ozone depletion potential (R-11 = 1.0)
    iPhase,                   ## /< The phase index of the given state
    iundefined_parameter      ## /< The last parameter, so we can check that all parameters are described in DataStructures.cpp


##  !! If you add a parameter, update the map in the corresponding CPP file !!
##  !! Also update phase_lookup_string() in CoolProp.cpp                    !!
## / These are constants for the phases of the fluid

type
  phases* {.size: sizeof(cint), importcpp: "CoolProp::phases",
           header: "DataStructures.h".} = enum
    iphase_liquid,            ## /< Subcritical liquid
    iphase_supercritical,     ## /< Supercritical (p > pc, T > Tc)
    iphase_supercritical_gas, ## /< Supercritical gas (p < pc, T > Tc)
    iphase_supercritical_liquid, ## /< Supercritical liquid (p > pc, T < Tc)
    iphase_critical_point,    ## /< At the critical point
    iphase_gas,               ## /< Subcritical gas
    iphase_twophase,          ## /< Twophase
    iphase_unknown,           ## /< Unknown phase
    iphase_not_imposed


## /< Phase is not imposed
## / Constants for the different PC-SAFT association schemes (see Huang and Radosz 1990)

type
  schemes* {.size: sizeof(cint), importcpp: "CoolProp::schemes",
            header: "DataStructures.h".} = enum
    i1, i2a, i2b, i3a, i3b, i4a, i4b, i4c


## / Return information about the parameter
## / @param key The key, one of iT, iP, etc.
## / @param info The thing you want, one of "IO" ("IO" if input/output, "O" if output only), "short" (very short description), "long" (a longer description), "units"

proc get_parameter_information*(key: cint; info: string): string {.
    importcpp: "CoolProp::get_parameter_information(@)",
    header: "DataStructures.h".}
## / Return the enum key corresponding to the parameter name ("Dmolar" for instance)

proc get_parameter_index*(param_name: string): parameters {.
    importcpp: "CoolProp::get_parameter_index(@)", header: "DataStructures.h".}
## / Return true if passed phase name is valid, otherwise false
## / @param phase_name The phase name string to be checked ("phase_liquid" for instance)
## / @param iOutput Gets updated with the phases enum value if phase_name is found

proc is_valid_phase*(phase_name: string; iOutput: var phases): bool {.
    importcpp: "CoolProp::is_valid_phase(@)", header: "DataStructures.h".}
## / Return the enum key corresponding to the phase name ("phase_liquid" for instance)

proc get_phase_index*(param_name: string): phases {.
    importcpp: "CoolProp::get_phase_index(@)", header: "DataStructures.h".}
## / Return true if passed PC-SAFT association scheme name is valid, otherwise false
## / @param scheme_name The association scheme string to be checked ("2B" for instance)
## / @param iOutput Gets updated with the schemes enum value if scheme_name is found

proc is_valid_scheme*(scheme_name: string; iOutput: var schemes): bool {.
    importcpp: "CoolProp::is_valid_scheme(@)", header: "DataStructures.h".}
## / Return the enum key corresponding to the association scheme name ("2B" for instance)

proc get_scheme_index*(scheme_name: string): schemes {.
    importcpp: "CoolProp::get_scheme_index(@)", header: "DataStructures.h".}
## / Returns true if the input is trivial (constants, critical parameters, etc.)

proc is_trivial_parameter*(key: cint): bool {.
    importcpp: "CoolProp::is_trivial_parameter(@)", header: "DataStructures.h".}
## / Returns true if a valid parameter, and sets value in the variable iOutput

proc is_valid_parameter*(name: string; iOutput: var parameters): bool {.
    importcpp: "CoolProp::is_valid_parameter(@)", header: "DataStructures.h".}
## / Returns true if the string corresponds to a valid first derivative
## /
## / If it is a value derivative, the variables are set to the parts of the derivative

proc is_valid_first_derivative*(name: string; iOf: var parameters;
                               iWrt: var parameters; iConstant: var parameters): bool {.
    importcpp: "CoolProp::is_valid_first_derivative(@)",
    header: "DataStructures.h".}
## / Returns true if the string corresponds to a valid first saturation derivative - e.g. "d(P)/d(T)|sigma" for instance
## /
## / If it is a valid derivative, the variables are set to the parts of the derivative

proc is_valid_first_saturation_derivative*(name: string; iOf: var parameters;
    iWrt: var parameters): bool {.importcpp: "CoolProp::is_valid_first_saturation_derivative(@)",
                              header: "DataStructures.h".}
## / Returns true if the string corresponds to a valid second derivative
## /
## / If it is a value derivative, the variables are set to the parts of the derivative

proc is_valid_second_derivative*(name: string; iOf1: var parameters;
                                iWrt1: var parameters; iConstant1: var parameters;
                                iWrt2: var parameters; iConstant2: var parameters): bool {.
    importcpp: "CoolProp::is_valid_second_derivative(@)",
    header: "DataStructures.h".}
## / Get a comma separated list of parameters

proc get_csv_parameter_list*(): string {.importcpp: "CoolProp::get_csv_parameter_list(@)",
                                      header: "DataStructures.h".}
## / These are constants for the compositions

type
  composition_types* {.size: sizeof(cint),
                      importcpp: "CoolProp::composition_types",
                      header: "DataStructures.h".} = enum
    IFRAC_MASS, IFRAC_MOLE, IFRAC_VOLUME, IFRAC_UNDEFINED, IFRAC_PURE


## / These are unit types for the fluid

type
  fluid_types* {.size: sizeof(cint), importcpp: "CoolProp::fluid_types",
                header: "DataStructures.h".} = enum
    FLUID_TYPE_PURE, FLUID_TYPE_PSEUDOPURE, FLUID_TYPE_REFPROP,
    FLUID_TYPE_INCOMPRESSIBLE_LIQUID, FLUID_TYPE_INCOMPRESSIBLE_SOLUTION,
    FLUID_TYPE_UNDEFINED


##  !! If you add a parameter, update the map in the corresponding CPP file !!
## / These are input pairs that can be used for the update function (in each pair, input keys are sorted alphabetically)

type
  input_pairs* {.size: sizeof(cint), importcpp: "CoolProp::input_pairs",
                header: "DataStructures.h".} = enum
    INPUT_PAIR_INVALID = 0,     ##  Default (invalid) value
    QT_INPUTS,                ## /< Molar quality, Temperature in K
    PQ_INPUTS,                ## /< Pressure in Pa, Molar quality
    QSmolar_INPUTS,           ## /< Molar quality, Entropy in J/mol/K
    QSmass_INPUTS,            ## /< Molar quality, Entropy in J/kg/K
    HmolarQ_INPUTS,           ## /< Enthalpy in J/mol, Molar quality
    HmassQ_INPUTS,            ## /< Enthalpy in J/kg, Molar quality
    DmolarQ_INPUTS,           ## /< Density in mol/m^3, Molar quality
    DmassQ_INPUTS,            ## /< Density in kg/m^3, Molar quality
    PT_INPUTS,                ## /< Pressure in Pa, Temperature in K
    DmassT_INPUTS,            ## /< Mass density in kg/m^3, Temperature in K
    DmolarT_INPUTS,           ## /< Molar density in mol/m^3, Temperature in K
    HmolarT_INPUTS,           ## /< Enthalpy in J/mol, Temperature in K
    HmassT_INPUTS,            ## /< Enthalpy in J/kg, Temperature in K
    SmolarT_INPUTS,           ## /< Entropy in J/mol/K, Temperature in K
    SmassT_INPUTS,            ## /< Entropy in J/kg/K, Temperature in K
    TUmolar_INPUTS,           ## /< Temperature in K, Internal energy in J/mol
    TUmass_INPUTS,            ## /< Temperature in K, Internal energy in J/kg
    DmassP_INPUTS,            ## /< Mass density in kg/m^3, Pressure in Pa
    DmolarP_INPUTS,           ## /< Molar density in mol/m^3, Pressure in Pa
    HmassP_INPUTS,            ## /< Enthalpy in J/kg, Pressure in Pa
    HmolarP_INPUTS,           ## /< Enthalpy in J/mol, Pressure in Pa
    PSmass_INPUTS,            ## /< Pressure in Pa, Entropy in J/kg/K
    PSmolar_INPUTS,           ## /< Pressure in Pa, Entropy in J/mol/K
    PUmass_INPUTS,            ## /< Pressure in Pa, Internal energy in J/kg
    PUmolar_INPUTS,           ## /< Pressure in Pa, Internal energy in J/mol
    HmassSmass_INPUTS,        ## /< Enthalpy in J/kg, Entropy in J/kg/K
    HmolarSmolar_INPUTS,      ## /< Enthalpy in J/mol, Entropy in J/mol/K
    SmassUmass_INPUTS,        ## /< Entropy in J/kg/K, Internal energy in J/kg
    SmolarUmolar_INPUTS,      ## /< Entropy in J/mol/K, Internal energy in J/mol
    DmassHmass_INPUTS,        ## /< Mass density in kg/m^3, Enthalpy in J/kg
    DmolarHmolar_INPUTS,      ## /< Molar density in mol/m^3, Enthalpy in J/mol
    DmassSmass_INPUTS,        ## /< Mass density in kg/m^3, Entropy in J/kg/K
    DmolarSmolar_INPUTS,      ## /< Molar density in mol/m^3, Entropy in J/mol/K
    DmassUmass_INPUTS,        ## /< Mass density in kg/m^3, Internal energy in J/kg
    DmolarUmolar_INPUTS       ## /< Molar density in mol/m^3, Internal energy in J/mol


##  !! If you add or remove a parameter, update the map in the corresponding CPP file !!

proc match_pair*(key1: parameters; key2: parameters; x1: parameters; x2: parameters;
                swap: var bool): bool =
  discard


proc generate_update_pair*[T](key1: parameters; value1: T; 
                              key2: parameters; value2: T;
                              out1: var T; out2: var T): input_pairs {.
    importcpp: "CoolProp::generate_update_pair(@)",
    header: "DataStructures.h".}
    ## *
    ##  @brief Generate an update pair from key, value pairs
    ##
    ##  If the input pair is valid, v1 and v2 will correspond to the returned output pair
    ##
    ##  @param key1 The first input key
    ##  @param value1 The first input value
    ##  @param key2 The second input key
    ##  @param value2 The second input value
    ##  @param out1 The first output value
    ##  @param out2 The second output value
    ##  @return pair, or INPUT_PAIR_INVALID if not valid
    ##


## / Get the input pair index associated with its string representation

proc get_input_pair_index*(input_pair_name: string): input_pairs {.
    importcpp: "CoolProp::get_input_pair_index(@)", header: "DataStructures.h".}


## / Return the short description of an input pair key ("DmolarT_INPUTS" for instance)

proc get_input_pair_short_desc*(pair: input_pairs): var string {.
    importcpp: "CoolProp::get_input_pair_short_desc(@)",
    header: "DataStructures.h".}
## / Return the long description of an input pair key ("Molar density in mol/m^3, Temperature in K" for instance)

proc get_input_pair_long_desc*(pair: input_pairs): var string {.
    importcpp: "CoolProp::get_input_pair_long_desc(@)", header: "DataStructures.h".}
## / Split an input pair into parameters for the two parts that form the pair

proc split_input_pair*(pair: input_pairs; p1: var parameters; p2: var parameters) {.
    importcpp: "CoolProp::split_input_pair(@)", header: "DataStructures.h".}
proc get_mixture_binary_pair_data*(CAS1: string; CAS2: string; param: string): string {.
    importcpp: "CoolProp::get_mixture_binary_pair_data(@)",
    header: "DataStructures.h".}
proc set_mixture_binary_pair_data*(CAS1: string; CAS2: string; param: string;
                                  val: cdouble) {.
    importcpp: "CoolProp::set_mixture_binary_pair_data(@)",
    header: "DataStructures.h".}
proc get_mixture_binary_pair_pcsaft*(CAS1: string; CAS2: string; param: string): string {.
    importcpp: "CoolProp::get_mixture_binary_pair_pcsaft(@)",
    header: "DataStructures.h".}
proc set_mixture_binary_pair_pcsaft*(CAS1: string; CAS2: string; param: string;
                                    val: cdouble) {.
    importcpp: "CoolProp::set_mixture_binary_pair_pcsaft(@)",
    header: "DataStructures.h".}
## / The structure is taken directly from the AbstractState class.
##  !! If you add a parameter, update the map in the corresponding CPP file !!

type
  backend_families* {.size: sizeof(cint), importcpp: "CoolProp::backend_families",
                     header: "DataStructures.h".} = enum
    INVALID_BACKEND_FAMILY = 0, HEOS_BACKEND_FAMILY, REFPROP_BACKEND_FAMILY,
    INCOMP_BACKEND_FAMILY, IF97_BACKEND_FAMILY, TREND_BACKEND_FAMILY,
    TTSE_BACKEND_FAMILY, BICUBIC_BACKEND_FAMILY, SRK_BACKEND_FAMILY,
    PR_BACKEND_FAMILY, VTPR_BACKEND_FAMILY, PCSAFT_BACKEND_FAMILY


type
  backends* {.size: sizeof(cint), importcpp: "CoolProp::backends",
             header: "DataStructures.h".} = enum
    INVALID_BACKEND = 0, HEOS_BACKEND_PURE, HEOS_BACKEND_MIX, REFPROP_BACKEND_PURE,
    REFPROP_BACKEND_MIX, INCOMP_BACKEND, IF97_BACKEND, TREND_BACKEND, TTSE_BACKEND,
    BICUBIC_BACKEND, SRK_BACKEND, PR_BACKEND, VTPR_BACKEND, PCSAFT_BACKEND


## / Convert a string into the enum values

proc extract_backend_families*(backend_string: string; f1: var backend_families;
                              f2: var backend_families) {.
    importcpp: "CoolProp::extract_backend_families(@)", header: "DataStructures.h".}
proc extract_backend_families_string*(backend_string: string;
                                     f1: var backend_families; f2: var string) {.
    importcpp: "CoolProp::extract_backend_families_string(@)",
    header: "DataStructures.h".}
proc get_backend_string*(backend: backends): string {.
    importcpp: "CoolProp::get_backend_string(@)", header: "DataStructures.h".}
##  namespace CoolProp
