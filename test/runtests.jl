using DyMat
using Test

@testset "DyMat.jl" begin
    @test strMatNormal(["ab   " "bc "]) == ["ab" "bc"]
    @test strMatTrans(["ab  " "bc"; "cd  " "de"]) == ["acbd"; "bdce"]
    @test sign(-6.0) == -1.0
    @test length(getNames(DyMatFile("DoublePendulum_Dymola-7.4.mat")))==1095
    @test length(getNames(DyMatFile("DoublePendulum_Dymola-2012-SaveAsPlotted.mat"))) == 5
    @test length(getNames(DyMatFile("DoublePendulum_Dymola-2012.mat"))) == 1096
    @test length(getNames(DyMatFile("DoublePendulum_OpenModelica-1.8.mat"))) == 2213
end
