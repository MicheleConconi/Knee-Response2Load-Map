function [scaled_GeS] = scale_GeS(GeS,V,varargin)
% This function computes the scaling factor and applies it to the current
% pose given as input. Scaling factor is calculated as the cubic root of
% the ratio between the Volume of the femur of the current subject (V) and
% the Volume of the map reference femur (V_reference).
%
%INPUT
% GeS: the pose of the femur relative to the tibia, or vice versa. Unscaled
% (output of the compliance pose calculation). Rotation are in degree,
% translation in mm. The vector contain in the order:
% [flexion_angle, AA, IE, X, Y, Z]
%
% V: volume of the femur of the current subject under analysis
%
%OUTPUT
% scaled_GeS: the pose of the femur relative to the tibia, or vice versa.
% Scaled to the current subject under analysis. Rotation are in degree,
% translation in mm. The vector contain in the order:
% [flexion_angle, AA, IE, X, Y, Z]

V_reference = 548666.453; % [mm^3]
if nargin < 2
    V = V_reference;
end


scaling = (V/V_reference)^(1/3);

scaled_GeS = GeS;
scaled_GeS(:,4:6)=scaling.*GeS(:,4:6);