function N = N_kirchoff_func(in1,in2,in3,in4,in5)
%N_kirchoff_func
%    N = N_kirchoff_func(IN1,IN2,IN3,IN4,IN5)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    24-Feb-2025 15:40:44

xi1 = in1(1,:);
xi2 = in1(2,:);
xe11 = in2(1,:);
xe12 = in2(2,:);
xe21 = in3(1,:);
xe22 = in3(2,:);
xe31 = in4(1,:);
xe32 = in4(2,:);
xe41 = in5(1,:);
xe42 = in5(2,:);
t2 = xi1+1.0;
t3 = xi2+1.0;
t4 = xi1.^2;
t5 = xi2.^2;
t6 = xi1-1.0;
t7 = xi2-1.0;
t8 = t4.*xe11;
t9 = t5.*xe11;
t10 = t4.*xe12;
t11 = t5.*xe12;
t12 = t4.*xe21;
t13 = t5.*xe21;
t14 = t4.*xe22;
t15 = t5.*xe22;
t16 = t4.*xe31;
t17 = t5.*xe31;
t18 = t4.*xe32;
t19 = t5.*xe32;
t20 = t4.*xe41;
t21 = t5.*xe41;
t22 = t4.*xe42;
t23 = t5.*xe42;
mt1 = [t6.*t7.*(t4+t5+t6+t7).*(-1.0./8.0),(t6.*t7.*(t8+t9-t12-t21-xe11.*2.0+xe21+xe41))./1.6e+1,(t6.*t7.*(t10+t11-t14-t23-xe12.*2.0+xe22+xe42))./1.6e+1,(t2.*t7.*(-t2+t4+t5+t7))./8.0,t2.*t7.*(-t8+t12+t13-t17+xe11-xe21.*2.0+xe31).*(-1.0./1.6e+1),t2.*t7.*(-t10+t14+t15-t19+xe12-xe22.*2.0+xe32).*(-1.0./1.6e+1),(t2.*t3.*(t2+t3-t4-t5))./8.0,(t2.*t3.*(-t13+t16+t17-t20+xe21-xe31.*2.0+xe41))./1.6e+1,(t2.*t3.*(-t15+t18+t19-t22+xe22-xe32.*2.0+xe42))./1.6e+1];
mt2 = [(t3.*t6.*(-t3+t4+t5+t6))./8.0,t3.*t6.*(-t9-t16+t20+t21+xe11+xe31-xe41.*2.0).*(-1.0./1.6e+1),t3.*t6.*(-t11-t18+t22+t23+xe12+xe32-xe42.*2.0).*(-1.0./1.6e+1)];
N = [mt1,mt2];
end
