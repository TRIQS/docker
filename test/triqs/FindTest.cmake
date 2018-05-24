SET(PythonBuildExecutable python)

find_package(TriqsTest)

# runs a c++ test
# if there is a .ref file a comparison test is done
# Example: add_cpp_test(my_code)
#   where my_code is the cpp executable my_code.ref is the expected output
macro(add_cpp_test testname)
  triqs_add_cpp_test(${testname})
endmacro(add_cpp_test)

# runs a python test
# if there is a .ref file a comparison test is done
# Example: add_python_test(my_script)
#   where my_script.py is the script and my_script.ref is the expected output
macro(add_python_test testname)
  triqs_add_python_test(${testname})
endmacro(add_python_test)
