# PStomo_TOOLS
Utilities and plotter for the _PStomo_eq_ tomography package developed by Ary Tryggvason (see references)

**VERSION:** 1.1.0

**AUTHOR:**  Matteo Bagagli - <matteo.bagagli@erdw.ethz.ch> - [GitHub](https://github.com/billy4all)

**LICENSE:**  GNU-GPL v3

--------------------
## About
Using the _PStomo_eq_ tomography package during my MSc thesis, I felt the necessity to develop "ad hoc" tools expecially to plot resulting inversion models. In this distribution are shipped an interactive plotter in semi 3D to visualize tomographic models and a simple plot routine to show the hypocenters error relocation at each iteration of the inversion process.

I hope that these scripts could be useful for the community as they were for me in my learning process. For any bug reports/suggestion etc. don't hesitate to contact me at the mail written above.

This scripts should run smoothly in any Unix-like OS (Mac-Linux), as long as all the necessary dependencies are correctly installed.

## Dependencies
* MATLAB r2014b or higher
* cptcmap package ([fileexchange](https://www.mathworks.com/matlabcentral/fileexchange/28943-color-palette-tables---cpt--for-matlab)) to reproduce GMT colorpalettes
* hline_vline package ([fileexchange](https://www.mathworks.com/matlabcentral/fileexchange/1039-hline-and-vline)) to use the _navigator_ line
* freezeColors package ([fileexchange](https://www.mathworks.com/matlabcentral/fileexchange/7943-freezecolors---unfreezecolors))
* string_toolkits package ([fileexchange](https://www.mathworks.com/matlabcentral/fileexchange/21710-string-toolkits))
* bash/csh shells environments

#### Redistributions
The following packages are redistributed in this submission for an easier and faster use (under `PStomoPlotter/utility` dir):

* `string_toolkits` package 
* `hline_vline` package (for the _navigator_ line)
* `cptcmap` package 
* `freezeColors` package (unused from v1.1 is left only for back-portability with older version of Matlab that doesn't allow multiple colormpa in one figure)

--------------------

## PStomoPlotter
The core of this distribution is this plotting routine that allow the user to visualize interactively depth-slice and sections at the same time.
Once MATLAB is open, in order to get a first view of the package, type:

```
>> addpath(genpath('./PStomoPlotter'))
>> help PStomoPlotter
```

A complete plot-test is explained in a README file inside the `tutorialFIG` dir. After the figure has been created, a small prompt will appear at the low-left corner of the screen. The list of possible command that the user can type are:

```
 w --> will move the section in North direction
 s --> will move the section in South direction
 a --> will move the depth-slice at shallow depths
 d --> will move the depth-slice at larger depths
 ipo old --> plot the "input" seismicity file (hypocenters)
 ipo new --> plot the "final" seismicity file (hypocenters)
 rec on  --> plot receiver file
 rec off --> remove the receiver from plot
 plot pcolor --> set the MATLAB's plotting function to pcolor
 plot imagesc --> set the MATLAB's plotting function to imagesc
 plot contourf --> set the MATLAB's plotting function to contourf
```

Modification and upgrade are expected for newer releases. Suggestion are welcome! :)

## Tools
### filters
This is a collection of script to unpack verbose logs of `hypoellypse` and create a `PHASEALL` file necessary for _PStomo_eq_ inversion. MORE INFO SOON

### reloc
Shell and MATLAB script to plot for hypocenters relocation over the inversion process. Four different figures will be created for each spatial direction (xyz) plus time correction (t). Each row of each single figure represent an inversion cicle (first to last from top to bottom!).
These lines need to be added to the in `run.csh` script in the inversion's dir (in order to save the Event_err log file)

```
  if (-e Event_err.log)  then
     \mv Event_err.log Event_err_$i.log
  endif
```
Then run

```
$ ./grepRELOC.sh DIRPATH SAVEPATH
```
where `DIRPATH` is the inversion dir in which the Event_err* file are stored, and `SAVEPATH` is the dir for the storage of resulting files.
After this, in MATLAB, run the `reloc_plot.m` function inside the `SAVEPATH` dir.

```
>> [h_x,h_y,h_z,h_t]=reloc_plot(Rel_*);
```
--------------------
## References
* Tryggvason, A. (1998). «Seismic Tomography: Inversion for P- and S-wave velocities». PhD. Uppsala University: Department of Earth Sciences.
* Tryggvason, A. (2009). PStomo_eq: Computer algorithm for performing LE and controlled source traveltime tomography with simultaneous inversion for P- and S-wave velocity structure, hypocentral parameters or static corrections.USER MANUAL.
* Tryggvason, A., S.Th. Rögnval e O.G. Flovenz (2002). «Three-dimensional imaging of the P- and S-wave velocity structure and earthquake locations beneath Southwest Iceland». In: Geophysical Journal International 151, 848–866.
* Tryggvason, A., C. Schmelzbach e C. Juhlin (2009). «Traveltime tomographic inversion with simultaneous static corrections — Well worth the effort». In: Geophysics 74.6.
