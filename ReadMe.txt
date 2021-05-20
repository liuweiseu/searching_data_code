When you use the psr_rw package, you may find there are some files with different file extensions.
Here, let me introduce these files:
(1) *.dat: these are raw data file, which consists of a file header(512 Bytes) and spectra data.
(2) *.pf: these are pulsar folded file, which contains a file header(512 Bytes), and a"Time-Freq image" inside.
(3) *.pfd: these are pulsar folded file with dedisperison, and the other format is the same as *.pf file.
(4) *.oa: this is the offset array file. Some test signals(such as LFM signal) don't follow the dispersion rule, so we can define the offset array here.
(5) PulsarInfo.txt: it contains some necessary information of the puslar, such as name, period and dm.
	If it's a test siganl, you can define the dm to -1 here, so the software will load a user-specified oa file.
																							
																							Wei 
																						05/20/2021