Weilei Zeng
* Error data set


** Table: summary of plots for circuit model
This is old result, going to be outdated

| name                   | description                                                            |                            |
|------------------------+------------------------------------------------------------------------+----------------------------|
| AG-GI-G-decoder-3      | compare three decoders on run5, using simulation7.m, mode b and mode d | run 5 is error for GI code |
| AG-GI-G-decoder-mode-b | same as ..3  only data for mode b                                      |                            |
| AG-GI-G-decoder-mode-d | same as ..3  only data for mode d                                      |                            |
| vary-sydnrome-prob-3   | soft decision works                                                    |                            |
| vary-syndrome-prob-4   | ..                                                                     |                            |
| vary-syndrome-prob-5   | find best soft decision result with ps= * pq                           |                            |

** Table: summary for simulation7 and simulation678, phenomenological error model A, three cases
[*] for currently used data;   [-*] for outdated used dat

| sth           | sth                                                            | sth                               | qubit |
|---------------+----------------------------------------------------------------+-----------------------------------+-------|
| simulation7   | 'data/circuit/code1/simulation7-repeat7model-b-soft-5.mat'     | GI decoder with majority vote     |    24 |
| simulation678 | 'data/circuit/code5/simulation678-repeat9model-b-soft-1.mat'   | GI decoder, without majority vote |    24 |
|               | 'data/circuit/code1/simulation7-repeat7model-d-soft-6.mat'     | GI decoder,with majority vote     |    24 |
|               | 'data/circuit/code5/simulation678-repeat9model-d-soft-2.mat'   | GI decoder, without majority vote |    24 |
|               |                                                                |                                   |       |
|               | 'data/circuit/code5/simulation678-repeat9model-a-soft-1.mat'   | ps=0.95                           |       |
|               |                                                                |                                   |       |
|               | 'data/circuit/code5/simulation678-repeat9model-a-soft-7-1.mat' | ps=pm=pq                          |       |
|               | 'data/circuit/code5/simulation678-repeat9model-a-soft-7-2.mat' | ps=pm/10,pq=pm                    |       |
|               | 'data/circuit/code5/simulation678-repeat9model-a-soft-7-3.mat' | ps=pm*10,pq=pm                    |       |
|               |                                                                |                                   |       |
|               | code1   soft-3-(1,2,3)                                         | with optimization                 |       |
|               | 1,2                                                            | some data                         |       |
|               | 4                                                              | more data                         |       |
|               |                                                                |                                   |       |
| code5, efg    | 'data/circuit/code5/simulation678-repeat9model-e-soft-1-1.mat' | numFail=100                       |    v2 |
| simulation678 | soft-1-2                                                       | rerun                             |    v3 |
| -* GI(GR)     | soft-1-3                                                       | run even with zero errorInput     |    v4 |
|               | 3-1                                                            | trim data range                   |       |
| *             | 3-2                                                            | more data, time=600               |       |
|               | 4-3                                                            |                                   |       |
|               |                                                                |                                   |       |
|---------------+----------------------------------------------------------------+-----------------------------------+-------|
| 678,code1     | 'data/circuit/code1/simulation678-repeat9model-e-soft-1-1.mat  | numFail=100                       |       |
| GA       efg  | 1-2                                                            | trim data                         |       |
| *             | 1-3                                                            | point time=600                    |       |
|               | 2-3                                                            |                                   |       |
|               |                                                                |                                   |       |
|               |                                                                |                                   |       |
|---------------+----------------------------------------------------------------+-----------------------------------+-------|
| 678,mode f,   | 2-1                                                            | more data                         |       |
| code5         | 2-2                                                            | less                              |       |
|               | 2-3                                                            | less                              |       |
|               | 2-4                                                            | tiny                              |       |
|               | 2-5                                                            | 60 sec data point time            |       |
|               | 2-6                                                            | 600 sec data point time           |       |
|               | check result: use toc to control time                          |                                   |       |
| code1,efg     |                                                                |                                   |       |
| simulation 7  | 'data/circuit/code1/simulation7-repeat7model-e-soft-1-4.mat'   |                                   |       |
| * GI majority | 1-5                                                            | trim data at 1e-4                 |       |
|               | 2-3                                                            |                                   |       |
|               |                                                                |                                   |       |
|---------------+----------------------------------------------------------------+-----------------------------------+-------|
| code1         | -G-1-1                                                         |                                   |       |
| * simulation7 | -G-1-2                                                         | rerun, more data                  |       |
| G decoder     | -G-2-3                                                         |                                   |       |


code1/simple-compare-mode-a-code1  show that optimization on single and double error is not good.
code5/simple-compare-mode-a-code5  compare three simple error model

f mode takes a lot of time, it has small syndrome error prob and small decoding failure probability. This can be optimized cause we don't need data with too small probs.

The gap is huge, we can try smaller gaps.

the data point time actually make sense for simulation. use this to cut off trials.

zero error does affect the result



** results on soft decision decoding
check soft decoding results for single and double errors

| index | condition |         | (G,I) code      | 24 qubits | no repeat       |           |
|-------+-----------+---------+-----------------+-----------+-----------------+-----------|
|       | <l>       | <l>     |                 |           |                 |           |
|       | pq        | ps      | single syndrome | single    | double syndrome | double    |
|   * 1 | 0.05      | 0.05    | 18/18           | 90/90     | 120/153         | 2802/3933 |
|     2 | 0.05      | 0.45    | 0/18            | 72/90     | 0/153           | 1980/3933 |
|    21 | 0.005     | 0.045   | 18/18           | 90/90     | 60/153          | 2778/3933 |
|   *22 | 0.0005    | 0.0045  | 18/18           | 90/90     | 84/153          | 2802/3933 |
|    23 | 0.00005   | 0.00045 | 18/18           | 90/90     | 84/153          | 2802/3933 |
|     3 | 0.45      | 0.05    | 18/18           | 18/90     | 153/153         | 153/3933  |
|    32 | 0.0045    | 0.0005  | 18/18           | 90/90     | 121/153         | 2802/3933 |
|   *33 | 0.00045   | 0.00005 | 18/18           | 90/90     | 121/153         | 2802/3933 |
|    41 |           |         |                 |           |                 |           |
|       |           |         |                 |           |                 |           |
|-------+-----------+---------+-----------------+-----------+-----------------+-----------|
|       |           |         | (G,I)           |           |                 |           |
|   * 1 | 0.05      | 0.05    | 18/18           | 90/90     | 120/153         | 2802/3933 |
|   *22 | 0.0005    | 0.0045  | 18/18           | 90/90     | 84/153          | 2802/3933 |
|   *33 | 0.00045   | 0.00005 | 18/18           | 90/90     | 121/153         | 2802/3933 |
|-------+-----------+---------+-----------------+-----------+-----------------+-----------|
|       |           |         |                 |           |                 |           |
|       |           |         | (G,A)           |           |                 |           |
|     1 |           |         | 58/58           | 130/130   | 1653/1653       | 7809/8313 |
|    22 |           |         | 58/58           | 130/130   | 1653/1653       | 7809/8313 |
|    33 |           |         | 58/58           | 130/130   | ..              | ..        |
|-------+-----------+---------+-----------------+-----------+-----------------+-----------|
|       |           |         |                 |           |                 |           |
|       |           |         | GI(GR) code     |           |                 |           |
|     1 |           |         | 54/54           | 126/126   | 1431/1431       | 7299/7803 |
|    22 |           |         | ..              | ..        | ..              | ..        |
|    33 |           |         | ..              | ..        | ..              | ..        |
|       |           |         |                 |           |                 |           |
|-------+-----------+---------+-----------------+-----------+-----------------+-----------|
|       |           | ps^3+.. | (G,I) with        |           |                 |           |
|       |           |         | majority vote   |           |                 |           |
|       |           |         | 0/18            | 72/90     |                 |           |
|       |           |         |                 |           |                 |           |

not finding interesting result to explain their difference in mode f, ps<pq

In different cases (1,22,33), all double syndrome error can be fixed,
but other double errors not. GI fail 30%, but GR,GA fail only
10%. This part is balanced by the syndrome error elemenated by
majority vote.





* outdated data
** (outdated feb 9) conv5v5v2 for AG code circuit model
It is outdated because I have the optimization for single and double errors.

     Table: summary of saved errors and runned trials for circuit model. * for typical results
| folder | decription | qc file | repeat | qubits | # of errors |            | result           | decription       |
|--------+------------+---------+--------+--------+-------------+------------+------------------+------------------|
| run5   | G code     | conv4v2 |      7 |     24 |       10000 | more probs |                  |                  |
| ..     |            |         |        |        |             |            | repeat-soft-1    | hard decision    |
| ..     |            |         |        |        |             |            | repeat-soft-2    | ps=0.5,pq<ps     |
|        |            |         |        |        |             |            | repeat-soft-3    | hard decision    |
|        |            |         |        |        |             |            | repeat-soft-4    | hard optimize    |
|        |            |         |        |        |             |            | repeat-soft-5    | ps=0.5 optimize, |
|        |            |         |        |        |             |            |                  | wrong syndrome   |
|--------+------------+---------+--------+--------+-------------+------------+------------------+------------------|
| ..     |            |         |        |        |             |            | repeat-soft-61   | ps=2*pq          |
|        |            |         |        |        |             |            | repeat-soft-62   | ps=3*pq          |
|--------+------------+---------+--------+--------+-------------+------------+------------------+------------------|
|        |            |         |        |        |             |            | repeat-soft-64   | syndrome=0       |
|        |            |         |        |        |             |            | repeat-soft-64-2 | syndrome=1       |
|        |            |         |        |        |             |            | repeat-soft-64-3 | ps=pq*0.00001    |
|        |            |         |        |        |             |            | repeat-soft-64-4 | pq=pq*0.001      |
|        |            |         |        |        |             |            |                  | ps=0.9           |
|--------+------------+---------+--------+--------+-------------+------------+------------------+------------------|
|        |            |         |        |        |             |            |                  |                  |

repeat-soft-2,3,4,5 show that soft and hard decision works for the decoder.


** outdated data record  Feb 5 2019 weilei
forget the reason but it is outdated

outdated Table: summary of saved errors and runned trials. * for typical results

| folder | decription | qc file   | repeat | qubits | number of errors |             | result        | decription        |
|--------+------------+-----------+--------+--------+------------------+-------------+---------------+-------------------|
| run4   | G code     | conv4v1   | 3      | 12     |            10000 |             |               |                   |
| run5   | G code     | conv4v2   | 7      | 24     |            10000 | more probs  |               |                   |
| run52  | ..         | ..        | ..     | ..     |               .. | less probs  | equal-1       | hard decision     |
| *run5  |            |           |        |        |                  |             | equal-2       | numfail=100       |
| ..     |            |           |        |        |                  |             | less-pq-1     | numfail=10        |
| ..     |            |           |        |        |                  |             | less-pq-2     | numFail=100       |
| ..     |            |           |        |        |                  |             | less-ps-1     |                   |
| ..     |            |           |        |        |                  |             | less-ps-2     | ~pq/3200          |
| ..     |            |           |        |        |                  |             | less-ps-3     | numFail=100       |
| run53  | ..         | ..        | ..     | ..     |            10000 | larger prob | equal-3       | larger prob\      |
| ..     |            |           |        |        |                  |             | less-pq-3     | not necessary     |
| ..     |            |           |        |        |                  |             | less-ps-4     |                   |
| run6   | AG code    | conv5v5v2 | 7      | 24     |            10000 |             | hard-6        |                   |
| ..     |            |           |        |        |                  |             | repeat hard-1 | run G decoder     |
| * run8 | ..         | ..        | ..     | ..     |               .. | more probs  | hard-7        | AG decoder        |
| * ..   |            |           |        |        |                  |             | repeat hard 3 | run G decoder     |
| * ..   |            |           |        |        |                  |             | repeat hard 4 | syndromeerror 0/1 |
|        |            |           |        |        |                  |             |               |                   |


outdated Table: summary of plots

| name              | description                        |                            |
|-------------------+------------------------------------+----------------------------|
| AG-GI-G-decoder-1 | compare three decoders on run8     | run 8 is error for AG code |
| AG-GI-G-decoder-2 | compare three decoders on own data | different time steps       |


** comment on hard/soft decoding
There is barely optimization for soft decoding. We see a slight
different when ps~=pq/3200. This make sense because each syndrome bit
involve with 6 qubits. It is hard to flip single or double error to
weight-6 error. For error with weight around 3, since it is a
distance-3 codes, it will fail anyway. Hence soft decoding doesn't
help to correct much errors in this case.

In all those simulations, pm ( error prob on each timestep) start from 0.01 and lower. For larger pm values, the decoding always fail.

* Developing Note on the project Jan 2019

** [2019-01-09 Wed 00:18]
error generated in the circuit model is binary. For the matlab code, error is in GF4. This need be done in the conversion.

** <2019-01-12 Sat>
a trial of simulation for repeated case has been done. Need to check
manually on the process: how an error is decoded? Does the syndrome
match?

** <2019-01-13 Sun>
 - Checked Michael's quantumsimulator program with sample input
zz.qc. Output for every step is solid for this example. No other code
has been tested.

 - My code turns out to be solid too. The situation is, in each
   errorInput, there are some error undetected by the syndrome. Hence
   our program is deemed to fail. This can be solved by repeatment
   measurement, where we assume the last round of measumrent has no
   syndrome errors. Then, when we do simulations, the quantity we look
   at should be, instead of p_fail, the number of round the decoding
   is successful. This last round with no syndrom error could be done
   using viterbiDecodingStripSoft() with input error errorCircuit.

** <2019-01-14 Mon>
 - Simulation results get. Next Step would be checking the plot and do
simulation on circuit with larger size.
 - Use shell script to run generate.out. format the input


* definition of repeat
  say r = repeat, n=total number of qubits
 - for repeatment measurement code 1
   n=3*(n+1)
   when r=1, n=6

* earlier note
- Weilei Zeng Jan 8 2018

finish converting the errors, ( It is doutable if this conversoin is accurate, need to check)
now generate more errors with different probabilities.



1. generate error in some configuration and convert to the input for the decoder


Weilei Zeng Dec 8 2018

To apply the circuit error model into the simulation.




This project is very Cool! The github site has introduction for what has been done in the Summer 2018.
