1

   Abaqus 2024                                  Date 12-mar-2025   Time 14:05:41
   For use by CHALMERS TEKNISKA HOGSKOLA AB under license from Dassault Systemes or its subsidiary.

                                                                                 
                                                                                 
 STEP    1     INCREMENT     1     STEP TIME    0.00    


                        S T E P       1     C A L C U L A T I O N   O F   E I G E N V A L U E S

                                            F O R   B U C K L I N G   P R E D I C T I O N



                                                                                          

     THE LANCZOS EIGENSOLVER IS USED FOR THIS ANALYSIS
     Abaqus WILL COMPUTE UNCOUPLED
      STRUCTURAL AND ACOUSTIC MODES
     NUMBER OF EIGENVALUES                      5
     MAXIMUM NUMBER OF STEPS WITHIN RUN               30
     BLOCK SIZE FOR LANCZOS PROCEDURE                  5
     THE BUCKLING MODE CONSTRAINTS 
      ARE DEFINED AS LOAD CASE 2
                              ONLY INITIAL STRESS EFFECTS ARE INCLUDED IN THE
                              STIFFNESS MATRIX

     THIS IS A LINEAR PERTURBATION STEP.
     ALL LOADS ARE DEFINED AS CHANGE IN LOAD TO THE REFERENCE STATE

     EXTRAPOLATION WILL NOT BE USED

     CHARACTERISTIC ELEMENT LENGTH      24.1    

     DETAILS REGARDING ACTUAL SOLUTION WAVEFRONT REQUESTED

     DETAILED OUTPUT OF DIAGNOSTICS TO DATABASE REQUESTED

     PRINT OF INCREMENT NUMBER, TIME, ETC., TO THE MESSAGE FILE EVERY     1  INCREMENTS
 
	SYMMETRIC DIRECT SPARSE SOLVER RUNNING ON
 	1 HOST x 1 MPI RANK PER HOST x 1 THREAD PER RANK
        NUMBER OF EQUATIONS:  29160
        NUMBER OF RHS:        1
        NUMBER OF FLOPS:      1.787e+09
        SOLVER ELAPSED TIME:  174ms

     CHECK POINT  START OF SOLVER     
 
 SMP LANCZOS SOLVER RUNNING ON 1 THREAD
  
 COMPUTER PRECISION USED BY ABAQUS       2.22045e-16
 CONVERGENCE CRITERION FOR LANCZOS RUN   1.81899e-12
  
 NUMBER OF EQUATIONS                                                           29160
 NUMBER OF UNRESTRAINED DEGREES OF FREEDOM                                     26853
 HEURISTIC SCALE FOR THE FIRST NONZERO EIGENVALUES (PROBLEM SCALE)   3.33732e-04
 INITIAL SHIFT VALUE                                                -3.33732e-04
  
 NUMBER OF CPUS USED BY DIRECT SOLVER     1
  
 NUMBER OF NEGATIVE EIGENVALUES     0
 NUMBER OF POSITIVE EIGENVALUES     29160
 NUMBER OF NEGATIVE EIGENVALUES NOT ASSOCIATED WITH LAGRANGE MULTIPLIERS     0
 NUMBER OF LAGRANGE MULTIPLIERS     0
  
 COMPUTATIONAL INTERVAL FOR THE INITIAL LANCZOS RUN
 
 EIGENVALUES NEEDED TO THE RIGHT OF SHIFT VALUE    5
 EIGENVALUES NEEDED TO THE LEFT OF SHIFT VALUE     5
 RIGHT BOUNDARY OF THE COMPUTATIONAL INTERVAL   7.51499e+11
 LEFT BOUNDARY OF THE COMPUTATIONAL INTERVAL   -7.51499e+11
  
 LANCZOS RUN TERMINATED. NUMBER OF STEPS:   16
 ALL THE EIGENVALUES FOUND ON THE FIRST RUN
  
 NUMBER OF ACCEPTED EIGENVALUES    5
  
 ACCEPTED EIGENVALUES
  -7.68133e+00 -3.81787e+00 -2.06030e+00 -2.91778e-01  1.60427e+00
  
 FACTORIZATION WITH NEW SHIFT VALUE IS REQUIRED
  
 TRUST INTERVALS AFTER LANCZOS RUN AND COMPRESSION
  
 NUMBER OF TRUST INTERVALS    1
  
 -------------------------------------------------------------------------------------
 | KEY | INSIDE |      INERTIAS     |  SENTINELS  |   OUTSIDE   |  NEED TO FIND      |
 |      ENDS OF INTERVAL     |     ENDS OF SENTINEL      |   COMPUTATIONAL INTERVAL  |
 -------------------------------------------------------------------------------------
 |  +  |      0 |        0        0 |     0     0 |     0     0 |      4     1       |
 | -3.33732e-04  0.00000e+00 | -3.33732e-04  0.00000e+00 | -7.51499e+11  7.51499e+11 |
 -------------------------------------------------------------------------------------
  
 DATA FOR CHOOSING SHIFT
  
 NUMBER OF EIGENVALUES NEEDED IN THE PRIMARY TRUST INTERVAL    5
  
 NUMBER OF MODES FORMING SENTINEL TO THE RIGHT    1
 SHIFT RIGHT         5.11383e+00
  
 NUMBER OF MODES FORMING SENTINEL TO THE LEFT     4
 SHIFT LEFT         -9.62159e+00
  
 SHIFTING TO THE RIGHT DIRECTION
 NEW SHIFT           5.11383e+00
  
 NUMBER OF NEGATIVE EIGENVALUES     1
 NUMBER OF POSITIVE EIGENVALUES     29159
 NUMBER OF NEGATIVE EIGENVALUES NOT ASSOCIATED WITH LAGRANGE MULTIPLIERS     1
 NUMBER OF LAGRANGE MULTIPLIERS     0
  
 NEW LANCZOS RUN IS REQUIRED
  
 TYPE OF RUN: EXPAND THE TRUST INTERVAL TO THE RIGHT
 EIGENVALUES NEEDED TO THE RIGHT     1
 EIGENVALUES NEEDED TO THE LEFT      0
 RIGHT BOUNDARY OF THE INTERVAL   7.51499e+11
 LEFT BOUNDARY OF THE INTERVAL    5.11383e+00
  
 TRUST INTERVALS AFTER FACTORIZATION AND COMPRESSION
  
 -------------------------------------------------------------------------------------
 | KEY | INSIDE |      INERTIAS     |  SENTINELS  |   OUTSIDE   |  NEED TO FIND      |
 |      ENDS OF INTERVAL     |     ENDS OF SENTINEL      |   COMPUTATIONAL INTERVAL  |
 -------------------------------------------------------------------------------------
 |  +  |      1 |        0        1 |     4     0 |     4     0 |      4     1       |
 | -3.33732e-04  5.11383e+00 | -7.68133e+00  5.11383e+00 | -7.51499e+11  7.51499e+11 |
 -------------------------------------------------------------------------------------
  
 LANCZOS RUN TERMINATED. NUMBER OF STEPS:    9
 ALL THE EIGENVALUES REQUESTED ON THIS LANCZOS RUN ARE FOUND
  
 NUMBER OF ACCEPTED EIGENVALUES    6
  
 ACCEPTED EIGENVALUES
  -7.68133e+00 -3.81787e+00 -2.06030e+00 -2.91778e-01  1.60427e+00  8.62339e+00
  
 FACTORIZATION WITH NEW SHIFT VALUE IS REQUIRED
  
 TRUST INTERVALS AFTER LANCZOS RUN AND COMPRESSION
  
 NUMBER OF TRUST INTERVALS    1
  
 -------------------------------------------------------------------------------------
 | KEY | INSIDE |      INERTIAS     |  SENTINELS  |   OUTSIDE   |  NEED TO FIND      |
 |      ENDS OF INTERVAL     |     ENDS OF SENTINEL      |   COMPUTATIONAL INTERVAL  |
 -------------------------------------------------------------------------------------
 |  +  |      1 |        0        1 |     4     0 |     4     0 |      4     1       |
 | -3.33732e-04  5.11383e+00 | -7.68133e+00  5.11383e+00 | -7.51499e+11  7.51499e+11 |
 -------------------------------------------------------------------------------------
  
 DATA FOR CHOOSING SHIFT
  
 NUMBER OF EIGENVALUES NEEDED IN THE PRIMARY TRUST INTERVAL    5
  
 NUMBER OF MODES FORMING SENTINEL TO THE RIGHT    1
 SHIFT RIGHT         1.16527e+01
  
 NUMBER OF MODES FORMING SENTINEL TO THE LEFT     0
 SHIFT LEFT          5.11383e+00
  
 SHIFTING TO THE LEFT DIRECTION
 NEW SHIFT          -9.62159e+00
  
 NUMBER OF NEGATIVE EIGENVALUES     4
 NUMBER OF POSITIVE EIGENVALUES     29156
 NUMBER OF NEGATIVE EIGENVALUES NOT ASSOCIATED WITH LAGRANGE MULTIPLIERS     4
 NUMBER OF LAGRANGE MULTIPLIERS     0
  
 LANCZOS RUN FOR THIS SHIFT IS NOT REQUIRED
  
 TRUST INTERVALS AFTER FACTORIZATION AND COMPRESSION
  
 -------------------------------------------------------------------------------------
 | KEY | INSIDE |      INERTIAS     |  SENTINELS  |   OUTSIDE   |  NEED TO FIND      |
 |      ENDS OF INTERVAL     |     ENDS OF SENTINEL      |   COMPUTATIONAL INTERVAL  |
 -------------------------------------------------------------------------------------
 |  +  |      5 |       -4        1 |     0     1 |     0     1 |      0     1       |
 | -9.62159e+00  5.11383e+00 | -9.62159e+00  8.62339e+00 | -9.62159e+00  7.51499e+11 |
 -------------------------------------------------------------------------------------
  
 SHIFTING TO THE RIGHT DIRECTION
 NEW SHIFT           1.16527e+01
  
 NUMBER OF NEGATIVE EIGENVALUES     2
 NUMBER OF POSITIVE EIGENVALUES     29158
 NUMBER OF NEGATIVE EIGENVALUES NOT ASSOCIATED WITH LAGRANGE MULTIPLIERS     2
 NUMBER OF LAGRANGE MULTIPLIERS     0
  
 THE REQUIRED NUMBER OF EIGENVALUES IS FOUND
  
 FINAL TRUST INTERVAL
  
 -------------------------------------------------------------------------------------
 | KEY | INSIDE |      INERTIAS     |  SENTINELS  |   OUTSIDE   |  NEED TO FIND      |
 |      ENDS OF INTERVAL     |     ENDS OF SENTINEL      |   COMPUTATIONAL INTERVAL  |
 -------------------------------------------------------------------------------------
 |  +  |      6 |       -4        2 |     0     0 |     0     0 |      0     0       |
 | -9.62159e+00  1.16527e+01 | -9.62159e+00  1.16527e+01 | -9.62159e+00  1.16527e+01 |
 -------------------------------------------------------------------------------------
  
 FIRST EIGENVALUE REQUESTED BY THE USER     1

 ***WARNING: THERE ARE MORE EIGENVALUES IN THE SPECIFIED RANGE THAN REQUESTED. 
             IF THE NUMBER OF EIGENVALUES WAS NOT EXPLICITLY REQUESTED, SPECIFY 
             THE MAXIMUM NUMBER OF EIGENVALUES TO BE EXTRACTED
  
 EIGENVALUES REQUESTED BY THE USER
  -2.91778e-01  1.60427e+00 -2.06030e+00 -3.81787e+00 -7.68133e+00
  
 EIGENVALUE EXTRACTION USING THE LANCZOS EIGENSOLVER IS COMPLETE
 NUMBER OF LANCZOS RUNS       :   2
 NUMBER OF LANCZOS STEPS      :  25
 NUMBER OF FACTORIZATIONS     :   4
 NUMBER OF BACK SUBSTITUTIONS :  26

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   1.4000    
       ELAPSED SYSTEM TIME (SEC)    =  0.30000    
       ELAPSED TOTAL CPU TIME (SEC) =   1.7000    
       ELAPSED WALLCLOCK TIME (SEC) =            1


          THE ANALYSIS HAS BEEN COMPLETED



     ANALYSIS SUMMARY:
     TOTAL OF          1  INCREMENTS
                       0  CUTBACKS IN AUTOMATIC INCREMENTATION
                       1  ITERATIONS INCLUDING CONTACT ITERATIONS IF PRESENT
                      30  PASSES THROUGH THE EQUATION SOLVER OF WHICH 
                       4  INVOLVE MATRIX DECOMPOSITION, INCLUDING
                       0  DECOMPOSITION(S) OF THE MASS MATRIX
                       1  REORDERING OF EQUATIONS TO MINIMIZE WAVEFRONT
                       0  ADDITIONAL RESIDUAL EVALUATIONS FOR LINE SEARCHES
                       0  ADDITIONAL OPERATOR EVALUATIONS FOR LINE SEARCHES
                       3  WARNING MESSAGES DURING USER INPUT PROCESSING
                       1  WARNING MESSAGES DURING ANALYSIS
                       0  ANALYSIS WARNINGS ARE NUMERICAL PROBLEM MESSAGES
                       0  ANALYSIS WARNINGS ARE NEGATIVE EIGENVALUE MESSAGES
                       0  ERROR MESSAGES



     JOB TIME SUMMARY
       USER TIME (SEC)      =      1.9    
       SYSTEM TIME (SEC)    =     0.30    
       TOTAL CPU TIME (SEC) =      2.2    
       WALLCLOCK TIME (SEC) =            3
       MEMORY PEAK (GB)     =            0
