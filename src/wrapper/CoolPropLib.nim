{.passL:"-lCoolProp -ldl".}
{.passC:"-std=c++11 -Wall -O2 -DCOOLPROP_LIB  -I/usr/include/fmt -I/usr/include/CoolProp".}
# http://www.coolprop.org/coolprop/wrappers/SharedLibrary/index.html

{.push header: "CoolPropLib.h".}

proc Props1SI*(FluidName: cstring; Output: cstring): cdouble {.
    importcpp: "Props1SI(@)".}
## *
## \overload
## \sa \ref CoolProp::Props1SImulti(const std::vector<std::string>& Outputs, const std::string& backend, const std::vector<std::string>& fluids, const std::vector<double>& fractions)
##
##  \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc Props1SImulti*(Outputs: cstring; backend: cstring; FluidNames: cstring;
                   fractions: ptr cdouble; length_fractions: clong;
                   result: ptr cdouble; resdim1: ptr clong) {.
    importcpp: "Props1SImulti(@)".}
## *
## \overload
## \sa \ref CoolProp::PropsSI(const std::string &, const std::string &, double, const std::string &, double, const std::string&)
##
##  \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##


proc PropsSI*(Output: cstring; Name1: cstring; Prop1: cdouble; Name2: cstring;
             Prop2: cdouble; Ref: cstring): cdouble {.importcpp: "PropsSI(@)".}    

## *
## \overload
## \sa \ref CoolProp::PropsSImulti(const std::vector<std::string>& Outputs, const std::string& Name1, const std::vector<double>& Prop1,
##                                               const std::string& Name2, const std::vector<double>& Prop2, const std::string& backend,
##                                               const std::vector<std::string>& fluids, const std::vector<double>& fractions)
##
##  @param Outputs Delimited string separated by LIST_STRING_DELIMITER for the output parameters
##  @param Name1 The name of the first input variable
##  @param Prop1 A vector of the first input values
##  @param size_Prop1 Size of Prop1 double*
##  @param Name2 The name of the second input variable
##  @param Prop2 A vector of the second input values
##  @param size_Prop2 Size of Prop2 double*
##  @param backend 	The string representation of the backend (HEOS, REFPROP, INCOMP, etc.)
##  @param FluidNames  Delimited string separated by LIST_STRING_DELIMITER for the fluid name(s)
##  @param fractions The fractions (molar, mass, volume, etc.) of the components
##  @param length_fractions Size of fractions double*
##  @param result Allocated memory for result vector
##  @param resdim1 result vector dimension 1 pointer, to check allocated space and return actual result size
##  @param resdim2 result vector dimension 2 pointer, to check allocated space and return actual result size
##  \note If there is an error, an empty vector will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc PropsSImulti*(Outputs: cstring; 
                   Name1: cstring; Prop1: ptr cdouble; size_Prop1: clong; 
                   Name2: cstring; Prop2: ptr cdouble; size_Prop2: clong; 
                   backend: cstring; FluidNames: cstring;
                   fractions: ptr cdouble; length_fractions: clong;
                   result: ptr cdouble; resdim1: ptr clong; resdim2: ptr clong) {.
    importcpp: "PropsSImulti(@)".}
## *
## \overload
## \sa \ref CoolProp::PhaseSI(const std::string &, double, const std::string &, double, const std::string&)
##
##  \note This function returns the phase string in pre-allocated phase variable.  If buffer is not large enough, no copy is made
##

proc PhaseSI*(Name1: cstring; Prop1: cdouble; Name2: cstring; Prop2: cdouble;
             Ref: cstring; phase: cstring; n: cint): clong {.importcpp: "PhaseSI(@)" .}
## *
## \overload
## \sa \ref CoolProp::get_global_param_string
##
##  @returns error_code 1 = Ok 0 = error
##
##  \note This function returns the output string in pre-allocated char buffer.  If buffer is not large enough, no copy is made
##

proc get_global_param_string*(param: cstring; Output: cstring; n: cint): clong {.
    importcpp: "get_global_param_string(@)".}
## *
##  \overload
##  \sa \ref CoolProp::get_parameter_information_string
##  \note This function returns the output string in pre-allocated char buffer.  If buffer is not large enough, no copy is made
##
##  @returns error_code 1 = Ok 0 = error
##

proc get_parameter_information_string*(key: cstring; Output: cstring; n: cint): clong {.
    importcpp: "get_parameter_information_string(@)".}
## *
##  \overload
##  \sa \ref CoolProp::get_fluid_param_string
##
##  @returns error_code 1 = Ok 0 = error
##

proc get_fluid_param_string*(fluid: cstring; param: cstring; Output: cstring; n: cint): clong {.
    importcpp: "get_fluid_param_string(@)".}
## * \brief Set configuration string
##  @param key The key to configure
##  @param val The value to set to the key
##  \note you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc set_config_string*(key: cstring; val: cstring) {.
    importcpp: "set_config_string(@)".}
## * \brief Set configuration numerical value as double
##  @param key The key to configure
##  @param val The value to set to the key
##  \note you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc set_config_double*(key: cstring; val: cdouble) {.
    importcpp: "set_config_double(@)".}
## * \brief Set configuration value as a boolean
##  @param key The key to configure
##  @param val The value to set to the key
##  \note you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc set_config_bool*(key: cstring; val: bool) {.importcpp: "set_config_bool(@)".}
## *
##  @brief Set the departure functions in the departure function library from a string format
##  @param string_data The departure functions to be set, either provided as a JSON-formatted string
##                     or as a string of the contents of a HMX.BNC file from REFPROP
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##
##  @note By default, if a departure function already exists in the library, this is an error,
##        unless the configuration variable OVERWRITE_DEPARTURE_FUNCTIONS is set to true
##

proc set_departure_functions*(string_data: cstring; errcode: ptr clong;
                             message_buffer: cstring; buffer_length: clong) {.
    importcpp: "set_departure_functions(@)".}
## *
##  \overload
##  \sa \ref CoolProp::set_reference_stateS
##  @returns error_code 1 = Ok 0 = error
##

proc set_reference_stateS*(Ref: cstring; reference_state: cstring): cint {.
    importcpp: "set_reference_stateS(@)".}
## *
##  \overload
##  \sa \ref CoolProp::set_reference_stateD
##  @returns error_code 1 = Ok 0 = error
##

proc set_reference_stateD*(Ref: cstring; T: cdouble; rhomolar: cdouble;
                          hmolar0: cdouble; smolar0: cdouble): cint {.
    importcpp: "set_reference_stateD(@)".}
## * \brief FORTRAN 77 style wrapper of the PropsSI function
##  \overload
##  \sa \ref CoolProp::PropsSI(const std::string &, const std::string &, double, const std::string &, double, const std::string&)
##
##  \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc propssi*(Output: cstring; Name1: cstring; Prop1: ptr cdouble; Name2: cstring;
              Prop2: ptr cdouble; Ref: cstring; output: ptr cdouble) {.
    importcpp: "propssi_(@)".}
## / Convert from degrees Fahrenheit to Kelvin (useful primarily for testing)

proc F2K*(T_F: cdouble): cdouble {.importcpp: "F2K(@)".}
## / Convert from Kelvin to degrees Fahrenheit (useful primarily for testing)

proc K2F*(T_K: cdouble): cdouble {.importcpp: "K2F(@)".}
## * \brief Get the index for a parameter "T", "P", etc.
##
##  @returns index The index as a long.  If input is invalid, returns -1
##

proc get_param_index*(param: cstring): clong {.importcpp: "get_param_index(@)".}
## * \brief Get the index for an input pair for AbstractState.update function
##
##  @returns index The index as a long.  If input is invalid, returns -1
##

proc get_input_pair_index*(param: cstring): clong {.
    importcpp: "get_input_pair_index(@)".}
## * \brief Redirect all output that would go to console (stdout) to a file
##

proc redirect_stdout*(file: cstring): clong {.importcpp: "redirect_stdout(@)".}
##  ---------------------------------
##  Getter and setter for debug level
##  ---------------------------------
## / Get the debug level
## / @returns level The level of the verbosity for the debugging output (0-10) 0: no debgging output

proc get_debug_level*(): cint {.importcpp: "get_debug_level(@)".}
## / Set the debug level
## / @param level The level of the verbosity for the debugging output (0-10) 0: no debgging output

proc set_debug_level*(level: cint) {.importcpp: "set_debug_level(@)".}
##  \brief Extract a value from the saturation ancillary
##
##  @param fluid_name The name of the fluid to be used - HelmholtzEOS backend only
##  @param output The desired output variable ("P" for instance for pressure)
##  @param Q The quality, 0 or 1
##  @param input The input variable ("T")
##  @param value The input value
##

proc saturation_ancillary*(fluid_name: cstring; output: cstring; Q: cint;
                          input: cstring; value: cdouble): cdouble {.
    importcpp: "saturation_ancillary(@)".}
##  ---------------------------------
##         Humid Air Properties
##  ---------------------------------
## * \brief DLL wrapper of the HAPropsSI function
##  \sa \ref HumidAir::HAPropsSI(const char *OutputName, const char *Input1Name, double Input1, const char *Input2Name, double Input2, const char *Input3Name, double Input3);
##
##  \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc HAPropsSI*(Output: cstring; Name1: cstring; Prop1: cdouble; Name2: cstring;
               Prop2: cdouble; Name3: cstring; Prop3: cdouble): cdouble {.
    importcpp: "HAPropsSI(@)".}
## * \brief Humid air saturation specific heat at 1 atmosphere, based on a correlation from EES.
##  \sa \ref HumidAir::cair_sat(double);
##
##  @param T [K] good from 250K to 300K, no error bound checking is carried out.
##
##  \note Equals partial derivative of enthalpy with respect to temperature at constant relative humidity of 100 percent and pressure of 1 atmosphere.
##

proc cair_sat*(T: cdouble): cdouble {.importcpp: "cair_sat(@)".}
## * \brief FORTRAN 77 style wrapper of the HAPropsSI function
##  \sa \ref HumidAir::HAPropsSI(const char *OutputName, const char *Input1Name, double Input1, const char *Input2Name, double Input2, const char *Input3Name, double Input3);
##
##  \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc hapropssi*(Output: cstring; Name1: cstring; Prop1: ptr cdouble; Name2: cstring;
                Prop2: ptr cdouble; Name3: cstring; Prop3: ptr cdouble;
                output: ptr cdouble) {.importcpp: "hapropssi_(@)".}
## * \brief DLL wrapper of the HAProps function
##
##  \warning DEPRECATED!!
##  \sa \ref HumidAir::HAProps(const char *OutputName, const char *Input1Name, double Input1, const char *Input2Name, double Input2, const char *Input3Name, double Input3);
##
##  \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc HAProps*(Output: cstring; Name1: cstring; Prop1: cdouble; Name2: cstring;
             Prop2: cdouble; Name3: cstring; Prop3: cdouble): cdouble {.
    importcpp: "HAProps(@)".}
## * \brief FORTRAN 77 style wrapper of the HAProps function
##
##  \warning DEPRECATED!!
##  \sa \ref HumidAir::HAProps(const char *OutputName, const char *Input1Name, double Input1, const char *Input2Name, double Input2, const char *Input3Name, double Input3);
##
##  \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
##

proc haprops*(Output: cstring; Name1: cstring; Prop1: ptr cdouble; Name2: cstring;
              Prop2: ptr cdouble; Name3: cstring; Prop3: ptr cdouble;
              output: ptr cdouble) {.importcpp: "haprops_(@)".}
##  ---------------------------------
##         Low-level access
##  ---------------------------------
## *
##  @brief Generate an AbstractState instance, return an integer handle to the state class generated to be used in the other low-level accessor functions
##  @param backend The backend you will use, "HEOS", "REFPROP", etc.
##  @param fluids '&' delimited list of fluids
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return A handle to the state class generated
##

proc AbstractState_factory*(backend: cstring; fluids: cstring; errcode: ptr clong;
                           message_buffer: cstring; buffer_length: clong): clong {.
    importcpp: "AbstractState_factory(@)".}
## *
##  @brief Get the fluid names for the AbstractState
##  @param handle The integer handle for the state class stored in memory
##  @param fluids LIST_STRING_DELIMETER (',') delimited list of fluids
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_fluid_names*(handle: clong; fluids: cstring; errcode: ptr clong;
                               message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_fluid_names(@)".}
## *
##  @brief Release a state class generated by the low-level interface wrapper
##  @param handle The integer handle for the state class stored in memory
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_free*(handle: clong; errcode: ptr clong; message_buffer: cstring;
                        buffer_length: clong) {.
    importcpp: "AbstractState_free(@)".}
## *
##  @brief Set the fractions (mole, mass, volume) for the AbstractState
##  @param handle The integer handle for the state class stored in memory
##  @param fractions The array of fractions
##  @param N The length of the fractions array
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_set_fractions*(handle: clong; fractions: ptr cdouble; N: clong;
                                 errcode: ptr clong; message_buffer: cstring;
                                 buffer_length: clong) {.
    importcpp: "AbstractState_set_fractions(@)".}
## *
##  @brief Get the molar fractions for the AbstractState
##  @param handle The integer handle for the state class stored in memory
##  @param fractions The array of fractions
##  @param maxN The length of the buffer for the fractions
##  @param N number of fluids
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_get_mole_fractions*(handle: clong; fractions: ptr cdouble;
                                      maxN: clong; N: ptr clong; errcode: ptr clong;
                                      message_buffer: cstring;
                                      buffer_length: clong) {.
    importcpp: "AbstractState_get_mole_fractions(@)".}
## *
##  @brief Get the molar fractions for the AbstractState and the desired saturated State
##  @param handle The integer handle for the state class stored in memory
##  @param saturated_state The string specifying the state (liquid or gas)
##  @param fractions The array of fractions
##  @param maxN The length of the buffer for the fractions
##  @param N number of fluids
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_get_mole_fractions_satState*(handle: clong;
    saturated_state: cstring; fractions: ptr cdouble; maxN: clong; N: ptr clong;
    errcode: ptr clong; message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_get_mole_fractions_satState(@)".}
## *
##  @brief Update the state of the AbstractState
##  @param handle The integer handle for the state class stored in memory
##  @param input_pair The integer value for the input pair obtained from XXXXXXXXXXXXXXXX
##  @param value1 The first input value
##  @param value2 The second input value
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_update*(handle: clong; input_pair: clong; value1: cdouble;
                          value2: cdouble; errcode: ptr clong;
                          message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_update(@)".}
## *
##  @brief Specify the phase to be used for all further calculations
##  @param handle The integer handle for the state class stored in memory
##  @param phase The string with the phase to use
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_specify_phase*(handle: clong; phase: cstring; errcode: ptr clong;
                                 message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_specify_phase(@)".}
## *
##  @brief Unspecify the phase to be used for all further calculations
##  @param handle The integer handle for the state class stored in memory
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_unspecify_phase*(handle: clong; errcode: ptr clong;
                                   message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_unspecify_phase(@)".}
## *
##  @brief Get an output value from the AbstractState using an integer value for the desired output value
##  @param handle The integer handle for the state class stored in memory
##  @param param The integer value for the parameter you want
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_keyed_output*(handle: clong; param: clong; errcode: ptr clong;
                                message_buffer: cstring; buffer_length: clong): cdouble {.
    importcpp: "AbstractState_keyed_output(@)".}
## *
##  @brief Calculate a saturation derivative from the AbstractState using integer values for the desired parameters
##  @param handle The integer handle for the state class stored in memory
##  @param Of The parameter of which the derivative is being taken
##  @param Wrt The derivative with with respect to this parameter
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_first_saturation_deriv*(handle: clong; Of: clong; Wrt: clong;
    errcode: ptr clong; message_buffer: cstring; buffer_length: clong): cdouble {.
    importcpp: "AbstractState_first_saturation_deriv(@)".}
## *
##  @brief Calculate the first partial derivative in homogeneous phases from the AbstractState using integer values for the desired parameters
##  @param handle The integer handle for the state class stored in memory
##  @param Of The parameter of which the derivative is being taken
##  @param Wrt The derivative with with respect to this parameter
##  @param Constant The parameter that is not affected by the derivative
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_first_partial_deriv*(handle: clong; Of: clong; Wrt: clong;
                                       Constant: clong; errcode: ptr clong;
                                       message_buffer: cstring;
                                       buffer_length: clong): cdouble {.
    importcpp: "AbstractState_first_partial_deriv(@)".}
## *
##  @brief Update the state of the AbstractState and get an output value five common outputs (temperature, pressure, molar density, molar enthalpy and molar entropy)
##  @brief from the AbstractState using pointers as inputs and output to allow array computation.
##  @param handle The integer handle for the state class stored in memory
##  @param input_pair The integer value for the input pair obtained from get_input_pair_index
##  @param value1 The pointer to the array of the first input parameters
##  @param value2 The pointer to the array of the second input parameters
##  @param length The number of elements stored in the arrays (both inputs and outputs MUST be the same length)
##  @param T The pointer to the array of temperature
##  @param p The pointer to the array of pressure
##  @param rhomolar The pointer to the array of molar density
##  @param hmolar The pointer to the array of molar enthalpy
##  @param smolar The pointer to the array of molar entropy
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error in an update call for one of the inputs, no change in the output array will be made
##

proc AbstractState_update_and_common_out*(handle: clong; input_pair: clong;
    value1: ptr cdouble; value2: ptr cdouble; length: clong; T: ptr cdouble;
    p: ptr cdouble; rhomolar: ptr cdouble; hmolar: ptr cdouble; smolar: ptr cdouble;
    errcode: ptr clong; message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_update_and_common_out(@)".}
## *
##  @brief Update the state of the AbstractState and get one output value (temperature, pressure, molar density, molar enthalpy and molar entropy)
##  @brief from the AbstractState using pointers as inputs and output to allow array computation.
##  @param handle The integer handle for the state class stored in memory
##  @param input_pair The integer value for the input pair obtained from get_input_pair_index
##  @param value1 The pointer to the array of the first input parameters
##  @param value2 The pointer to the array of the second input parameters
##  @param length The number of elements stored in the arrays (both inputs and outputs MUST be the same length)
##  @param output The indice for the output desired
##  @param out The pointer to the array for output
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error in an update call for one of the inputs, no change in the output array will be made
##

proc AbstractState_update_and_1_out*(handle: clong; input_pair: clong;
                                    value1: ptr cdouble; value2: ptr cdouble;
                                    length: clong; output: clong;
                                    `out`: ptr cdouble; errcode: ptr clong;
                                    message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_update_and_1_out(@)".}
## *
##  @brief Update the state of the AbstractState and get an output value five common outputs (temperature, pressure, molar density, molar enthalpy and molar entropy)
##  @brief from the AbstractState using pointers as inputs and output to allow array computation.
##  @param handle The integer handle for the state class stored in memory
##  @param input_pair The integer value for the input pair obtained from get_input_pair_index
##  @param value1 The pointer to the array of the first input parameters
##  @param value2 The pointer to the array of the second input parameters
##  @param length The number of elements stored in the arrays (both inputs and outputs MUST be the same length)
##  @param outputs The 5-element vector of indices for the outputs desired
##  @param out1 The pointer to the array for the first output
##  @param out2 The pointer to the array for the second output
##  @param out3 The pointer to the array for the third output
##  @param out4 The pointer to the array for the fourth output
##  @param out5 The pointer to the array for the fifth output
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error in an update call for one of the inputs, no change in the output array will be made
##

proc AbstractState_update_and_5_out*(handle: clong; input_pair: clong;
                                    value1: ptr cdouble; value2: ptr cdouble;
                                    length: clong; outputs: ptr clong;
                                    out1: ptr cdouble; out2: ptr cdouble;
                                    out3: ptr cdouble; out4: ptr cdouble;
                                    out5: ptr cdouble; errcode: ptr clong;
                                    message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_update_and_5_out(@)".}
## *
##  @brief Set binary interraction parrameter for mixtures
##  @param handle The integer handle for the state class stored in memory
##  @param i indice of the first fluid of the binary pair
##  @param j indice of the second fluid of the binary pair
##  @param parameter string wit the name of the parameter
##  @param value the value of the binary interaction parameter
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_set_binary_interaction_double*(handle: clong; i: clong; j: clong;
    parameter: cstring; value: cdouble; errcode: ptr clong; message_buffer: cstring;
    buffer_length: clong) {.importcpp: "AbstractState_set_binary_interaction_double(@)".}
## *
##  @brief Set cubic's alpha function parameters
##  @param handle The integer handle for the state class stored in memory
##  @param i indice of the fluid the parramter should be applied too (for mixtures)
##  @param parameter the string specifying the alpha function to use, ex "TWU" for the TWU alpha function
##  @param c1 the first parameter for the alpha function
##  @param c2 the second parameter for the alpha function
##  @param c3 the third parameter for the alpha function
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_set_cubic_alpha_C*(handle: clong; i: clong; parameter: cstring;
                                     c1: cdouble; c2: cdouble; c3: cdouble;
                                     errcode: ptr clong; message_buffer: cstring;
                                     buffer_length: clong) {.
    importcpp: "AbstractState_set_cubic_alpha_C(@)".}
## *
##  @brief Set some fluid parameter (ie volume translation for cubic)
##  @param handle The integer handle for the state class stored in memory
##  @param i indice of the fluid the parramter should be applied too (for mixtures)
##  @param parameter the string specifying the parameter to use, ex "cm" for volume translation
##  @param value the value of the parameter
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_set_fluid_parameter_double*(handle: clong; i: clong;
    parameter: cstring; value: cdouble; errcode: ptr clong; message_buffer: cstring;
    buffer_length: clong) {.importcpp: "AbstractState_set_fluid_parameter_double(@)".}
## *
##  @brief Build the phase envelope
##  @param handle The integer handle for the state class stored in memory
##  @param level How much refining of the phase envelope ("none" to skip refining (recommended))
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error in an update call for one of the inputs, no change in the output array will be made
##

proc AbstractState_build_phase_envelope*(handle: clong; level: cstring;
                                        errcode: ptr clong;
                                        message_buffer: cstring;
                                        buffer_length: clong) {.
    importcpp: "AbstractState_build_phase_envelope(@)".}
## *
##  @brief Get data from the phase envelope for the given mixture composition
##  @param handle The integer handle for the state class stored in memory
##  @param length The number of elements stored in the arrays (both inputs and outputs MUST be the same length)
##  @param T The pointer to the array of temperature (K)
##  @param p The pointer to the array of pressure (Pa)
##  @param rhomolar_vap The pointer to the array of molar density for vapor phase (m^3/mol)
##  @param rhomolar_liq The pointer to the array of molar density for liquid phase (m^3/mol)
##  @param x The compositions of the "liquid" phase (WARNING: buffer should be Ncomp*Npoints in length, at a minimum, but there is no way to check buffer length at runtime)
##  @param y The compositions of the "vapor" phase (WARNING: buffer should be Ncomp*Npoints in length, at a minimum, but there is no way to check buffer length at runtime)
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error in an update call for one of the inputs, no change in the output array will be made
##

proc AbstractState_get_phase_envelope_data*(handle: clong; length: clong;
    T: ptr cdouble; p: ptr cdouble; rhomolar_vap: ptr cdouble; rhomolar_liq: ptr cdouble;
    x: ptr cdouble; y: ptr cdouble; errcode: ptr clong; message_buffer: cstring;
    buffer_length: clong) {.importcpp: "AbstractState_get_phase_envelope_data(@)".}
## *
##  @brief Get data from the phase envelope for the given mixture composition
##  @param handle The integer handle for the state class stored in memory
##  @param length The number of elements stored in the arrays (both inputs and outputs MUST be the same length)
##  @param maxComponents The number of fluid components for which memory is allocated
##  @param T The pointer to the array of temperature (K)
##  @param p The pointer to the array of pressure (Pa)
##  @param rhomolar_vap The pointer to the array of molar density for vapor phase (m^3/mol)
##  @param rhomolar_liq The pointer to the array of molar density for liquid phase (m^3/mol)
##  @param x The compositions of the "liquid" phase (WARNING: buffer should be Ncomp*Npoints in length, at a minimum, but there is no way to check buffer length at runtime)
##  @param y The compositions of the "vapor" phase (WARNING: buffer should be Ncomp*Npoints in length, at a minimum, but there is no way to check buffer length at runtime)
##  @param actual_length The number of elements actually stored in the arrays
##  @param actual_components The number of fluid components actually stored in the arrays
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error in an update call for one of the inputs, no change in the output array will be made
##

proc AbstractState_get_phase_envelope_data_checkedMemory*(handle: clong;
    length: clong; maxComponents: clong; T: ptr cdouble; p: ptr cdouble;
    rhomolar_vap: ptr cdouble; rhomolar_liq: ptr cdouble; x: ptr cdouble; y: ptr cdouble;
    actual_length: ptr clong; actual_components: ptr clong; errcode: ptr clong;
    message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_get_phase_envelope_data_checkedMemory(@)".}
## *
##  @brief Build the spinodal
##  @param handle The integer handle for the state class stored in memory
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_build_spinodal*(handle: clong; errcode: ptr clong;
                                  message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_build_spinodal(@)".}
## *
##  @brief Get data for the spinodal curve
##  @param handle The integer handle for the state class stored in memory
##  @param length The number of elements stored in the arrays (all outputs MUST be the same length)
##  @param tau The pointer to the array of reciprocal reduced temperature
##  @param delta The pointer to the array of reduced density
##  @param M1 The pointer to the array of M1 values (when L1=M1=0, critical point)
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error, no change in the output arrays will be made
##

proc AbstractState_get_spinodal_data*(handle: clong; length: clong; tau: ptr cdouble;
                                     delta: ptr cdouble; M1: ptr cdouble;
                                     errcode: ptr clong; message_buffer: cstring;
                                     buffer_length: clong) {.
    importcpp: "AbstractState_get_spinodal_data(@)".}
## *
##  @brief Calculate all the critical points for a given composition
##  @param handle The integer handle for the state class stored in memory
##  @param length The length of the buffers passed to this function
##  @param T The pointer to the array of temperature (K)
##  @param p The pointer to the array of pressure (Pa)
##  @param rhomolar The pointer to the array of molar density (m^3/mol)
##  @param stable The pointer to the array of boolean flags for whether the critical point is stable (1) or unstable (0)
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##
##  @note If there is an error in an update call for one of the inputs, no change in the output array will be made
##

proc AbstractState_all_critical_points*(handle: clong; length: clong; T: ptr cdouble;
                                       p: ptr cdouble; rhomolar: ptr cdouble;
                                       stable: ptr clong; errcode: ptr clong;
                                       message_buffer: cstring;
                                       buffer_length: clong) {.
    importcpp: "AbstractState_all_critical_points(@)".}
## *
##  @brief Get an output value from the AbstractState using an integer value for the desired output value and desired saturated State
##  @param handle The integer handle for the state class stored in memory
##  @param saturated_state The string specifying the state (liquid or gas)
##  @param param The integer value for the parameter you want
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_keyed_output_satState*(handle: clong; saturated_state: cstring;
    param: clong; errcode: ptr clong; message_buffer: cstring; buffer_length: clong): cdouble {.
    importcpp: "AbstractState_keyed_output_satState(@)".}
## *
##  @brief Return the name of the backend used in the AbstractState
##  @param handle The integer handle for the state class stored in memory
##  @param backend The char pointer the name is written to
##  @param errcode The errorcode that is returned (0 = no error, !0 = error)
##  @param message_buffer A buffer for the error code
##  @param buffer_length The length of the buffer for the error code
##  @return
##

proc AbstractState_backend_name*(handle: clong; backend: cstring; errcode: ptr clong;
                                message_buffer: cstring; buffer_length: clong) {.
    importcpp: "AbstractState_backend_name(@)".}
## *
##  \brief Add fluids as a JSON-formatted string
##  @param backend The backend to which these should be added; e.g. "HEOS", "SRK", "PR"
##  @param fluidstring The JSON-formatted string
##  @return
##
##

proc add_fluids_as_JSON*(backend: cstring; fluidstring: cstring; errcode: ptr clong;
                        message_buffer: cstring; buffer_length: clong) {.
    importcpp: "add_fluids_as_JSON(@)".}
##  *************************************************************************************
##  *************************************************************************************
##  *****************************  DEPRECATED *******************************************
##  *************************************************************************************
##  *************************************************************************************
## *
##     \overload
##     \sa \ref Props(const char *Output, const char Name1, double Prop1, const char Name2, double Prop2, const char *Ref)
##

proc PropsS*(Output: cstring; Name1: cstring; Prop1: cdouble; Name2: cstring;
            Prop2: cdouble; Ref: cstring): cdouble {.importcpp: "PropsS(@)".}
## *
##     Works just like \ref CoolProp::PropsSI, but units are in KSI system.  This function is deprecated, no longer supported, and users should transition to using the PropsSI function
##

proc Props*(Output: cstring; Name1: char; Prop1: cdouble; Name2: char; Prop2: cdouble;
           Ref: cstring): cdouble {.importcpp: "Props(@)".}
## *
##     Works just like \ref CoolProp::Props1SI, but units are in KSI system.  This function is deprecated, no longer supported, and users should transition to using the Props1SI function
##

proc Props1*(FluidName: cstring; Output: cstring): cdouble {.importcpp: "Props1(@)".}

{.pop.}