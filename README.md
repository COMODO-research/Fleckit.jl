[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17517624.svg)](https://doi.org/10.5281/zenodo.17517624) 

![](assets/img/logo.png)  

# About Fleckit
Julia code to generate speckled images for digital image correlation studies. The image below shows the speckle types currently supported. Image A shows Perlin noise based speckling, which is a pixelated image containing continuous gray scales. Image B, C, and D show speckles created as polygons in an `.svg` image description. 

<img src="https://github.com/COMODO-research/Fleckit.jl/blob/main/assets/img/speckle_types.jpg" alt="Speckle types" width="50%"/>  
# Installation
```julia
julia> ]
(@v1.xx) pkg> add https://github.com/COMODO-research/Fleckit.jl.git
```

# Getting started
To get started install the package, study the documentation, and test some of the demos provided in the [`examples`](https://github.com/COMODO-research/Fleckit.jl/tree/main/examples) folder. 

* Some of the demos include the creation of images for different states of deformation, e.g. [`demo_svg_speckles_rgb_02.jl`](https://github.com/COMODO-research/Fleckit.jl/blob/main/examples/demo_svg_speckles_rgb_02.jl) 

<img src="https://github.com/COMODO-research/Fleckit.jl/blob/main/assets/img/speckle_deform.gif" alt="Speckle types" width="50%"/>

* Demo [`demo_checkboardImage`](https://github.com/COMODO-research/Fleckit.jl/tree/main/examples/demo_checkerboardImage.jl) shows the creation of a checkerboard image which is useful for camera calibration purposes. 

<img src="https://github.com/COMODO-research/Fleckit.jl/blob/main/assets/img/checkerboard_A4_7x10.jpg" alt="Speckle types" width="50%"/>


