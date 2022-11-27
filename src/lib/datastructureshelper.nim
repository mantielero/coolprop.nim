import ../wrapper/DataStructures

proc generateUpdatePair*[T](key1: parameters; value1: T; 
         key2: parameters; value2: T ): tuple[ipair:input_pairs;a,b:float] =
    var a,b:float
    var tmp = generate_update_pair(iT, 300.0, iDMolar, 1.0e-6, a, b)
    return (tmp, a, b)

    