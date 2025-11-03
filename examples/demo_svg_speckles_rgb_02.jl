using Fleckit
using Random
Random.seed!(1) # Ensured random numbers are repeatable

###

# Define page canvas parameters 
rLogo = 9
wx = 4+ceil(Int,14/4*rLogo) # Width of 
wy = 1+ceil(Int,14/4*rLogo) # Height
fill = "white"

# Define speckle parameters 
rMin = 0.5 # Minimum radius
rMax = 1.0 # Maximum radius
s = 0.0 # Spacing in mm between speckles (prior to random shifts)
maxShift = 3.0*(s/2) # random shift magnitude
pointSpacing = s+2*rMax # Initial speckle spacing

# Setting up grid
minX = pointSpacing
maxX = wx-pointSpacing
minY = pointSpacing
maxY = wy-pointSpacing
xRange = minX:pointSpacing:maxX 
pointSpacing_Y = pointSpacing.*0.5*sqrt(3)
yRange = minY:pointSpacing_Y:maxY
sx = pointSpacing/4

# Initialise XML
doc,svg_node = svg_initialize(wx,wy; )
pc_green = [wx/2.0, rLogo]
pc_purple = [wx/2.0, 2*rLogo] - rLogo .* [cosd(210.0), sind(210.0)]
pc_red = [wx/2.0, 2*rLogo] - rLogo .* [-cosd(210.0), sind(210.0)]

nSet = [4, 5, 6, 7, 8, 25]
for (j,y) in enumerate(yRange) # Y steps in grid
    for (i,x) in enumerate(xRange) # X steps in grid       
        n = rand(nSet,1)[1]
        if n == 4
            T = 0.25*pi .+ range(0,2*pi,n+1) 
        else
            T = range(0,2*pi,n+1) 
        end
        if iseven(j) # Shift over every second row of points
            x = x+sx
        else
            x = x-sx
        end  

        # Create polyline points
        cx = (x + (maxShift*rand()-maxShift/2))
        cy = (y + (maxShift*rand()-maxShift/2))            
        rx = rMin +(rMax-rMin)*rand()
        ry = rMin +(rMax-rMin)*rand()
        a = 2*pi*rand()            
        R = [cos(a) -sin(a); sin(a) cos(a)]        
        P = [ R*[rx*cos(t),ry*sin(t)] .+ [cx,cy] for t in T]
                
        # Add polyline to svg      
        d1 = sqrt((x-pc_green[1])^2 + (y-pc_green[2])^2)  
        d2 = sqrt((x-pc_red[1])^2 + (y-pc_red[2])^2)  
        d3 = sqrt((x-pc_purple[1])^2 + (y-pc_purple[2])^2)  
        if d1 <= 3/4*rLogo
            c = ceil.(Int,255 .*[0.22, 0.596, 0.149]) # RGB color
        elseif d2 <= 3/4*rLogo
            c = ceil.(Int,255 .*[0.796, 0.235, 0.2]) # RGB color
        elseif d3 <= 3/4*rLogo
            c = ceil.(Int,255 .*[0.584, 0.345, 0.698]) # RGB color
        else
            c = rand(1)[1]/2.0 .* [255, 255, 255] # Random RGB color
        end
        addpolyline(svg_node,P; fill="rgb("*string(c[1])*","*string(c[2])*","*string(c[3])*")")
    end
end

# Write svg
fileName = joinpath(fleckitdir(),"assets","spleckes_rgb_02.svg")
svg_write(fileName,doc)