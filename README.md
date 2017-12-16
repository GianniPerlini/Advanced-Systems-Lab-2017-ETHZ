## Submission Overview

This file contains some useful information to navigate through the submission's directories.

The submission is structured as follows:
- **README.md** -> this file
- **report.pdf** -> the report
- **asl-mw-java** -> contains the java implementation of the middleware
- **asl-data** -> contains all the data used in the report, and in general for the project

The asl-data directory is further composed of *aslX* where X is the number of the corresponding section in the report. It also contains *memcached_pop.sh*, a script used to populate memcached servers
before running experiments.  

## Foreword
Some of the script may not be complete. In some cases, some of the statistics needed to be parsed differently, and to do that, I simply changed the script without doing distinct copies.

The *aslX* directories are structured as follows.

## asl2:

**asl2.1:**

This contains the data of the baseline without middleware, part 1.  
The raw data are named *baseline_op_repXvmY.txt* where **op = {set, get}**, **X = {1, 2, 3}** and **Y = {1, 2, 3}**  
Raw data are given as input to the python script *baseline_parser_all_op.py*, op being as before.  
This script is used as follows: *baseline_parser_all_op.py 80 input_file_name out_name data_name*  
80 is the test time of the experiment, the third input can be ignored, the last is the name of the output file  
The script outputs a .out that can be ignored and a .txt which contains parsed data, in this case, the outputs are called *blXvmY_op_data.txt*, **X**, **Y** and **op** as before.  
This files are then used by the *2.1sum_btw_vms_op.py* script to compute the sum between the throughputs and average between response time.  
This in turns output the *blX_op_tot.txt* files.  
This files are then processed by the *2.1avg_btw_run_op.py* which computes the average and standard deviation and outputs the data ready to be plotted in 
*bl_op_tot.txt*  
The *py_launch.sh* simply launch the *baseline_parser_all_op.py* with appropriate inputs.  
Finally *gnuplot_op.sh* produces the plot used in the report.

**asl2.2:**

This directory is further divide into mem1 and mem2, corresponding to the two different instances of memtier used in this section.  
This directory is very similar to the previous. There is no *sum_btw_vms* script since the clients are connected to two different servers.  
*py_launch.sh* this time launches all the scripts needed to produce the final output, namely the *bl_op_tot.txt* that are then used by the   
gnuplot scripts to produce the graphs.  
*report_plot* contains the plots used in the report, while the other two directories also contain some individual graph not being added in the report.

## asl3:

**asl3.1:**

This directory contains two files and a number of different directories.  
*bl3.1ssh_controller.sh* is the script used to run the experiment.  
*3.1-interactive_law.ods* contains the calculation of the interactive law for both clients and middleware  

**Memtier:**

*asl3.1mem_op* contain raw data from memtier, the files are named *exp3.1_OP_memrRwtWTcC.txt* where **OP = {set, get}**, **R = {1, 2, 3}**, **WT = {8, 16, 32, 64}** and **C = {1, 4, 8, 12, 16, 20, 24, 28, 32}**  
*asl3.1mem_op_finished* contain:
- raw data as already mentioned
- *exp3.1_OP_memrRwtWT_all_c.txt* contains output of memtier concatenated from c = 1 to c = 32, this is done using *clients_appender.sh*
- *OP_memrRwtWT_data.txt* parsed data, output of *3.1mem_parser.py*. This are produced using *3.1py_launcher.sh*
- a further directory called *parsed*
*parsed* contain:
- *OP_memrRwtWT_data.txt* as previously
- *OP_wtWT_tot.txt*, further parsed data, ready to be plotted. This step of the parsing is done using *3.1avg_btw_reps_get.py*
- *3.1memplot_OP.sh* script used to plot data

**Middleware:**

*asl3.1mw_OP* contain raw data  
*asl3.1mw_OP_finished* contain:
- 4 scripts, *AR_parser.py* to parse arrival rate data, *stat_avg.py*, computes the average of raw data, *run_appender.sh*, appends each run to a single file, and 
  *avg_btw_runs.py*. *run_appender.sh* produces files called *STAT_OP_cC_wtWT_tot.txt* where STAT is the name of the statistic. *avg_btw_runs.py* takes these files and 
  further parse them to make them ready to be plotted. The output of this last step are organized in the *STATTot* folders.

- a folder for each statistic gathered, containing the same raw data. The name of the folders are specified later

- a folder for each statistic gathered, called the same way with a *Tot* at the end. This contains the outputs of *run_appender.sh* and the *plot* folder, which contains
  the *STAT_OP_wtWT_data.txt*, which is used by the corresponding gnuplot script to plot.


**asl3.2:**
This directory contains two files and a number of different directories.  
*bl3.2ssh_controller.sh* is the script used to run the experiment.  
*3.2-interactive_law.ods* contains the calculation of the interactive law for both clients and middlewares  

**Memtier:**

*asl3.2memX_op* contains raw data, **X = {1, 2}** representing the memtier instances. The files are called *exp3.2_mwMW_op_memrRwtWTcC.txt* where **MW = {1, 2}**  
*asl3.2memX_op_finished* is almost equal to the directory of Section 3.1, raw data, parsed data and scripts  
*3.2mems_op*  contains:
- *mwMW_memMrRwtWT_data.txt* files for both instances of memtier
- *sum_btw_vms_get.py* combines the data from the instances of memtier doing the sum of throughput and average of response time, outputs *mws_rRwtWT_tot.txt* files
- *avg_btw_reps_get.py* performs average and stdandard deviation and outputs the final file to be plotted, named *mws_wtWT_tot.txt*
- *plot* directory contains *mws_wtWT_tot.txt* data, graphs and script to plot data
	

**Middleware:**

*asl3.2mwMW_op* contains raw data  
*asl3.2mwMW_op_finished* contains a folder for each data and 4 scripts similar to the previous section. The folders usually contains the *op_mwMW_cC_wtWT_tot.txt* files, which are the output
of *run_appender.sh*  
*3.2_mws_op* contains the *Tot* folder of each statistic, and *asl3.1_sum_mws.py*, used to compute average, sum and standard deviation. This outputs *STAT_OP_wtWT_data.txt*, ready to be plotted  
Every *Tot* folder contains *STAT_OP_wtWT_data.txt* files, the graphs and the script to plot  
*others* contains some other statistic like ping

## asl4:

At the root, this contains *4full_sys_controller.sh* used to run the experiment and *4_interactive_law.ods* containing interactive law results.

**Memtier:**

*asl4vmX* **X = {1, 2, 3}** contains:
- *memY* **Y = {1, 2}** with raw data called *exp4.1_mwMW_memXrRwtWTcC.txt*, X being the number of the VM.
- *memY_finished* with raw data, raw data appended called *exp4.1_mwMW_memXrRwtWT_all_c.txt* and parsed data *mwMW_memXrRwtWT_data.txt*. Also contains *clients_appender.sh*, *py_launcher.sh* and *4.1mem_parser.py*  
*asl4mem_mwMW* contains:
- *mwMW_memXrRwtWT_data.txt* files
- *sum_btw_vms_set.py* to compute average and sum, outputs *mwMW_rRwtWT_tot.txt* files
- *tot* folder, in case of MW = 2, this only contains *mwMW_rRwtWT_tot.txt* files. In case of MW = 1, this also contains *sum_btw_mws_set.py* to further parse data, which outputs *mws_rRwtWT_tot.txt*
files. The folder also contains another folder called *mws_tot*, containing the *mws_rRwtWT_tot.txt* files, *avg_btw_reps_set.py* script to perform the last step outputting *mws_wtWT_tot.txt* files.
These files are contained into *plot*, which also contains the graphs and the plotting scrip.


**Middleware:**

*asl4mw1* raw data  
*asl4mw1_finished* 4 usual scripts to append and parse, per-statistic folders containing raw data and results of *run_appender.sh*  
*4mws* contains *asl4_data_mws.py* script to compute usual averages, sums and standard deviations, as well as per-statistic *Tot* folder. These contains *STAT_wtWT_data.txt*, graph and plotting script  


## asl5:

At root level, this contains the two scripts used to run the two experiments and two folders named *asl5.1* and *asl5.2*.

**asl5.1:**

This contains a number of folders, and 4 files: interactive law results in *5.1_interactive_law.ods*, memtier response time distribution for both operations for all the key sizes in *5.1dist.ods*, corresponding histograms in *5.1mem_dist_plot.ods*, and middleware response time histogram in *5.1dist_mw.ods*  

**Memtier:**

*asl5.1vmX* contains *mem1* and *mem2* folders with raw data of memtier instances  
*5.1mems* contains response time and throughput data and graphs, as well as the script to plot them  

**Middleware:**

*asl5.1mwMW_finished* contains a folder for each statistic, containing raw data and appendend raw data. It also contains the usual 4 scripts to parse data  
*5.1mws* contains 4 scripts to compute average, sums and standard deviation depending on the data. It also contains *Tot* folders with usuals *STAT_data.txt*, corresponding graphs and gnuplot script  

**asl5.2:**

This folder is structured as the previous one  


## asl6:

At root level, this folder contains *asl6_2k_tables.ods* with 2k analysis table, and 4 scripts: *6_2k_p1.sh* and *6_2k_p2.sh* are used to run the experiments, these need *op* and *ratio* as inputs.  
*6_p1_controller.sh* and *6_p2_controller.sh* simply call them with the right arguments.  
This folder also contains *asl6-1*, *asl6-2* and *6-ping*  

**asl6-1:**

This contains folders for each configuration and operation experiment.  
Folders corresponding to one middleware configurations contain raw data (both appended and non) for that configurations, scripts to compute average and sum and a *data* folder containing *STAT_wtWT_data.txt*, namely files in the final form to be used in the tables.  
Folder corresponding to two middlewares configurations with name starting with *asl6* have again raw data and scripts in them but don't contain the *data* folder.  
In this case there is an additional folder for each operation named *6_2mws_op*, **op = {get, set, both}** containing appended raw data, scripts to compute average and sums, and the *data* folder  

**asl6-2:**

This is structured the same way as asl6-1


## asl7:

*mm1* folder contains *mm1_res.ods* with the results for the M/M/1 model  
*mmm* contains *mmm_res.ods* with results for M/M/m model, as well as *p0_calc.py* which calculates some useful values used to compute the results of the model. This folder also contains
*sthwt* folder. This contains per-thread gathered throughput (*sthwt_avg_mwMW_wtWT_cC.txt*). This are used by *sum_per_wt.py* which computes the sum between the middlewares and outputs the results
in *sthwt_mws_wtWT_cC.txt*, then used by *avg_per_wt.py* to output *sthwt_avg_mws_wtWT_cC.txt*. *max_th.py* find the maximum in these files.  
*noq* contains *3.1_noq_server.ods* and *3.2_noq_server.ods* which are the files with results for the server model, *3.1_noq_workers.ods* and *3.2_noq_workers.ods* which are files with results for the workers and *3.1&2_noq_mm1_sys.ods* which contains results for the system model.  











