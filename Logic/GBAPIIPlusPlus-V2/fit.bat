SET PATH=%PATH%;c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64

@rem synthesize
xst -intstyle ise -ifn "C:/Users/Matze/Documents/GitHub/A500-Graka/Logic/GBAPIIPlusPlus-V2/GBAPIIPlusPlus.xst" -ofn "C:/Users/Matze/Documents/GitHub/A500-Graka/Logic/GBAPIIPlusPlus-V2/GBAPIIPlusPlus.syr" >log.txt
@rem translate
ngdbuild -intstyle ise -dd _ngo -uc pinlist.ucf -p xc9572xl-TQ100-10 GBAPIIPlusPlus.ngc GBAPIIPlusPlus.ngd >>log.txt
@rem fit
cpldfit.exe -intstyle ise -p xc9572xl-10-TQ100 -ofmt vhdl -optimize density -loc on -slew fast -init low -inputs 54 -pterms 25 -unused float -power std -terminate keeper GBAPIIPlusPlus.ngd >>log.txt
@rem sim
tsim -intstyle ise GBAPIIPlusPlus GBAPIIPlusPlus.nga >>log.txt
@rem prep
hprep6 -s IEEE1149 -n GBAPIIPlusPlus -i GBAPIIPlusPlus >>log.txt