import ../wrapper/CoolPropLib
import cppstl

converter toCstring*(val:string):cstring =
  val.cstring

# proc getInputPairIndex*(val:string):int =
#     get_input_pair_index_original( initCppString(val) ).int