function strMatNormal(a)
    return [strip(join(s)) for s in a]
end

function strMatTrans(a)
    return [strip(join(s)) for s in zip(a...)]
end

function sign(x)
    return copysign(1.0, x)
end

# Define the DyMatFile type
struct DyMatFile
    fileName::String
    mat::Dict{String,Any}
    _vars::Dict{String,Tuple{String,Int,Int,Float64}}
    _blocks::Vector{Int}
    _absc::Tuple{String,String}
end



# Constructor for DyMatFile
function DyMatFile(fileName::String)
    mat = matread(fileName)
    _vars = Dict{String,Tuple{String,Int,Int,Float64}}()
    _blocks = Int[]
    _absc = ("", "")
    fileInfo = strMatNormal(mat["Aclass"])
    # try catch causes some error. Need to fix.
    #= try
        fileInfo = strMatNormal(mat["Aclass"])
    catch e
        throw("File structure not supported!")
    end =#

    if fileInfo[2][begin:3] in ["1.1"]
        if fileInfo[4][begin:8] in ["binTrans"]
            names = strMatTrans(mat["name"])
            descr = strMatTrans(mat["description"])
            for i in eachindex(names)
                d = mat["dataInfo"][1, i]
                x = mat["dataInfo"][2, i]
                c = abs(x) - 1
                s = sign(x)
                if c != 0
                    _vars[names[i]] = (descr[i], d, c, s)
                    if d ∉ _blocks
                        push!(_blocks, d)
                    end
                else
                    _absc = (names[i], descr[i])
                end
            end
        elseif fileInfo[4][begin:9] in ["binNormal"]
            names = strMatNormal(mat["name"])
            descr = strMatNormal(mat["description"])
            for i in eachindex(names)
                d = mat["dataInfo"][1, i]
                x = mat["dataInfo"][2, i]
                c = abs(x) - 1
                s = sign(x)
                if c != 0
                    _vars[names[i]] = (descr[i], d, c, s)
                    if d ∉ _blocks
                        push!(_blocks, d)
                        b = "data_$d"
                        mat[b] = transpose(mat[b])
                    end
                else
                    _absc = (names[i], descr[i])
                end
            end
        else
            throw("File structure not supported!")
        end
    elseif fileInfo[2][begin:3] in ["1.0"]
        names = strMatNormal(mat["names"])
        push!(_blocks, 0)
        mat["data_0"] = transpose(mat["data"])
        delete!(mat, "data")
        _absc = (names[1], "")
        for i in 2:length(names)
            _vars[names[i]] = ("", 0, i, 1.0)
        end
    else
        throw("File structure not supported!")
    end

    return DyMatFile(fileName, mat, _vars, _blocks, _absc)
end

# Returns the numbers of all data blocks
function blocks(d::DyMatFile)
    return d._blocks
end


# Returns the names of all variables. If block is given only variables of this block are listed.
function getNames(d::DyMatFile, block::Union{Nothing,Int}=nothing)
    if block === nothing
        return keys(d._vars)
    else
        return [k for (k, v) in d._vars if v[2] == block]
    end
end

# Returns the values of the variable.
function data(d::DyMatFile, varName::String)
    tmp, block, col, sign = d._vars[varName]
    di = "data_$block"
    dd = d.mat[di][col+1, :]
    if sign < 0
        dd = -dd
    end
    return dd
end

#Returns the block number of the variable
function block(d::DyMatFile, varName::String)
    return d._vars[varName][2]
end

#Returns the description string of the variable
function description(d::DyMatFile, varName::String)
    return d._vars[varName][1]
end

function sharedData(d::DyMatFile, varName::String)
    tmp, block, col, sign = d._vars[varName]
    return [(n, v[4] * sign) for (n, v) in d._vars if n != varName && v[2] == block && v[3] == col]
end

function size(d::DyMatFile, blockOrName::Union{Int,String})
    block = try
        Int(blockOrName)
    catch
        d._vars[blockOrName][2]
    end
    di = "data_$block"
    return size(d.mat[di], 2)
end

function abscissa(d::DyMatFile, blockOrName::Union{Int,String}, valuesOnly::Bool=false)
    block = try
        Int(blockOrName)
    catch
        d._vars[blockOrName][2]
    end
    di = "data_$block"
    if valuesOnly
        return d.mat[di][1, :]
    else
        return d.mat[di][1, :], d._absc[1], d._absc[2]
    end
end

function sortByBlocks(d::DyMatFile, varList::Vector{String})
    vl = [(v, d._vars[v][2]) for v in varList]
    vDict = Dict{Int,Vector{String}}()
    for bl in d._blocks
        l = [v for (v, b) in vl if b == bl]
        if !isempty(l)
            vDict[bl] = l
        end
    end
    return vDict
end

function nameTree(d::DyMatFile)
    root = Dict{String,Any}()
    for v in keys(d._vars)
        branch = root
        elem = split(v, '.')
        for e in elem[1:end-1]
            if e ∉ branch
                branch[e] = Dict{String,Any}()
            end
            branch = branch[e]
        end
        branch[elem[end]] = v
    end
    return root
end

function getVarArray(d::DyMatFile, varNames::Vector{String}, withAbscissa::Bool=true)
    v = [reshape(data(d, n), 1, :) for n in varNames]
    if withAbscissa
        pushfirst!(v, reshape(abscissa(d, varNames[1], true), 1, :))
    end
    return vcat(v...)
end