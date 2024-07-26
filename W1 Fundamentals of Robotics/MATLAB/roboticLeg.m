function r_Bi_inB = roboticLeg(links, alpha, beta, gamma)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

R_B1 = [    1,           0,           0;
            0,  cos(alpha), -sin(alpha);
            0,  sin(alpha),  cos(alpha)];

R_12 = [    cos(beta),   0,   sin(beta);
            0,           1,           0;
           -sin(beta),   0,   cos(beta)];

R_23 = [    cos(gamma),  0,   sin(gamma);
            0,           1,            0;
           -sin(gamma),  0,   cos(gamma)];

lb = links(1);
l1 = links(2);
l2 = links(3);
l3 = links(4);

% write down the 3x1 relative position vectors for link length l_i=1
r_B1_inB = [0;  lb;  0];
r_12_in1 = [0;  0; -l1];
r_23_in2 = [0;  0; -l2];
r_3F_in3 = [0;  0; -l3];

% write down the homogeneous transformation matrices
H_B1 = [        R_B1,   r_B1_inB    ;
             0, 0, 0,          1    ];
H_12 = [        R_12,   r_12_in1    ;
             0, 0, 0,          1    ];
H_23 = [        R_23,   r_23_in2    ;
             0, 0, 0,          1    ];

% create the cumulative transformation matrix
H_B3 = H_B1 * H_12 * H_23;

% find all the joints point position vector
r_B2_inB = H_B1 * [r_12_in1; 1];
r_B3_inB = H_B1 * H_12 * [r_23_in2; 1];

% find the foot point position vector
r_BF_inB = H_B3 * [r_3F_in3; 1];

r_Bi_inB = [r_B1_inB(1:3), r_B2_inB(1:3), r_B3_inB(1:3), r_BF_inB(1:3)];
end