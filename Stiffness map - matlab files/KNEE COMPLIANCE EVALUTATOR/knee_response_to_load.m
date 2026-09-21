function [D_GeS] = knee_response_to_load(flexion_angle,M,F,V,varargin)
% This function return the variation in femur position and orientation with
% respect to the values observed for the knee natural motion at the
% considered flexion_angle.
% Displacement are obtained as the linar combination of the displacement
% induced by each load component separately.
%
%INPUT
% flexion_angle = the considered knee flexion angle, [°]
% M = the torque vector (1X3) applied to the femur, expressed in the tibial
% anatomical reference system, [Nm]. The z component is assumed to be null
% since the knee is assumed to provide no resistance to flexion.
% F = the force vector (1X3) applied to the knee, expressed in the tibial
% anatomical reference system, [N].
% V = volume of the femur of the current subject under analysis [mm^3]. This input
% is set to a default value (Volume of the map reference femur) if not
% given as input. In that case, the result given as output is not scaled
% to the specific subject

%OUTPUT
% D_GeS = vector of displacement (1X6) with respect to the configuration of the
% femur relative to the tibia at flexion_angle. The vector contain in the
% order:
% [0, D_AA, D_IE, D_X, D_Y, D_Z]
% Rotation are in degree, translation in mm.
% The first component is always null since load is assumed to leave flexion
% unaffected


% check
if nargin < 3
    error('Not enough input arguments in "knee_response_to_load"')
    % V is the only optional input
elseif nargin < 4
    % If V is not given, set V to a default value (Volume of the map
    % reference femur)
    V = 548666.453; % [mm^3]
end

% Correction on the moment around the z-axis. It was assumed to be zero,
% but it may not be zero due to noise and small errors, therefore, we set
% it to zero.
if M(3)~=0
    error('No torque allowed along the flexion axis')
end

% load the coefficients
if M(1) >= 0
    CMx = load('Polinomial coefficient materixes\Mx_positive_coefficients.txt');
else
    CMx = load('Polinomial coefficient materixes\Mx_negative_coefficients.txt');
end

% load the coefficients
if M(2) >= 0
    CMy = load('Polinomial coefficient materixes\My_positive_coefficients.txt');
else
    CMy = load('Polinomial coefficient materixes\My_negative_coefficients.txt');
end

if F(1) >= 0
    CFx = load('Polinomial coefficient materixes\Fx_positive_coefficients.txt');
else
    CFx = load('Polinomial coefficient materixes\Fx_negative_coefficients.txt');
end

if F(2) >= 0
    CFy = load('Polinomial coefficient materixes\Fy_positive_coefficients.txt');
else
    CFy = load('Polinomial coefficient materixes\Fy_negative_coefficients.txt');
end

if F(3) >= 0
    CFz = load('Polinomial coefficient materixes\Fz_positive_coefficients.txt');
else
    CFz = load('Polinomial coefficient materixes\Fz_negative_coefficients.txt');
end

% rotations and displacements due to Mx
D_Mx(1) = response_to_load_fitting_model(CMx(1,:),flexion_angle,M(1));
D_Mx(2) = response_to_load_fitting_model(CMx(2,:),flexion_angle,M(1));
D_Mx(3) = response_to_load_fitting_model(CMx(3,:),flexion_angle,M(1));
D_Mx(4) = response_to_load_fitting_model(CMx(4,:),flexion_angle,M(1));
D_Mx(5) = response_to_load_fitting_model(CMx(5,:),flexion_angle,M(1));

% rotations and displacements due to My
D_My(1) = response_to_load_fitting_model(CMy(1,:),flexion_angle,M(2));
D_My(2) = response_to_load_fitting_model(CMy(2,:),flexion_angle,M(2));
D_My(3) = response_to_load_fitting_model(CMy(3,:),flexion_angle,M(2));
D_My(4) = response_to_load_fitting_model(CMy(4,:),flexion_angle,M(2));
D_My(5) = response_to_load_fitting_model(CMy(5,:),flexion_angle,M(2));

% rotations and displacements due to Fx
D_Fx(1) = response_to_load_fitting_model(CFx(1,:),flexion_angle,F(1));
D_Fx(2) = response_to_load_fitting_model(CFx(2,:),flexion_angle,F(1));
D_Fx(3) = response_to_load_fitting_model(CFx(3,:),flexion_angle,F(1));
D_Fx(4) = response_to_load_fitting_model(CFx(4,:),flexion_angle,F(1));
D_Fx(5) = response_to_load_fitting_model(CFx(5,:),flexion_angle,F(1));

% rotations and displacements due to Fy
D_Fy(1) = response_to_load_fitting_model(CFy(1,:),flexion_angle,F(2));
D_Fy(2) = response_to_load_fitting_model(CFy(2,:),flexion_angle,F(2));
D_Fy(3) = response_to_load_fitting_model(CFy(3,:),flexion_angle,F(2));
D_Fy(4) = response_to_load_fitting_model(CFy(4,:),flexion_angle,F(2));
D_Fy(5) = response_to_load_fitting_model(CFy(5,:),flexion_angle,F(2));

% rotations and displacements due to Fy
D_Fz(1) = response_to_load_fitting_model(CFz(1,:),flexion_angle,F(3));
D_Fz(2) = response_to_load_fitting_model(CFz(2,:),flexion_angle,F(3));
D_Fz(3) = response_to_load_fitting_model(CFz(3,:),flexion_angle,F(3));
D_Fz(4) = response_to_load_fitting_model(CFz(4,:),flexion_angle,F(3));
D_Fz(5) = response_to_load_fitting_model(CFz(5,:),flexion_angle,F(3));

% Displacement is obtained as the linar combination of the displacement
% induced by each load component separately.
Total_displacement = D_Mx + D_My + D_Fx + D_Fy + D_Fz;

% No displacement on the flexion angle (not resisted)
D_GeS = [0,Total_displacement];

% Scaling
D_GeS = scale_GeS(D_GeS,V);


end


