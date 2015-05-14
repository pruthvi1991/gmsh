// Gmsh project created on Sun Apr 26 21:08:43 2015

bb_length = 20;		// Bounding Box length
bb_width = 20;		// Bounding Box width
plate_length = 1;	// flat plate length
plate_width = plate_length/2000;	// flat plate width
bl_thick = plate_length/2;	// Bounding box where structured grid begins. This is the region of vortex shedding. Dimension ~ 1 chord length
bl_length = bl_thick*2;		// Same as above. Note that vortices are shed and the viscous region is much larger than for steady flow
chord_factor = 150;		// Number of cells on the chord
chord_ortho = chord_factor/2; 	// Cells in the orthogonal direction

//********** Bounding Box ***********//

Point(1) = {-bb_length, bb_width, 0, 1.0};	
Point(2) = {bb_length, bb_width, 0, 1.0};
Point(3) = {bb_length, -bb_width, 0, 1.0};
Point(4) = {-bb_length, -bb_width, 0, 1.0};

//***********************************//

//********** Outer boundary of the structured grid ***********//

Point(5) = {-bl_length, bl_thick, 0, 0.1};
Point(6) = {-(plate_length/2), bl_thick, 0, 0.1};
Point(7) = {(plate_length/2), bl_thick, 0, 0.1};
Point(8) = {bl_length, bl_thick, 0, 0.1};

Point(9) = {bl_length, plate_width, 0, 0.1};
Point(10) = {bl_length, -plate_width, 0, 0.1};
Point(11) = {bl_length, -bl_thick, 0, 0.1};
Point(12) = {plate_length/2, -bl_thick, 0, 0.1};

Point(13) = {-(plate_length/2), -bl_thick, 0, 0.1};
Point(14) = { -bl_length, -bl_thick, 0, 0.1};
Point(15) = {-bl_length, -plate_width, 0, 0.1};
Point(16) = {-bl_length, plate_width, 0, 0.1};

//**************************************************************//

//***************** Flat plate *****************//

Point(17) = {-(plate_length/2), (plate_width/2), 0, 0.1};
Point(18) = {(plate_length/2), (plate_width/2), 0, 0.1};
Point(19) = {(plate_length/2), -(plate_width/2), 0, 0.1};
Point(20) = {-(plate_length/2), -(plate_width/2), 0, 0.1};

//***********************************************//

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
Line(14) = {14, 15};
Line(15) = {15, 16};
Line(16) = {16, 5};

Line(17) = {16, 17};
Line(18) = {17, 6};
Line(19) = {18, 7};
Line(20) = {9, 18};
Line(21) = {10, 19};
Line(22) = {19, 12};
Line(23) = {20, 13};
Line(24) = {15, 20};
Line(25) = {20, 17};
Line(26) = {17, 18};
Line(27) = {18, 19};
Line(28) = {19, 20};

Line Loop(1) = {1,2,3,4};
Line Loop(2) = {5,6,7,8,9,10,11,12,13,14,15,16};
Line Loop(3) = {5,-18,-17,16};
Line Loop(4) = {6,-19,-26,18};
Line Loop(5) = {19,7,8,20};
Line Loop(6) = {-27,-20,9,21};
Line Loop(7) = {-21,10,11,-22};
Line Loop(8) = {-28,22,12,-23};
Line Loop(9) = {23,13,14,24};
Line Loop(10) = {15,17,-25,-24};

Plane Surface(1) = {1,2};
Plane Surface(2) = {3};
Plane Surface(3) = {4};
Plane Surface(4) = {5};
Plane Surface(5) = {6};
Plane Surface(6) = {7};
Plane Surface(7) = {8};
Plane Surface(8) = {9};
Plane Surface(9) = {10};

Transfinite Line {16,18,19,-8,-14,23,22,10} = chord_factor Using Progression 1.03;
Transfinite Line {-17,-24,-20,-21,-5,7,13,-11} = chord_ortho Using Progression 1.03;//Bump 0.4;
Transfinite Line {27,25,9,15} = 10; // Using Bump 0.1;
Transfinite Line {6,26,28,12} = chord_factor Using Bump 0.4; //Bump 0.05;

Transfinite Surface{2} = {}; // {10,13,12,11};
Transfinite Surface{3} = {}; //{10,13,12,11};
Transfinite Surface{4} = {}; //{10,13,12,11};
Transfinite Surface{5} = {}; //{10,13,12,11};
Transfinite Surface{6} = {}; // {10,13,12,11};
Transfinite Surface{7} = {}; //{10,13,12,11};
Transfinite Surface{8} = {}; //{10,13,12,11};
Transfinite Surface{9} = {}; //{10,13,12,11};

Recombine Surface{2,3,4,5,6,7,8,9};

Extrude {0, 0, 1}
 {
  Surface{1,2,3,4,5,6,7,8,9};
  Layers{1};
  Recombine;
 }


