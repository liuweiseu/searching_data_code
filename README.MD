searching_data_code
=
What's in the repo:
-
Here are four folders in the repo:
* psf_rw:<br>
  The m files in this folder complete some basic operations, such as openin data file, reading data header, reading data, and closing data file.
* tools:<br>
  Some useful "tools" can be found here, such as displaying one data frame, displaying timeseries, modifying the file header and so on.
* folding:<br>
  The m files here finish th folding work and dedispersion work.
* searching_data:<br>
  Searching data files are in this folder.

How to use the code for data processing?
-
Four files are important for searching data processing:
* ./folding/RawDataFolding.m:<br>
  It finishes the folding work.
* ./folding/RawDataDedispersion.m:<br>
  It finishes the dedispersion work.
* ./Check_pf.m:<br>
  It can check the folding result and dedispersion result by shown the result in figures.
* Pulsar_info.txt:<br>
  The periods and DMs of pulsars are recorded in this file.

To process the searching data, you need to:<br>
(1) add the period and DM info to Pulsar_info.txt.
(2) run RawDataFolding.m, and it will generate a .pf file, which contains the folded result without dedispersion.<br>
(3) run RawDataDedispersion.m, and a .pfd file will be generated, which contains the dedispered result.<br>
(4) run Check_pf.m, and select the .pf or .pfd file, to check the folded result without/with dedispersion.<br>

File extensions
-
When you use the psr_rw package, you may find there are some files with different file extensions:<br>
(1) *.dat: these are raw data file, which consists of a file header(512 Bytes) and spectra data.<br>
(2) *.pf: these are pulsar folded file, which contains a file header(512 Bytes), and a"Time-Freq image" inside.<br>
(3) *.pfd: these are pulsar folded file with dedisperison, and the other format is the same as *.pf file.<br>
(4) *.oa: this is the offset array file. Some test signals(such as LFM signal) don't follow the dispersion rule, so we can define the offset array here.
  You can set the DM to -1 in Pulsar_info.txt, so the software will load the user-specified oa file.
