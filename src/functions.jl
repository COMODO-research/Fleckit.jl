# Call required packages
using XML
using Printf 

"""
    fleckitdir()

Returns Fleckit path

# Description 
This function simply returns the string for the Fleckit path. This is helpful for instance to load items, such as images, from the `assets`` folder. 
"""
function fleckitdir()
    joinpath(@__DIR__, "..")
end

"""
    svg_initialize(w::Tw, h::Th; fill=nothing) where Tw<:Real where Th<:Real

Initialises svg XML

# Description
This function initialises an svg XML. 
"""
function svg_initialize(w::Tw, h::Th; fill=nothing) where Tw<:Real where Th<:Real
    # Define document level
    doc = XML.Document()

    # Define declaration: <?xml version="1.0" encoding="UTF-8"?>
    declarationNode = XML.Declaration(version = "1.0", encoding = "UTF-8")
    push!(doc, declarationNode)

    # Define svg node: <svg>
    svg_node = XML.Element("svg"; width=string(w)*"mm", height=string(h)*"mm", viewBox = "0 0 "*string(w)*" "*string(h))
    push!(doc, svg_node)

    # Add comment: <!--Created using Julia-->
    comment_node = XML.Comment("Created using Fleckit in Julia")
    push!(svg_node, comment_node)
    
    # Add background rectangle and color
    if ~isnothing(fill)
        aen(svg_node,"rect"; x=0.0, y=0.0, width=w, height=h, fill=fill)
    end

    return doc,svg_node
end


"""
    aen(main_node::Node,sub_node_name::String, args...; kwargs...)

Adds xml element node

# Description
This function's name aen is short for "add element node".
"""
function aen(main_node::Node,sub_node_name::String, args...; kwargs...)
    if isnothing(args)
        sub_node = XML.Element(sub_node_name; kwargs...)    
    else
        sub_node = XML.Element(sub_node_name, args...; kwargs...)    
    end
    push!(main_node, sub_node)
    return sub_node
end

"""
    addpolyline(svg_node, P; fill="black")  

Adds polyline to svg

# Description
This function ads a polyline entry to the xml type svg specified by `svg_node`. 
The polygon is defined by the points in the vector `P`. 
"""
function addpolyline(svg_node, P; fill="black")
    # Format coordinate/point string
    points_string = ""
    for p in P
        points_string *= @sprintf("%.6f, %.6f ", p[1], p[2])
    end

    # Add polyline to svg
    aen(svg_node,"polyline"; points = points_string[1:end-1], fill=fill)
end

"""
    svg_write(fileName, doc)

Writes svg to file

# Description
This function writes the svg image defined by the xml doc `doc` to the file width
the file name `filename`. 
"""
function svg_write(fileName, doc)
    XML.write(fileName, doc)
end

"""
    serp(a,b,t; func=:perlin)

Defined Perlin smoothing function

# Description
This function returns a desired Perlin noise smoothing function
"""
function serp(a,b,t; func=:perlin)
    if func == :smoothstep
        q = 3.0*t^3 - 2.0*t^3 # Smoothstep
    elseif func == :cosine
        q = 0.5 .- 0.5.*cos.(t*pi) # Cosine
    elseif func == :linear
        q = t # Linear 
    elseif func == :perlin
        # Fade function q = 6t⁵-15t⁴+10t³    
        q = t^3 * (t * (6.0 * t - 15.0) + 10.0) # Perlin fade function
    end
    return (1.0-q)*a + q*b
end

"""
    checkerboardImage(fileName, gridSize, squareSize; paperSize=:A4, color1="black", color2="white", colorBackground="white")

Creates checkerboard svg

# Description
This function creates an svg file for a checkboard. The inputs include: 
* `fileName`, which defines the svg file name (should include the file extension)
* `gridSize`, the number of cells in the widht/heigh direction for the checkboard,
 e.g. the default is [7, 10]. 
* `squareSize`, sets the width of the checkboard cells. 
Next the following optional keyword arguments are supported: 
* `paperSize`, the default is `:A4`
* `color1`, this is the color of tile type 1, the default is "black", all svg 
color strings are supported. 
* `color2`, this is the color of tile type 2, the default is "white", all svg 
color strings are supported. 
* `colorBackground`, this is the color of the background, the default is 
"white", all svg color strings are supported. 
"""
function checkerboardImage(fileName::String, gridSize=[7,10], squareSize=20.0; paperSize=:A4, color1="black", color2="white", colorBackground="white")
    # Define page canvas parameters 
    if paperSize == :A3
        wx = 297 # Width 
        wy = 420 # Height
    elseif paperSize == :A4 
        wx = 210 # Width  
        wy = 297 # Height   
    end
    
    checkBoardSize = squareSize .* gridSize
    if checkBoardSize[1]>wx || checkBoardSize[2]>wy
        throw(ArgumentError("Grid does not fit paper size"))
    end

    # Initialise XML
    doc,svg_node = svg_initialize(wx, wy; fill=colorBackground)

    P_square = squareSize.*[[-0.5,  -0.5], 
                            [ 0.5,  -0.5], 
                            [ 0.5,   0.5], 
                            [-0.5,   0.5]]
   
    xs = (wx - checkBoardSize[1])/2.0
    ys = (wy - checkBoardSize[2])/2.0
    yc = ys + squareSize/2.0
    for i_y in 1:gridSize[2]        
        xc = xs + squareSize/2.0
        for i_x in 1:gridSize[1]
            P = [p+[xc, yc] for p in P_square]                                                
            if iseven(i_y) == iseven(i_x)           
               addpolyline(svg_node,P; fill=color1) # Add polyline to svg
            elseif color2 != fill
                addpolyline(svg_node,P; fill=color2) # Add polyline to svg
            end
            xc += squareSize
        end
        yc += squareSize
    end

    # Write svg    
    svg_write(fileName,doc)
end
