function [GeS] = knee_natural_motion(flexion_angle,V,varargin)
% Simply return the position and orientation of the femur with respect to
% the tibia anatomical reference system at the given flexion_angle.
% The coordinate are expressed according to a variation of the Grood and 
% Suntay notation and are evaluated through fourth order polinomial

% V is volume of the femur of the current subject under analysis [mm^3]. This input
% is set to a default value (Volume of the map reference femur) if not
% given as input. In that case, the result given as output is not scaled
% to the specific subject

% check
if nargin < 1
    error('Not enough input arguments in "knee_natural_motion"')
    % V is the only optional input
elseif nargin < 2
    % If V is not given, set V to a default value (Volume of the map
    % reference femur)
    V = 548666.453; % [mm^3]
end

Coeff = load('Polinomial coefficient materixes\Natural_motion_coefficients.txt');

GeS(1) = flexion_angle;
GeS(2) = Coeff(1,1)*flexion_angle^4 + Coeff(1,2)*flexion_angle^3 + Coeff(1,3)*flexion_angle^2 + + Coeff(1,4)*flexion_angle + + Coeff(1,5);
GeS(3) = Coeff(2,1)*flexion_angle^4 + Coeff(2,2)*flexion_angle^3 + Coeff(2,3)*flexion_angle^2 + + Coeff(2,4)*flexion_angle + + Coeff(2,5);
GeS(4) = Coeff(3,1)*flexion_angle^4 + Coeff(3,2)*flexion_angle^3 + Coeff(3,3)*flexion_angle^2 + + Coeff(3,4)*flexion_angle + + Coeff(3,5);
GeS(5) = Coeff(4,1)*flexion_angle^4 + Coeff(4,2)*flexion_angle^3 + Coeff(4,3)*flexion_angle^2 + + Coeff(4,4)*flexion_angle + + Coeff(4,5);
GeS(6) = Coeff(5,1)*flexion_angle^4 + Coeff(5,2)*flexion_angle^3 + Coeff(5,3)*flexion_angle^2 + + Coeff(5,4)*flexion_angle + + Coeff(5,5);

% Scaling
GeS  = scale_GeS(GeS,V);




