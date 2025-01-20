# Assignment 1 - Molecule Structure Visualization, Normal Modes, and RDKit Basics

## Introduction

In this assignment you will learn how to use molecular visualization software, perform simulation and analysis of a molecules normal modes, and some basics of the cheminformatics package RDKit. All of the assignment instructions are located in the Jupyter Notebook file as well as any background information. The RDKit module will require you to create a seperate conda enviroment as opposed to the one that is provided on the cluster. While these instructions are repeated in the assignment doccument they are also added below if you wanted to install the conda enviroment before reading through the assignment instructions.

## RDKit Installation with Conda

### **All instructions here are repeated in the assignment notebook

RDKit is a powerful cheminformatics package that integrates well with python. It has a wide range of functionality including substructure searching, chemical descriptor calculation, and molecular fingerprinting. In this part of the assignment, we will get to explore some of these features. 

For previous python code segments, we did not need any external packages because what we used built-in packages. However, RDKit is not a built-in package so we must install it in a package manager in order to use it in a Jupyter Notebook. After logging on to scholar we run the following lines of code to install a conda enviroment with RDKit.

```
module load anaconda
conda create -c rdkit -n assignment1 rdkit
```

Follow the on screen prompting to finish installing the RDKit enviroment. After installing the anaconda enviroment we need to activate it and install the Jupyter Notebook using`pip`.

```
conda activate assignment1
pip install jupyterhub jupyterlab jupyter jsonschema jupyterlab-server
pip install matplotlib
```

Finaly we can open the Jupyter Notebook with the conda enviroment packages availible to us by typing the below line of code.

```
jupyter notebook
```

The final step is to switch the kernal from Python 3.8 to Python 3. While these are likely the same versions on Python, the Python 3 kernel should be in the anaconda enviroment with RDKit, thus giving you access to the package. You can do this by going to the toolbar at the top of the page and selecting the `Kernel` option, going down to `Change kernel` and selecting the `Python 3` option. Your current kernel can be seen on the top right hand area of the screen and it should show `Python 3` Where it once had `Python 3.8 (Anaconda ...)`. Now you are ready to use RDKit!

## Protein Data Bank

### **All instructions here are repeated in the assignment notebook

The [Protein Data Bank](https://www.rcsb.org/), or PDB, is the best place to obtain 3-Dimensional structures of proteins, nucleic acids, peptides and other macromolecules. From their site, you can locate proteins by keyword searching or by entering the accession number for the structure file, like 1mba. Most of the structures in the PDB were determined by [X-ray crystallography](https://en.wikipedia.org/wiki/X-ray_crystallography) or [NMR spectroscopy](https://en.wikipedia.org/wiki/Nuclear_magnetic_resonance_spectroscopy) with a growing trend of using [Cryo-EM](https://en.wikipedia.org/wiki/Cryogenic_electron_microscopy). Details on the molecules in the structure file, how the structures were determined, pertinent research articles, etc. can be found on the web site but also in the pdb file itself.

PDB files are just formatted text files, so you can open them in a text editor or even Word and read them. There is a wealth of information there! The molecular viewing programs use the ATOM records in the file, which contain residue name, residue number, atom name and atom number - all of which are important when selecting molecules or parts of them to visualize. Often, the structure files include other molecules besides the protein, such as water molecules, nucleic acid and bound ligands.

## [PyMol](https://pymol.org/2/) 

### **All instructions here are repeated in the assignment notebook

PyMol is a relatively new and very promising molecule viewing program developed by [Schodinger](https://www.schrodinger.com/). It is available for all Unix/Linux platforms, Windows and Mac OSX. It uses a combination of menus, a powerful selection sidebar, ( to demonstrated in the lab), and a rich command line interface. It has a logging feature to remember commands as they are executed, allows for scripting and has a nice movie feature. Check out the [PyMol Wiki](https://pymolwiki.org/index.php/Practical_Pymol_for_Beginners) for more help and tips.

PyMol is free to download and build as it is open source software. However, Purdue University provides all students with a site license which allows for simple installation and execution. You can download it here: [Pymol version 2](https://pymol.org/2/). You must also install the [site license](https://pymol.org/dsc/index.php?ip=license/) while on campus as the link will not work otherwise.

## [Visual Molecular Dynamics (VMD)](http://www.ks.uiuc.edu/Research/vmd/) 

### **All instructions here are repeated in the assignment notebook

VMD is new and very promising molecule viewing program developed at University of Illinois at Urbana-Champaign. It is available for all Unix/Linux platforms, Windows and Mac OSX. It uses a combination of three windows: a terminal window, a viewing window and a main window. The terminal window is useful in that error messages and command output. The view window is where your molecules will appear, and the main window is where most of the controls for VMD are found. We strongly encourage you to go through the VMD tutorial also which can be found on the [VMD website](http://www.ks.uiuc.edu/Research/vmd/current/docs.html#tutorials), if you need more information to create this assignment. VMD is a very important tool which would be helpful for further assignments as well.

VMD is under rapid development, so get the latest program from the [VMD Web Site](https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD).
