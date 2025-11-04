using Fleckit

gridSize = [7,10]
squareSize = 20.0 
paperSize = :A4
fileName = joinpath(fleckitdir(),"assets","checkerboard_$paperSize"*"_"*string(gridSize[1])*"x"*string(gridSize[2])*".svg")

checkerboardImage(fileName, gridSize, squareSize; paperSize=paperSize, color1="black", color2="white", colorBackground="white")