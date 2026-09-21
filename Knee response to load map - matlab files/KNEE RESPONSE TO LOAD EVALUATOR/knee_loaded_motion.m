function [GeS,NGeS,DGeS] = knee_loaded_motion(flexion_angle_in, M_in, F_in, moving_femur,right_side,V,varargin)
% This function returns the position and orientation of the femur with respect to
% the tibia anatomical reference system at the given flexion_angle under the effect of some external loads.
% The coordinate are expressed according to a variation of the Grood and
% Suntay notation and are evaluated as the sum of femur natural motion (computed trugh the function knee_natural_motion.m)
% the displacement induced by external loads (computed trugh the function knee_response_to_load.m)
% N.B.: all translation and rotation are expressed with respect to
% right-hand frame, without appling any correction in the sign to account
% for medical convention.
%
%INPUT
% flexion_angle_in: the considered knee flexion angle, [°]. Positive values
%imply flexion of the femur with respect to the tibia. In the case of 
%mapping the motion of the tibia with respect to the femur, no sing correction is expected,
%thus the motion of the tibia with respect to the femur is
%associated with negative value
%
% M_in: the torque vector (1X3) applied to the femur, expressed in the tibial
%anatomical reference system, [Nm]. In the case of mapping the motion of
%the tibia with respect to the femur, M is the torque vector applied to the tibia,
%expressed in the femoral anatomical reference system. In both cases the z component is assumed to be null
%since the knee is assumed to provide no resistance to flexion.
%
% F_in: the force vector (1X3) applied to the femur, expressed in the tibial
%anatomical reference system, [N]. In the case of mapping the motion of
%the tibia with respect to the femur, M is the force vector applied to the tibia,
%expressed in the femoral anatomical reference system.
%
% moving_femur: is true if we are mapping the motion of the femur relative
% to the tibia, false in the opposite case
%
% right_side: is true for a right leg, false in the opposite case
%
% V: volume of the femur of the current subject under analysis [mm^3]. This input
% is set to a default value (Volume of the map reference femur) if not
% given as input. In that case, the result given as output is not scaled
% to the specific subject
%
%OUTPUT
% GeS: the pose of the femur relative to the tibia at flexion_angle_in. 
% Rotation are in degree, translation in mm. The vector contain in the
% order: [flexion_angle, AA, IE, X, Y, Z]
% In the case of mapping the motion of the tibia with respect to the femur, 
% no sing correction is applied
% NGeS: natural pose of the femur relative to the tibia at flexion_angle_in.
% DGeS: displacement from natural pose of the femur relative to the tibia
% at flexion_angle_in.

% check
if nargin < 5
    error('Not enough input arguments in "knee_loaded_motion"')
    % V is the only optional input
elseif nargin < 6
    % If V is not given, set V to a default value (Volume of the map
    % reference femur)
    V = 548666.453; % [mm^3]
end


% In the case we are interested in the motion of the tibia wrt the femur,
% the sign of the flexion anlge need to be inverted since our motion is
% originally evaluated for the femur relative to the tibia
if(moving_femur == false)
    flexion_angle_FwrtT = -flexion_angle_in;
else
    flexion_angle_FwrtT = flexion_angle_in;
end

% Evaluate the pose of the femur relative to the tibia at the given flexion
% angle. Natural motion
NGeS_FwrtT = knee_natural_motion(flexion_angle_FwrtT);

% Compliance is expressed for right legs. In case of a left leg, motion
% needs thus to be converted
if right_side == false
   NGeS_FwrtT(2)=-NGeS_FwrtT(2);
   NGeS_FwrtT(3)=-NGeS_FwrtT(3);
   NGeS_FwrtT(6)=-NGeS_FwrtT(6);
end


% Evaluate the displacement due to external loads

% In the case we are interested in the motion of the tibia wrt the femur,
% loads are assumed to be expressed in the femur anatomical frame. However,
% since knee response to load is computed for the femur relative to the tibia
% with the load acting on the femur expressed in the tibia anatomical
% reference system, in order to compute the displacement we need first to
% convert the external loads.

%% Loads
if(moving_femur == false)
    T_loads_tib2fem = T_Move2Position(NGeS_FwrtT,true);
    F_Ext_inTib_onFem = -(T_loads_tib2fem(1:3,1:3)*F_in')';
    M_Ext_inTib_onFem = (-(T_loads_tib2fem(1:3,1:3)*M_in') + cross(T_loads_tib2fem(1:3,4),F_Ext_inTib_onFem')/1000)'; %1000 is necessary because the moment is in Nm, but the translational matrix vector is in mm
else
    F_Ext_inTib_onFem = F_in;
    M_Ext_inTib_onFem = M_in;
end

% Compliance is expressed for right legs. In case of a left leg, loads need
% thus to be converted
if right_side == false
   M_Ext_inTib_onFem(2)=-M_Ext_inTib_onFem(2);
   M_Ext_inTib_onFem(3)=-M_Ext_inTib_onFem(3);
   F_Ext_inTib_onFem(3)=-F_Ext_inTib_onFem(3);
end

% Compute response_to_load
[DGeS_FwrtT] = knee_response_to_load(flexion_angle_FwrtT,M_Ext_inTib_onFem,F_Ext_inTib_onFem);
if right_side == false
   DGeS_FwrtT(2)=-DGeS_FwrtT(2);
   DGeS_FwrtT(3)=-DGeS_FwrtT(3);
   DGeS_FwrtT(6)=-DGeS_FwrtT(6);
end

% Compute loaded motion (of the femur with respect to the tibia)
for ind=1:6
    GeS_FwrtT(ind)=NGeS_FwrtT(ind)+DGeS_FwrtT(ind);
end

% Compute loaded motion (of the tibia with respect to the femur)
if(moving_femur == false)
    T_ges_f2t = T_Move2Position(GeS_FwrtT,true);
    T_ges_t2f = inv(T_ges_f2t);
    [GeS_TwrtF] = GeS_Compute_Coordinates(T_ges_t2f,false);
end

if(moving_femur == false)
        T_N_f2t = T_Move2Position( NGeS_FwrtT,true);
        T_N_t2f = inv(T_N_f2t);
        [NGeS_TwrtF] = GeS_Compute_Coordinates(T_N_t2f,false);

        DGeS_TwrtF = GeS_TwrtF - NGeS_TwrtF;
end

% Final results
if moving_femur == false
    GeS  = GeS_TwrtF;
    NGeS = NGeS_TwrtF;
    DGeS = DGeS_TwrtF;
else
    GeS  = GeS_FwrtT;
    NGeS = NGeS_FwrtT;
    DGeS = DGeS_FwrtT;
end

% Scaling
GeS  = scale_GeS(GeS,V);
NGeS = scale_GeS(NGeS,V);
DGeS = scale_GeS(DGeS,V);


end