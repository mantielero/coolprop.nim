import coolprop
import std/unittest

const
  eps = 1.0e-2 ## Epsilon used for float comparisons.

proc `=~` *(x, y: float): bool =
  result = abs(x - y) < eps


suite "Testing the high level interface":
  #echo "suite setup: run once before the tests"
  setup:
    var T = 298.0
    var p = 1.0e5

  test "checking HEOS backend":
    # Default backend is HEOS
    assert PropsSI( "Dmolar", "T", 298.0, "P", 1.0e5, "Propane[0.5]&Ethane[0.5]")       =~ 40.827
    assert PropsSI( "Dmolar", "T", 298.0, "P", 1.0e5, "HEOS::Propane[0.5]&Ethane[0.5]") =~ 40.827

  #test "checking REFPROP backend":  
  #  echo PropsSI( "Dmolar", "T", 298.0, "P", 1.0e5, "REFPROP::Propane[0.5]&Ethane[0.5]")


#[

# First type (slowest, due to most string processing, exposed in DLL)



var z = initCppVector[cdouble](2, 0.5)
var fluids = initCppVector[cstring]()
fluids.pushBack("Propane")
fluids.pushBack("Ethane")
var outputs = initCppVector[cstring]()
outputs.pushBack("Dmolar")
# echo PropsSImulti( "Dmolar",
#                    "T", T, 1,
#                    "P", p, 1,
#                    "HEOS", 
#                    fluids, z)[0][0]

# var output:string = "D"
# echo Props1SI("Propane", output)
# std::cout << PropsSImulti(outputs,"T", T, "P", p, "", fluids, z)[0][0] << std::endl;

#[
# proc PropsSImulti*(Outputs: vector[string]; Name1: string; Prop1: vector[cdouble];
#                   Name2: string; Prop2: vector[cdouble]; backend: string;
#                   fluids: vector[string]; fractions: vector[cdouble]): vector[
#     vector[cdouble]] {.importcpp: "CoolProp::PropsSImulti(@)", header: "CoolProp.h".}    
]#
#2.0, 0.5)



#[
    // Vector example
    std::vector<double> z(2,0.5);
    // Second type (C++ only, a bit faster, allows for vector inputs and outputs)
    std::vector<std::string> fluids; fluids.push_back("Propane"); fluids.push_back("Ethane");
    std::vector<std::string> outputs; outputs.push_back("Dmolar");
    std::vector<double> T(1,298), p(1,1e5);
    std::cout << PropsSImulti(outputs,"T", T, "P", p, "", fluids, z)[0][0] << std::endl; // Default backend is HEOS
    std::cout << PropsSImulti(outputs,"T", T, "P", p, "HEOS", fluids, z)[0][0] << std::endl;
    // Comment me out if REFPROP is not installed
    std::cout << PropsSImulti(outputs,"T", T, "P", p, "REFPROP", fluids, z)[0][0] << std::endl;
    // All done return
    return EXIT_SUCCESS;
]#
]#
