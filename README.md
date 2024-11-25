# DyMat
The objective of this package is to provide Julia functions to read and process result files (*.mat) from Dymola and OpenModelica software which are used for simulating Modelica models. It is similar to https://github.com/jraedler/DyMat for Python. The test files are taken from the Python repository.

The results from Dymola and OpenModelica are in a very specific .mat format. This is done to save the output file size by removing separate data for variables which share the same value. For example, if you have an equation $a = c$, then only the value of one of the variables is stored. However, you can query for the other variable and with information stored in the result file, you are able to plot both the variables.

## How can I use DyMat.jl?
1\. Open a Julia-REPL, switch to package mode using `]`, activate your preferred environment.

2\. Install [*DyMat.jl*](https://github.com/wlsie/DyMat.jl):
```julia-repl
(@v1) pkg> add DyMat
```

3\. If you want to check that everything works correctly, you can run the tests bundled with [*DyMat.jl*](https://github.com/wlsie/DyMat.jl):
```julia-repl
(@v1) pkg> test DyMat
```

4\. Have a look inside the [examples folder](https://github.com/wlsie/DyMat.jl/tree/main/examples) in the examples for a helper file to get you started.


[![Build Status](https://github.com/wlsie/DyMat.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/wlsie/DyMat.jl/actions/workflows/CI.yml?query=branch%3Amain)
