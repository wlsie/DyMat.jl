using DyMat
using Test

@testset "DyMat.jl" begin
    @test strMatNormal(["ab   " "bc "]) == ["ab" "bc"]
    @test strMatTrans(["ab  " "bc"; "cd  " "de"]) == ["acbd"; "bdce"]
    @test sign(-6.0) == -1.0
    #loading files
    @test length(getNames(DyMatFile("DoublePendulum_Dymola-7.4.mat")))==1095
    @test length(getNames(DyMatFile("DoublePendulum_Dymola-2012-SaveAsPlotted.mat"))) == 5
    @test length(getNames(DyMatFile("DoublePendulum_Dymola-2012.mat"))) == 1096
    @test length(getNames(DyMatFile("DoublePendulum_OpenModelica-1.8.mat"))) == 2213
    #loading data 
    @test round(sum(data(DyMatFile("DoublePendulum_Dymola-2012-SaveAsPlotted.mat"),"revolute1.w"))) == 686.0
    #description
    @test description(DyMatFile("DoublePendulum_Dymola-7.4.mat"),"revolute1.w") == "First derivative of angle phi (relative angular velocity) [rad/s]"
    #shared data
    @test sharedData(DyMatFile("DoublePendulum_Dymola-7.4.mat"),"revolute1.w") == [("damper.w_rel", 1.0); ("damper.der(phi_rel)", 1.0)]
    #abscissa
    @test length(abscissa(DyMatFile("DoublePendulum_Dymola-7.4.mat"),"revolute1.w")[1]) == 502 
end

