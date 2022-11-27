import CoolPropLib
# p = PropsSI("P", "T", 300, "D", 1, "Propane");
echo PropsSI("Dmolar", "T", 298.0, "P", 1.0e5, "Propane[0.5]&Ethane[0.5]")

#[
    // First type (slowest, due to most string processing, exposed in DLL)
    std::cout << PropsSI("Dmolar","T",298,"P",1e5,"Propane[0.5]&Ethane[0.5]") << std::endl; // Default backend is HEOS
    std::cout << PropsSI("Dmolar","T",298,"P",1e5,"HEOS::Propane[0.5]&Ethane[0.5]") << std::endl;
    std::cout << PropsSI("Dmolar","T",298,"P",1e5,"REFPROP::Propane[0.5]&Ethane[0.5]") << std::endl;
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