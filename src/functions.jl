function strMatNormal(a)
    return [strip(join(s)) for s in a]
end

function strMatTrans(a)
    return [strip(join(s)) for s in zip(a...)]
end

function sign(x)
    return copysign(1.0,x)
end