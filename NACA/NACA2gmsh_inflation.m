#!/usr/bin/octave -qf

% ---------------------- START OF INPUT PARAMETER REGION ------------------- %

% Foil geometry
c = 1;					% Geometric chord length
s = 0;					% Span (along y-axis)
deg_to_radians = pi/180;	% Conversion constant
alpha = 0*deg_to_radians;	% Angle of attack (in radians)
inflation_factor_x = 1.5;	% Size of inflation layer w.r.t aifoil
inflation_factor_z = 4;	% Size of inflation layer w.r.t aifoil

NACA = [0 0 1 2];		% NACA 4-digit designation as a row vector;

% Surface resolution parameters
Ni = 100;            % Number of interpolation points along the foil

% ------------------------- END OF INPUT PARAMETER REGION -------------------- %


% ---------------------------------- LICENCE  -------------------------------- %
%                                                                              %
%     Copyrighted 2011, 2012 by Håkon Strandenes, hakostra@stud.ntnu.no        %
%                                                                              % 
%     This program is free software: you can redistribute it and/or modify     %
%     it under the terms of the GNU General Public License as published by     %
%     the Free Software Foundation, either version 3 of the License, or        %
%     (at your option) any later version.                                      %
%                                                                              %
%     This program is distributed in the hope that it will be useful,          %
%     but WITHOUT ANY WARRANTY; without even the implied warranty of           %
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            %
%     GNU General Public License for more details.                             %
%                                                                              %
%     You should have received a copy of the GNU General Public License        %
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.    %
% ---------------------------------------------------------------------------- %


% Create a vector with x-coordinates, camber and thickness
beta=linspace(0,pi,Ni);
x = c*(0.5*(1-cos(beta)));
z_c = zeros(size(x));
z_t = zeros(size(x));
theta = zeros(size(x));


% Values of m, p and t
m = NACA(1)/100;
p = NACA(2)/10;
t = (NACA(3)*10 + NACA(4))/100;


% Calculate thickness
% The upper expression will give the airfoil a finite thickness at the trailing
% edge, witch might cause trouble. The lower expression is corrected to give 
% zero thickness at the trailing edge, but the foil is strictly speaking no
% longer a proper NACA airfoil.
%
% See http://turbmodels.larc.nasa.gov/naca4412sep_val.html
%     http://en.wikipedia.org/wiki/NACA_airfoil

%z_t = (t*c/0.2) * (0.2969.*(x/c).^0.5 - 0.1260.*(x/c) - 0.3516.*(x/c).^2 + 0.2843.*(x/c).^3 - 0.1015.*(x/c).^4);
z_t = (t*c/0.2) * (0.2969.*(x/c).^0.5 - 0.1260.*(x/c) - 0.3516.*(x/c).^2 + 0.2843.*(x/c).^3 - 0.1036.*(x/c).^4);


% Calculate camber
if (p > 0)
  % Calculate camber
  z_c = z_c + (m.*x/p^2) .* (2*p - x/c) .* (x < p*c);
  z_c = z_c + (m.*(c-x)/(1-p)^2) .* (1 + x/c - 2*p) .* (x >= p*c);


  % Calculate theta-value
  theta = theta + atan( (m/p^2) * (2*p - 2*x/c) ) .* (x < p*c);
  theta = theta + atan( (m/(1-p)^2) * (-2*x/c + 2*p) ) .* (x >= p*c);
end


% Calculate coordinates of upper surface
Xu = x - z_t.*sin(theta);
Zu = z_c + z_t.*cos(theta);

Xu_inflated = Xu*inflation_factor_x - (inflation_factor_x -1)*c/3.5;
Zu_inflated = Zu*inflation_factor_z;

% Calculate coordinates of lower surface
Xl = x + z_t.*sin(theta);
Zl = z_c - z_t.*cos(theta);

Xl_inflated = Xl*inflation_factor_x - (inflation_factor_x -1)*c/3.5;
Zl_inflated = Zl*inflation_factor_z;

% Rotate foil to specified angle of attack
upper = [cos(alpha), sin(alpha); -sin(alpha), cos(alpha)] * [Xu ; Zu];
lower = [cos(alpha), sin(alpha); -sin(alpha), cos(alpha)] * [Xl ; Zl];

upper_inflated = [cos(alpha), sin(alpha); -sin(alpha), cos(alpha)] * [Xu_inflated ; Zu_inflated];
lower_inflated = [cos(alpha), sin(alpha); -sin(alpha), cos(alpha)] * [Xl_inflated ; Zl_inflated];


% Merge upper and lower surface (NB: Assume that the trailing edge is sharp)
% (see comments w.r.t. thickness calculation above)
X = [ upper(1,:) lower(1,Ni-1:-1:2) ];
Z = [ upper(2,:) lower(2,Ni-1:-1:2) ];

X_inflated = [ upper_inflated(1,:) lower_inflated(1,Ni-1:-1:2) ];
Z_inflated = [ upper_inflated(2,:) lower_inflated(2,Ni-1:-1:2) ];

N = length(X);
disp(N)

% Define inflation layer co-ordinates as a factor of the wing co-ordinates
%X_inflation = X*inflation_factor_x - (inflation_factor_x -1)*c/2;
%Z_inflation = Z*inflation_factor_z; % + ((inflation_factor_z -1)/2)*sin(alpha);

% Open file
fo = fopen('NACA_coordinates.geo', 'w');

% Write points
for i=1:N
	disp(i)
	fprintf(fo, 'Point(%d) = {%f, %f, 0, 1};\n', i, X(i), Z(i));
end

fprintf(fo, '\n' );

for i=1:N
	disp(i)
	j = i+N;
	fprintf(fo, 'Point(%d) = {%f, %f, 0, 1};\n', j, X_inflated(i), Z_inflated(i));
end

% Close file
fclose(fo);