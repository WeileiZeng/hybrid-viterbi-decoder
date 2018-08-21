% MATLAB
%
% Files
%   codeword_generate          - from the codeword generator and a binary/GF(4) vector (called alpha), generate the
%   convcell                   - Weilei Zeng July 6, 2018
%   count_lines                - function costproject=castingprojecte1(mfilproject,ratperlin) 
%   dec2octal                  - convert a decimal matrix into an octal matrix
%   distance                   - try to find a lower bound on the distance of a hybrid convolutional code
%   errorAnalysis              - 08/08/2018
%   forney_spect_binary        - From forney's code, calculate the WEF for each orthogonal code
%   forney_spect_gf4           - From forney's code, calculate the WEF for each orthogonal code
%   generate_error_prob_vector - Definition of error mode: pq=qubit error prob, ps =syndrome error prob
%   getSavedTrellis            - get info from saved trellis in data/trellis/
%   getTrellisGF4              - Weilei Zeng, 07/19/2018
%   getTrellisGF4Strip         - Weilei Zeng, 07/19/2018
%   gf42octal                  - convert a decimal matrix into an octal matrix
%   matrix_generate_strip      - Weilei Zeng, 07/27/2018 updated version with g and \omega g
%   matrix_parameter_strip     - Weilei Zeng, 08/03/2018
%   minWeightDecoding          - apply min weight decoding for any block code and compare it with Viterbi
%   myconvenc                  - Weilei Zeng, 07/19/2018
%   pick10                     - Weilei Zeng, 07/12/2018
%   pickGF4                    - Weilei Zeng, 07/12/2018
%   plotrand                   - 
%   plotresult                 - Weilei Zeng 08/06/2018
%   plusGF4                    - addition of two GF4 single-digit number
%   plusGF4vec                 - add two GF4 vectors, either row vector or column vector
%   poly2trellis4gf4           - Weilei Zeng, 07/02/2018
%   runViterbiDecoderGF4Strip  - example input 2: terminated convolutional code [1 1 1 1 w W]
%   saveTrellis2File           - construct some trellis and save it into folder data/trellis/
%   simulation678              - put all simulation together, allowed different codes and different error
%   simulation7                - weilei Zeng, 08/06/2018
%   simulationPlot             - 
%   spect_terminated           - Weilei Zeng, July 6, 2018
%   symplecticGF4              - simplectic product of two GF4 single-digit number
%   test                       - 
%   test1                      - 
%   test2                      - 
%   test3                      - 
%   test5                      - 
%   timesGF4                   - simplectic product of two GF4 single-digit number
%   traceGF4                   - return trace of two GF(4) numbers, as defined in Forney's paper
%   trellis_gf4_outdated       - Weilei Zeng, 07/02/2018
%   trellis_sample_outdated    - 7/2/2018 Weilei Zeng
%   upperbound                 - get upper bound on the classical conolutional code with repeat =4
%   viterbiDecoderGF4          - not sure what i am doing here, this may be applicale for any block codes.
%   viterbiDecoderGF4Strip     - Weilei Zeng, 07/19/2018
%   viterbiDecoderGF4StripSoft - Weilei Zeng, 07/19/2018
%   weight_test                - 
