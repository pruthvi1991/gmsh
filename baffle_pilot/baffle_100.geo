bb_length = 20;		// Bounding Box length
bb_width = 20;		// Bounding Box width
c_l = 1;			// chord length
c_res = 100;			// Number of cells on the chord. Used in the c_res parameter below
buffer = 0.75*c_l;	// Vortex Shedding Region. Assuming that vortices are not bigger than 0.5 chords
// c_res = c_l/cf;		// Length of each element on the chord
bl_res = c_res*1.2;		// Length of each element normal to the chord
buffer_res = c_res*0.5;	// Area adjacent to leading and trailing edges
ff_res = 2 * (1/c_res);			// Far field resolution behind the airfoil

// Bounding box dimensions

Point(1) = {-bb_length, bb_width, 0, 1.0};	
Point(2) = {bb_length, bb_width, 0, 1.0};
Point(3) = {bb_length, -bb_width, 0, 1.0};
Point(4) = {-bb_length, -bb_width, 0, 1.0};

// Vortex Shedding Region i.e the region surrounding the wing. This is a region of special interest and is much larger than that for a steady problem. Vortices are shed and the gradients occur over a larger region.

Point(5) = {-c_l, -buffer, 0, 1.0};	
Point(6) = {-c_l, 0, 0, 1.0};
Point(7) = {-c_l, buffer, 0, 1.0};
Point(8) = {-0.5*c_l, buffer, 0, 1.0};
Point(9) = {0.5*c_l, buffer, 0, 1.0};
Point(10) = {c_l, buffer, 0, 1.0};
Point(11) = {c_l, 0, 0, 1.0};
Point(12) = {c_l, -buffer, 0, 1.0};
Point(13) = {0.5*c_l, -buffer, 0, 1.0};
Point(14) = {-0.5*c_l, -buffer, 0, 1.0};


// Wing region. This is just a line which will be extruded into a surface and then converted into a baffle in OpenFOAM.

Point(15) = {-0.5*c_l, 0, 0, 1.0};
Point(16) = {0.5*c_l, 0, 0, 1.0};

// Defining Lines

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 9};
Line(9) = {9, 10};
Line(10) = {10, 11};
Line(11) = {11, 12};
Line(12) = {12, 13};
Line(13) = {13, 14};
Line(14) = {14, 5};
Line(15) = {6, 15};
Line(16) = {15, 16};
Line(17) = {16, 11};
Line(18) = {8, 15};
Line(19) = {9, 16};
Line(20) = {16, 13};
Line(21) = {15, 14};
// Line(22) = {17, 18, 19, 20};

// Defining Line Loops

Line Loop(1) = {1, 2, 3, 4};
Line Loop(2) = {5, 15, 21, 14};
Line Loop(3) = {6, 7, 18, -15};
Line Loop(4) = {18, 16, -19, -8};
Line Loop(5) = {9, 10, -17, -19};
Line Loop(6) = {11, 12, -20, 17};
Line Loop(7) = {16, 20, 13,-21};
Line Loop(8) = {5, 6, 7, 8, 9, 10, 11, 12, 13, 14};

// Defining Surfaces

Plane Surface(1) = {1,8};
Plane Surface(2) = {2};
Plane Surface(3) = {3};
Plane Surface(4) = {4};
Plane Surface(5) = {5};
Plane Surface(6) = {6};
Plane Surface(7) = {7};

// Definning some points to refine the mesh downstream of the airfoil
//Point(17) = {3*c_l, 0, 0, ff_res};
//Point(18) = {6*c_l, 0, 0, ff_res*2};
//Point(19) = {9*c_l, 0, 0, ff_res*3};
//Point(20) = {12*c_l, 0, 0, ff_res*4};
//Point{20} In Surface{1};


Transfinite Line {16, 8, 13} = c_res Using Bump 0.4; // Progression 1.03;
Transfinite Line {7, -14, 9, -12} = buffer_res; // Using Progression 1.02;//Bump 0.4;
Transfinite Line {-5, 6, -10, 11, -18, -19, 20, 21} = bl_res Using Progression 1.01; // Using Bump 0.1;
Transfinite Line {15, -17} = buffer_res Using Bump 0.25;
// Transfinite Line {6,26,28,12} = chord_factor Using Bump 0.4; //Bump 0.05;

Transfinite Surface{2} = {}; // {10,13,12,11};
Transfinite Surface{3} = {}; //{10,13,12,11};
Transfinite Surface{4} = {}; //{10,13,12,11};
Transfinite Surface{5} = {}; //{10,13,12,11};
Transfinite Surface{6} = {}; // {10,13,12,11};
Transfinite Surface{7} = {}; //{10,13,12,11};

Recombine Surface{1,2,3,4,5,6,7};
//Recombine Surface{1};

Extrude {0, 0, -1}
 {
  Surface{1,2,3,4,5,6,7};
  Layers{1};
  Recombine;
 }

Physical Surface("inlet") = {52};
Physical Surface("topAndBottom") = {40, 48};
Physical Surface("outlet") = {44};
Physical Surface("front") = {1, 3, 4, 5, 6, 7, 2};
Physical Surface("back") = {93, 181, 159, 137, 115, 225, 203};
Physical Surface("wing") = {150};
Physical Volume(232) = {1, 4, 3, 2, 7, 6, 5};