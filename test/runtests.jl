using DyMat
using Test

@testset "DyMat.jl" begin
    @test strMatNormal(["ab   " "bc "]) == ["ab" "bc"]
    @test strMatTrans(["ab  " "bc"; "cd  " "de"]) == ["acbd"; "bdce"]
    @test sign(-6.0) == -1.0
end
