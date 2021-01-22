# Assignment 0 - Introduction to Jupyter Notebooks

## Using the Bitvise client and SSH
Welcome to the first assignment in CHM 579!

The assignment instructions are located in the zipfile named CHM_579_Assignment1.zip, however there are a few things to go over first before we access the assignment instructions. In this course, you will be working on the server cluster `scholar` which is a Purdue Univsersity cluster for educational work. You will need to access `scholar` using SSH, a secure method for remote access to servers. We reccomend that you use [the Bitvise SSH client](https://www.bitvise.com/) as it contains both a terminal and file transfer GUI, but if you would like to use another platform you are more than welcome to (personally I like [Visual Studio Code](https://code.visualstudio.com/) if you take the time to learn it). A video tutorial for how to download Bitvise and use SSH is shown below.


After you are familir with Bitvise and SSH, you will need to download the zip file for assignment 0 and then upload it to your account on scholar and unzip it using the unzip command (`unzip [filename]`). 

Next, you must launch Jupyter by doing the following. First load in Anaconda and activate the base enviroment. Anaconda is a package manager that will allow for you to access a Jupyter Notebook. You can do this with the following lines of code on the terminal.

`module load anaconda`

`source activate`

Next you need to launch the Jupyter Notebook interface with the following command.

`jupyter notebook`

It may take a moment to process, but when it is finished it should give you a URL to paste into your browser.