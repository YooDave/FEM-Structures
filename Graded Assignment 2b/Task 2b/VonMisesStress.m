function vm_stress = VonMisesStress(sigma)

stress_vec = [sigma(1);sigma(2);0;sigma(3);0;0];

stress_avg = (sigma(1)+sigma(2))/3 * [1;1;1;0;0;0];

s = stress_vec - stress_avg;

vm_stress = sqrt(3/2 * (s.'*s + sigma(3)^2));


end