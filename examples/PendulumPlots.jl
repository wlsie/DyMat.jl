using DyMat
using Plots

#Create the object for storing data from *.mat file
dyMat = DyMatFile("test/DoublePendulum_Dymola-7.4.mat")

#Check variable names 
names = getNames(dyMat)

#Check description of a variable
@show description(dyMat,"revolute1.w");

#Obtain data for plotting
revoluteSpeedDer = data(dyMat,"revolute1.w")

#Obtain corresponding time for the variable
time = abscissa(dyMat,"revolute1.w")

#Plots
plot(time,revoluteSpeed,xlabel="Time [s]",ylabel="Speed Derivative [rad/s]")

#Obtain multiple variables with time with a single call
vals = zeros(3,502)
vals = getVarArray(dyMat,["revolute1.w"; "revolute2.w"])
plot(vals[1,:],vals[2,:],label="Speed der 1",xlabel="Time [s]",ylabel="Speed Derivative [rad/s]")
plot!(vals[1,:],vals[3,:],label="Speed der 2")