##
## This header file includes the high level API that is meant to be accessed via C++.  Functions may accept C++ types like std::vector
##
## For the C-style wrapper, refer to CoolPropLib.h
##
## \sa CoolPropLib.h
##
## ! \mainpage CoolProp Core Code Documentation
##
## Welcome to the home page for the C++ sources of CoolProp.  This information may be useful for developers or just the plain inquisitive
##
## You might want to start by looking at CoolProp.h
##

#import
#  DataStructures

## / Return a value that does not depend on the thermodynamic state - this is a convenience function that does the call PropsSI(Output, "", 0, "", 0, FluidName)
## / @param FluidName The fluid name
## / @param Output The output parameter, one of "Tcrit","D","H",etc.

proc Props1SI*(FluidName: string; Output: string): cdouble {.
    importcpp: "CoolProp::Props1SI(@)", header: "CoolProp.h".}
## *
##  @brief  Get a matrix of outputs that do not depend on the thermodynamic state - this is a convenience function that does the call PropsSImulti(Outputs, "", {0}, "", {0}, backend, fluids, fractions)
##  @param Outputs A vector of strings for the output parameters
##  @param backend The string representation of the backend (HEOS, REFPROP, INCOMP, etc.)
##  @param fluids The fluid name(s)
##  @param fractions The fractions (molar, mass, volume, etc.) of the components
##

proc Props1SImulti*(Outputs: vector[string]; backend: string; fluids: vector[string];
                   fractions: vector[cdouble]): vector[vector[cdouble]] {.
    importcpp: "CoolProp::Props1SImulti(@)", header: "CoolProp.h".}
## / Return a value that depends on the thermodynamic state
## / @param Output The output parameter, one of "T","D","H",etc.
## / @param Name1 The first state variable name, one of "T","D","H",etc.
## / @param Prop1 The first state variable value
## / @param Name2 The second state variable name, one of "T","D","H",etc.
## / @param Prop2 The second state variable value
## / @param FluidName The fluid name

proc PropsSI*(Output: string; Name1: string; Prop1: cdouble; Name2: string;
             Prop2: cdouble; FluidName: string): cdouble {.
    importcpp: "CoolProp::PropsSI(@)", header: "CoolProp.h".}
## *
##  @brief Get a matrix of outputs for a given input.  Can handle both vector inputs as well as a vector of output strings
##  @param Outputs A vector of strings for the output parameters
##  @param Name1 The name of the first input variable
##  @param Prop1 A vector of the first input values
##  @param Name2 The name of the second input variable
##  @param Prop2 A vector of the second input values
##  @param backend The string representation of the backend (HEOS, REFPROP, INCOMP, etc.)
##  @param fluids The fluid name(s)
##  @param fractions The fractions (molar, mass, volume, etc.) of the components
##

proc PropsSImulti*(Outputs: vector[string]; Name1: string; Prop1: vector[cdouble];
                  Name2: string; Prop2: vector[cdouble]; backend: string;
                  fluids: vector[string]; fractions: vector[cdouble]): vector[
    vector[cdouble]] {.importcpp: "CoolProp::PropsSImulti(@)", header: "CoolProp.h".}
## / Get the debug level
## / @returns level The level of the verbosity for the debugging output (0-10) 0: no debgging output

proc get_debug_level*(): cint {.importcpp: "CoolProp::get_debug_level(@)",
                             header: "CoolProp.h".}
## / Set the debug level
## / @param level The level of the verbosity for the debugging output (0-10) 0: no debgging output

proc set_debug_level*(level: cint) {.importcpp: "CoolProp::set_debug_level(@)",
                                  header: "CoolProp.h".}
## / Set the global error string
## / @param error The error string to use

proc set_error_string*(error: string) {.importcpp: "CoolProp::set_error_string(@)",
                                     header: "CoolProp.h".}
## / An internal function to set the global warning string
## / @param warning The string to set as the warning string

proc set_warning_string*(warning: string) {.
    importcpp: "CoolProp::set_warning_string(@)", header: "CoolProp.h".}
##  \brief Extract a value from the saturation ancillary
##
##  @param fluid_name The name of the fluid to be used - HelmholtzEOS backend only
##  @param output The desired output variable ("P" for instance for pressure)
##  @param Q The quality, 0 or 1
##  @param input The input variable ("T")
##  @param value The input value
##

proc saturation_ancillary*(fluid_name: string; output: string; Q: cint; input: string;
                          value: cdouble): cdouble {.
    importcpp: "CoolProp::saturation_ancillary(@)", header: "CoolProp.h".}
## / Get a globally-defined string
## / @param ParamName A string, one of "version", "errstring", "warnstring", "gitrevision", "FluidsList", "fluids_list", "parameter_list","predefined_mixtures"
## / @returns str The string, or an error message if not valid input

proc get_global_param_string*(ParamName: string): string {.
    importcpp: "CoolProp::get_global_param_string(@)", header: "CoolProp.h".}
## /// Get a long that represents the fluid type
##     /// @param FluidName The fluid name as a string
##     /// @returns long element from global type enumeration
##     long getFluidType(std::string FluidName);
## *
##     \brief Get a string for a value from a fluid (numerical values for the fluid can be obtained from Props1SI function)
##
##     @param FluidName The name of the fluid that is part of CoolProp, for instance "n-Propane"
##     @param ParamName A string, can be in one of the terms described in the following table
##
##     ParamName                    | Description
##     --------------------------   | ----------------------------------------
##     "aliases"                    | A comma separated list of aliases for the fluid
##     "CAS", "CAS_number"          | The CAS number
##     "ASHRAE34"                   | The ASHRAE standard 34 safety rating
##     "REFPROPName","REFPROP_name" | The name of the fluid used in REFPROP
##     "Bibtex-XXX"                 | A BibTeX key, where XXX is one of the bibtex keys used in get_BibTeXKey
##     "pure"                       | "true" if the fluid is pure, "false" otherwise
##     "formula"                    | The chemical formula of the fluid in LaTeX form if available, "" otherwise
##
##     @returns The string, or an error message if not valid input
##

proc get_fluid_param_string*(FluidName: string; ParamName: string): string {.
    importcpp: "CoolProp::get_fluid_param_string(@)", header: "CoolProp.h".}
## * \brief Check if the fluid name is valid
##
##  @returns output Returns true if the fluid string is valid
##
##  \note "gfreilgregre" -> false; "HEOS::Water" -> true; "Water" -> true
##
##

proc is_valid_fluid_string*(fluidstring: string): bool {.
    importcpp: "CoolProp::is_valid_fluid_string(@)", header: "CoolProp.h".}
## * \brief Add fluids as a JSON-formatted string
##
##  @param backend The backend to which these should be added; e.g. "HEOS", "SRK", "PR"
##  @returns output Returns true if the fluids were able to be added
##
##

proc add_fluids_as_JSON*(backend: string; fluidstring: string): bool {.
    importcpp: "CoolProp::add_fluids_as_JSON(@)", header: "CoolProp.h".}
## *
##     \brief Set the reference state based on a string representation
##
##     @param FluidName The name of the fluid (Backend can be provided like "REFPROP::Water", or if no backend is provided, "HEOS" is the assumed backend)
##     @param reference_state The reference state to use, one of
##
##     Reference State | Description
##     -------------   | -------------------
##     "IIR"           | h = 200 kJ/kg, s=1 kJ/kg/K at 0C saturated liquid
##     "ASHRAE"        | h = 0, s = 0 @ -40C saturated liquid
##     "NBP"           | h = 0, s = 0 @ 1.0 bar saturated liquid
##     "DEF"           | Reset to the default reference state for the fluid
##     "RESET"         | Remove the offset
##
##     The offset in the ideal gas Helmholtz energy can be obtained from
##     \f[
##     \displaystyle\frac{\Delta s}{R_u/M}+\frac{\Delta h}{(R_u/M)T}\tau
##     \f]
##     where \f$ \Delta s = s-s_{spec} \f$ and \f$ \Delta h = h-h_{spec} \f$
##

proc set_reference_stateS*(FluidName: string; reference_state: string) {.
    importcpp: "CoolProp::set_reference_stateS(@)", header: "CoolProp.h".}
## / Set the reference state based on a thermodynamic state point specified by temperature and molar density
## / @param FluidName The name of the fluid
## / @param T Temperature at reference state [K]
## / @param rhomolar Molar density at reference state [mol/m^3]
## / @param hmolar0 Molar enthalpy at reference state [J/mol]
## / @param smolar0 Molar entropy at reference state [J/mol/K]

proc set_reference_stateD*(FluidName: string; T: cdouble; rhomolar: cdouble;
                          hmolar0: cdouble; smolar0: cdouble) {.
    importcpp: "CoolProp::set_reference_stateD(@)", header: "CoolProp.h".}
## / Return a string representation of the phase
## / @param Name1 The first state variable name, one of "T","D","H",etc.
## / @param Prop1 The first state variable value
## / @param Name2 The second state variable name, one of "T","D","H",etc.
## / @param Prop2 The second state variable value
## / @param FluidName The fluid name
## / \note Returns empty string if there was an error; use get_global_param_string("errstring") to retrieve the error

proc PhaseSI*(Name1: string; Prop1: cdouble; Name2: string; Prop2: cdouble;
             FluidName: string): string {.importcpp: "CoolProp::PhaseSI(@)",
                                       header: "CoolProp.h".}
## *
##  @brief Extract the backend from a string - something like "HEOS::Water" would split to "HEOS" and "Water".  If no backend is specified, the backend will be set to "?"
##  @param fluid_string The input string
##  @param backend The output backend, if none found, "?"
##  @param fluid The output fluid string (minus the backend string)
##

proc extract_backend*(fluid_string: string; backend: var string; fluid: var string) {.
    importcpp: "CoolProp::extract_backend(@)", header: "CoolProp.h".}
## *
##  @brief Extract fractions (molar, mass, etc.) encoded in the string if any
##  @param fluid_string The input string
##  @param fractions The fractions
##  @return The fluids, as a '&' delimited string
##

proc extract_fractions*(fluid_string: string; fractions: var vector[cdouble]): string {.
    importcpp: "CoolProp::extract_fractions(@)", header: "CoolProp.h".}
## / An internal function to extract the phase string, given the phase index;
## / Handy for printing the actual phase string in debug, warning, and error messages.
## / @param Phase The enumerated phase index to be looked up

proc phase_lookup_string*(Phase: phases): string {.
    importcpp: "CoolProp::phase_lookup_string(@)", header: "CoolProp.h".}
##  namespace CoolProp
