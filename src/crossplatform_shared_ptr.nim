##  By default, we use shared_ptr from the std namespace, and include the memory header,
##  but some compilers need different treatment. Cmake provides the tools to
##  ensure that the correct header is identified as a compile-time check, and we use
##  that capability to change the include and/or the namespace

# when defined(SHARED_PTR_TR1_MEMORY_HEADER):
#   discard
# else:
#   discard
# when defined(SHARED_PTR_TR1_NAMESPACE):
#   ## using statement
# else:
#   ## using statement

type
  CppSharedPtr* {.importcpp: "std::shared_ptr", header: "<memory>", byref.} [T] = object