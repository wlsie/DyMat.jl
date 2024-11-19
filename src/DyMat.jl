module DyMat

using MAT
using LinearAlgebra

export strMatNormal, strMatTrans, copysign
export DyMatFile, blocks, getNames,data,block
export description, sharedData, size, abscissa, sortByBlocks, nameTree, getVarArray

include("functions.jl")

end
