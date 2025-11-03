using Fleckit
using Fleckit.XML
using LinearAlgebra
using Random
Random.seed!(1) # Ensured random numbers are repeatable


function polyarea(p)
    n = length(p)
    c = zeros(3)
    @inbounds for i in 1:1:n-1        
        a = [p[i][1],p[i][2],0.0]
        b = [p[i+1][1],p[i+1][2],0.0]
        c += cross(a,b)
    end
    return norm(c)/2
end

meshType = :equilateral #Cartesian

eps_tol = 1e-3

wx = 210 # Width
wy = 297 # Height

rMax = 1 # Max. speckle radius
rMin = 1 # Min. speckle radius
scaling_y_min = 1 # Minimum scaling factor of speckles in y-dir should be <=1

s = 0.5 # Spacing in mm between speckles (prior to random shifts)
maxShift = rMax+s/2#0.5*(s/2) #rMax+s/2 # 0.5*(s/2) # random shift magnitude
maxRotationAngle = 180 # Largest possible random rotation angle
pointSpacing = s+2*rMax # Initial speckle spacing

# Setting up grid
minX = pointSpacing
maxX = wx-pointSpacing
minY = pointSpacing
maxY = wy-pointSpacing
xRange = minX:pointSpacing:maxX 

# ---------------------------------
A = wx*wy
if meshType == :equilateral 
    pointSpacing_Y = pointSpacing.*0.5*sqrt(3)
    yRange = minY:pointSpacing_Y:maxY
    sx = pointSpacing/4
elseif meshType == :Cartesian     
    yRange = minY:pointSpacing:maxY
end

A_speckle = 0.0
numSteps = 10
λ_max = 1.5
λ_range = range(1,λ_max,numSteps) # collect(λ_range)
for (q,λ₁) in enumerate(λ_range)
    Random.seed!(1) # Ensured random numbers are repeatable

    # Initialise XML
    doc,svg_node = svg_initialize(wx,wy)

    aen(svg_node,"rect"; x=0.0, y=0.0, width=wx, height=wy, fill="white")

    λ₂ = 1.0 / λ₁
    nSet = [25]
    
    for (j,y) in enumerate(yRange) # Y steps in grid
        for (i,x) in enumerate(xRange) # X steps in grid            
            n = rand(nSet,1)[1]
            
            if n == 4
                T = 0.25*pi .+ range(0,2*pi,n+1) 
            else
                T = range(0,2*pi,n+1) 
            end
            
            if meshType == :equilateral 
                if iseven(j) # Shift over every second row of points
                    x = x+sx
                else
                    x = x-sx
                end  
            end

            # Create polyline points
            cx = λ₂ * (x + (maxShift*rand()-maxShift/2))
            cy = λ₁ * (y + (maxShift*rand()-maxShift/2))            
            rx = rMin +(rMax-rMin)*rand()
            ry = rMin +(rMax-rMin)*rand()
            a = 2*pi*rand()            
            R = [cos(a) -sin(a); sin(a) cos(a)]        
            P = [ R*[rx*cos(t),ry*sin(t)] for t in T]
            P = [ [cx + λ₂*p[1],cy + λ₁*p[2]] for p in P]
            
            # Add polyline to svg
            addpolyline(svg_node,P)

            if q == 1
                global A_speckle += polyarea(P)
            end
        end
    end

    # Write svg file
    fileName = joinpath(fleckitdir(), "assets", "temp_$q.svg")
    svg_write(fileName, doc)
end

ρ = A_speckle./A  

