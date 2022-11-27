import coolprop
import std/strformat

var a,b:float
var tmp = generate_update_pair(iT, 300.0, iDMolar, 1.0e-6, a, b)
echo tmp, " ", tmp.int, " ", a, " ", b 

echo generateUpdatePair(iT, 300.0, iDMolar, 1.0e-6)