cmake_minimum_required(VERSION 3.5)
project(wasmSample)

set(CMAKE_CXX_STANDARD 20)

include(CompileWasmModule)

set(SIEVE_OF_ERATOSTHENES_SRC SieveOfEratosthenes.cpp)
CompileWasmModule(NAME sieveOfEratosthenes SOURCES ${SIEVE_OF_ERATOSTHENES_SRC})
