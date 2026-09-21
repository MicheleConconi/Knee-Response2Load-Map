function [GeS] = GeS_Compute_Coordinates(T,proximal)

% return the GeS coordinated associated to the matrix T. T is in line,
% rotation are in degrees. No change in the sing of the axes are introduced
% to match medical conventions

[m,n] = size(T);
if n==4
    m=1;
end

for i=1:m
    if n == 16
        for j=1:4
            M(j,1:4)=T(i,(1+4*(j-1)):4*j);
        end
    elseif n == 4
        M=T;
    end
    
    if proximal == true
        %%FEMUR respect to tibia
        %RotY*RotX*RotZ
        %(cycz + sysxsz)	(-cysz + sysxcz)	sycx
        %cxsz				cxcz				-sx
        %(-sycz + cysxsz)	(sysz + cysxcz)		cycx
        
        GeS(i,2)=atan2(-M(2,3),sqrt(M(3,3)^2+M(1,3)^2))* 180 / pi;

        %we want the ab/adduction angle to be comprise betwee -pi/2 and pi/2 thus
        if(GeS(i,2)<-90)
            GeS(i,2)= -180 - GeS(i,2);
        elseif(GeS(i,2)>90)
            GeS(i,2)= 180 - GeS(i,2);
        end

        GeS(i,3)=atan2(M(1,3)/cos(GeS(i,2)*pi/180),M(3,3)/cos(GeS(i,2)*pi/180))* 180 / pi;
        GeS(i,1)=atan2(M(2,1)/cos(GeS(i,2)*pi/180),M(2,2)/cos(GeS(i,2)*pi/180))* 180 / pi;
    else
        %%TIBIA respect to FEMUR
        %RotZ*RotX*RotY
        %(cycz - sysxsz)	-cxsz	(sycz + cysxsz)
        %(cysz + sysxcz)	cxcz	(sysz - cysxcz)
        %-sycx				sx		cycx
        
        GeS(i,2)=atan2(M(3,2),sqrt(M(3,3)^2+M(3,1)^2))* 180 / pi;

        %we want the ab/adduction angle to be comprise betwee -pi/2 and pi/2 thus
%         if(GeS(i,2)<-90)
%             GeS(i,2)= -180 - GeS(i,2);
%         elseif(GeS(i,2)>90)
%             GeS(i,2)= 180 - GeS(i,2);
%         end

        GeS(i,3)=atan2(-M(3,1)/cos(GeS(i,2)*pi/180),M(3,3)/cos(GeS(i,2)*pi/180))* 180 / pi;
        GeS(i,1)=atan2(-M(1,2)/cos(GeS(i,2)*pi/180),M(2,2)/cos(GeS(i,2)*pi/180))* 180 / pi;
    end

	GeS(i,4)=M(1,4);
	GeS(i,5)=M(2,4);
	GeS(i,6)=M(3,4);
end