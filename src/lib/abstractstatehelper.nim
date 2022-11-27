{.passL:"-lCoolProp -ldl".}
{.passC:"-Wall -O2 -DCOOLPROP_LIB  -I/usr/include/fmt -I/usr/include/CoolProp".} # -std=c++11 
import cppstl
#import ../wrapper/CoolPropLib
#import DataStructures
import ../wrapper/AbstractState
export AbstractState



proc newCppSharedPtr[T](p: ptr T): CppSharedPtr[T] {.constructor, importcpp: "std::shared_ptr<'*0>(#)", header:"<memory>".}

type
  AbstractStatePtr* = CppSharedPtr[AbstractState.AbstractState]

converter toAbstractState*(this:AbstractStatePtr): var AbstractState =
  this.deref

proc factory*(backend, fluidNames:string):AbstractStatePtr  =
  newCppSharedPtr( factory(initCppString(backend), initCppString(fluidNames)) )

proc newAbstractState*(backend, fluidNames:string):AbstractStatePtr  =
  newCppSharedPtr( factory(initCppString(backend), initCppString(fluidNames)) )

proc update*[N,M:SomeNumber](this: AbstractStatePtr; input_pair: input_pairs; Value1: N;
            Value2: M) =
  ## update the state using two state variables
  this.deref.update(input_pair, Value1.cdouble, Value2.cdouble)


proc setMoleFractions*(this: var AbstractState;
                        mole_fractions: seq[float]) =
  this.setMoleFractions(mole_fractions.toCppVector)
  #CppVector[CoolPropDbl]

converter toSeqFloat*(this:CppVector[CoolPropDbl]):seq[float] =
  var tmp = newSeq[float](this.len)
  for i in 0 ..< this.len:
    tmp[i] = this[i]
  return tmp

proc moleFractionsLiquid*(this: var AbstractState): seq[float] =
  this.mole_fractions_liquid_original

proc moleFractionsVapor*(this: var AbstractState): seq[float] =
  this.mole_fractions_vapor_original
