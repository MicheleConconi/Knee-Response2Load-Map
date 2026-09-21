# Knee Response-to-Load Map
A MATLAB representation of the experimentally derived map of the knee response to load. The map returns the tibio-femoral position and orientation given the flexion angle and the external load (force and torque) applied to the articulation.

# Table of contents <!-- omit in toc -->
- [Introduction](#introduction)
- [Reference Systen](#reference-system)
- [Current- version](#current-version)
  - [V1.1](#V1.1)
- [How to use it](#how-to-use-it)

## Introduction
This repository contains a MATLAB package that permits to use the Knee Response-to-Load Map to obtain the tibio-femoral position and orientation of the knee, given the flexion angle and the external load (force and torque) applied to the articulation.
The spatial kinematics is obtained as the natural (passive) motion of the knee, plus the deformation induced by the applied loads.

The map definition is part of a journal article currently under submission and revision.

## Reference System
The map is originally expressed as the motion of the femur with respect to the tibia. The coordinates are expressed as a variation of the Grood and Suntay convention, more specifically: the femur is moving with respect to the tibia anatomical reference frame. The Origin of the tibia anatomical reference frame is positioned such that the full extended position of the bones is the null position (each motion component equal 0).
![reference_systems](./reference_system.jpg)

## Current version:
### V1.1
This version contains two folders:
- *Knee response to load map - matlab files/KNEE RESPONSE TO LOAD EVALUATOR*:
   - contains all the MATLAB functions to run the calculation
     - _GeS_Compute_Coordinates.m_: returns the kinematics coordinates (GeS) associated with the rototranslational matrix (T).
	 - _T_Move2Position.m_: Compute the rototranslation matrix (T) from the kinematics coordinates (GeS).
	 - _response_to_load_fitting_model.m_: returns the value calculated through the response to load fitting model (that is: _polinomial of 4<sup>th</sup> grade in flexion, logarithmic in load_).
	 - _knee_response_to_load.m_: returns the variation in femur position and orientation with respect to the values observed for the knee natural motion at the considered flexion angle. Displacements are obtained as the linear combination of the displacements induced by each load component separately.
	 - ***knee_loaded_motion.m***: returns the position and orientation of the tibio-femoral at the given flexion_angle under the effect of the external loads. The coordinates are expressed according to a variation of the Grood and Suntay notation and are evaluated as the sum of femur natural motion (computed through the function knee_natural_motion.m), the displacement induced by external loads (computed through the function knee_response_to_load.m)
	 - _knee_natural_motion.m_: Simply return the position and orientation of the femur with respect to the tibia anatomical reference system at the given flexion_angle.
	 - _scale_GeS.m_: computes the scaling factor and applies it to the pose given as input. Scaling factor is calculated as the cubic root of the ratio between the Volume of the femur of the current subject (V) and the Volume of the map reference femur (V_reference).
   - contains all the polynomial coefficients obtained from the fitting procedure.
- *Figures*: contains .fig and .png files of the map fitting surfaces.
   - Each figure represents the continuous deformation obtained for a monoaxial load envelope (force or torque), through the entire flexion range.
   For example:
   ![Natural motion fitting](./Figures/Natural_motion.png)
   ![Fx fitting surface](./Figures/Fx.png)
   
## How to use it
To use the map it is sufficient to focus on the function script ***knee_loaded_motion.m***. In brief:
- The script works on a **single position** at a time
- The **inputs**:
  - *Required*: 
     - flexion_angle_in: the considered knee flexion angle, \[°]. Positive values imply flexion of the femur with respect to the tibia. In the case of mapping the motion of the tibia with respect to the femur, no sing correction is expected, thus the motion of the tibia with respect to the femur is associated with negative value
     - M_in: the torque vector (1X3) applied to the femur, expressed in the tibial anatomical reference system, \[Nm]. In the case of mapping the motion of the tibia with respect to the femur, M is the torque vector applied to the tibia, expressed in the femoral anatomical reference system. In both cases the z component is assumed to be null since the knee is assumed to provide no resistance to flexion.
	 - F_in: the force vector (1X3) applied to the femur, expressed in the tibial anatomical reference system, \[N]. In the case of mapping the motion of the tibia with respect to the femur, M is the force vector applied to the tibia, expressed in the femoral anatomical reference system.
	 - moving_femur: is true if you are mapping the motion of the femur relative to the tibia, false in the opposite case.
	 - right_side: is true for a right leg, false in the opposite case.
	 - V: volume of the femur of the current subject under analysis \[mm<sup>3</sup>]. This input is optional and set to a default value (Volume of the map reference femur) if not given as input. In that case, the result given as output is not scaled to the specific subject
- The **outputs**:
  - GeS: the pose of the femur relative to the tibia (or vice versa, depending on the *moving_femur* input flag) at flexion_angle_in. Rotations are in degrees, translations in mm. The vector contains in order: \[flexion_angle, AA, IE, X, Y, Z]. No sing correction is applied to match medical convention.
  - NGeS: natural pose of the femur relative to the tibia (or vice versa, depending on the *moving_femur* input flag) at flexion_angle_in. Rotations are in degrees, translations in mm. The vector contains in order: \[flexion_angle, AA, IE, X, Y, Z]. No sing correction is applied to match medical convention.
  - DGeS: displacement from natural pose of the femur relative to the tibia (or vice versa, depending on the *moving_femur* input flag) at flexion_angle_in. Rotations are in degrees, translations in mm. The vector contains in order: \[flexion_angle, AA, IE, X, Y, Z]. No sing correction is applied to match medical convention.
