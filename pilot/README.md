This is an attempt to mesh a flatplate using a hybrid(structured+unstructured mesh. The geometry has an outer bounding box and an inner region of interest where a strctured mesh is generated. The inner region is divided into 8 regions to generate an orthogonal mesh. The region inbetween the outer bounding box and the inner structured mesh is unstructured.

In the current file directory type:

gmsh flatplate_bl.geo

Then press the keyboard key '3' to view the mesh. The plate is very thin so zoom in a lot to view the plate.

Alternately you can also try the following

gmsh -3 flatplate_bl.geo  # to execute the solver

gmsh flatplate_bl.msh  # to view the mesh
