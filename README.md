
<h1 align="center" style=" border-bottom: none ;">EE314 Term Project </h1>
<p align="center">
   
 <h3 align="center" style=" border-bottom: none ;">FPGA Implementation of a Not-So-Very-Simple Network Quality of Service (QoS) Algorithm </h3>
<p align="center">
   
   
#### Group Members        
* Özgür Gülsuna
* Işık Emir Altunkol
## Project Description
Our problem definition selects packet latency and packet loss/drop as the only factors over a buffering structure consisting of four parallel linear buffers, each with six packets, working in a first-in-first-out manner. The exemplary network requires three specifications, Latency precedence, Reliability precedence, and minimum packet loss. Latency precedence can be explained as the most up-to-date packets over the buffers should be arranged as the condition in 1.

<p align=center>  L1 < L2 < L3 < L4 &nbsp&nbsp			[1].</p>

Similarly, reliability precedence is that the least amount of drops should occur in buffer four with decreasing order as in 2.

<p align=center> R4 > R3 > R2 > R1 &nbsp&nbsp [2].</p>

The final specification is that overall drops should be minimized for all buffers. Another property of the exemplary system is data output rate, which is fixed at 3 seconds. There exist numerous algorithms with generalized performance over the implemented medium. The test environment for our algorithm to run is selected as FPGA, which is a configurable integrated circuitry dedicated to implementing logic circuit elements.

In this project, a weighted selection algorithm is designed, optimized for randomized inputs with average congestion on the network using the NSGA-II algorithm, and finally implemented on Altera DE1-SoC FPGA with a visual user interface over the VGA (Video Graphics Array). The design of the queuing algorithm, determination of weights using optimization, and the implementation of the algorithm on FPGA environment is discussed in the report which can be found under [Report](https://github.com/ozgurgulsuna/EE314-NetworkQueueing-on-FPGA/blob/master/4.Report/optimizaiton%20and%20implementation%20%20of%20a%20not-so-very-simple%20queueing%20algorithm.pdf).

## Report
This report discusses the design, optimization, and implementation of a queueing algorithm. The problem is defined around the requirements and limitations. An exemplary decision function is constructed and tested in a simulation environment. Later weights are optimized using a genetic algorithm, more precisely NSGA-II, in a multi-objective manner. It is shown that the decision function is capable of satisfying the requirements. Moreover, with the optimized weights of the decision function, it is ensured that the algorithm’s performance is at its top level. At last, the queuing algorithm is implemented on FPGA with inputs from buttons and output to the user using the VGA interface.

<p align="center">
   <img width="100%" src="/4.Report/Figures/report.png" >
</p>


## Demonstration
The algorithm is implemented on Altera Cyclone V FPGA developement board (DE1 SoC). A working photo of the VGA screen is given below.
<p align="center">
   <img width="85%"  src="/4.Report/Figures/20220705_172533.jpg" >
</p>


