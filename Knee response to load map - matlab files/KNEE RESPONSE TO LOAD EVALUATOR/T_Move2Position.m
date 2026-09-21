function [M]=T_Move2Position(GeS,proximal)

%Compute the rototranslation matrix from the GeS coordinate, rotation in degrees.
%N.B. no change in the sing are here considered due to the medical
%convention. Thus the sign are those of the GeS axes
[m,n] = size(GeS);

for i=1:m
    flexZ=GeS(i,1);
    abdX=GeS(i,2);
    rotY=GeS(i,3);
    x=GeS(i,4);
    y=GeS(i,5);
    z=GeS(i,6);

    flexZ = flexZ*pi/180;
    abdX = abdX*pi/180;
    rotY = rotY*pi/180;

    if proximal == true
    % 	//RotY*RotX*RotZ => FEMUR respect to TIBIA
        T(1,1)= cos(rotY)*cos(flexZ) + sin(rotY)*sin(abdX)*sin(flexZ);
        T(2,1)= cos(abdX)*sin(flexZ);
        T(3,1)= -sin(rotY)*cos(flexZ) + cos(rotY)*sin(abdX)*sin(flexZ);

        T(1,2)= -cos(rotY)*sin(flexZ) + sin(rotY)*sin(abdX)*cos(flexZ);
        T(2,2)= cos(abdX)*cos(flexZ);
        T(3,2)= sin(rotY)*sin(flexZ) + cos(rotY)*sin(abdX)*cos(flexZ);

        T(1,3)= sin(rotY)*cos(abdX);
        T(2,3)= -sin(abdX);
        T(3,3)= cos(rotY)*cos(abdX);
    else
    % 	//RotZ*RotX*RotY => TIBIA respect to FEMUR
        T(1,1)=( cos(flexZ)*cos(rotY) - sin(flexZ)*sin(abdX)*sin(rotY) );
        T(2,1)=( sin(flexZ)*cos(rotY) + cos(flexZ)*sin(abdX)*sin(rotY) );
        T(3,1)= -cos(abdX)*sin(rotY);

        T(1,2)= -sin(flexZ)*cos(abdX);
        T(2,2)= cos(flexZ)*cos(abdX);
        T(3,2)= sin(abdX);

        T(1,3)= ( cos(flexZ)*sin(rotY) + sin(flexZ)*sin(abdX)*cos(rotY) );
        T(2,3)= ( sin(flexZ)*sin(rotY) - cos(flexZ)*sin(abdX)*cos(rotY) );
        T(3,3)= cos(abdX)*cos(rotY);
    end

    T(1,4)= x;
    T(2,4)= y;
    T(3,4)= z;
    T(4,:)= [0 0 0 1];

    if m ==1
        M = [T(1,:);T(2,:);T(3,:);T(4,:)];
    else
        M(i,:) = [T(1,:),T(2,:),T(3,:),T(4,:)];
    end
end