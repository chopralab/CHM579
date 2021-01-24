# Assignment 0 - Introduction to Jupyter Notebooks

## Using the Visual Studio Code and SSH
Welcome to the first assignment in CHM 579!

The assignment instructions are located in the zipfile named CHM_579_Assignment1.zip, however there are a few things to go over first before we access the assignment instructions. In this course, you will be working on the server cluster `scholar` which is a Purdue Univsersity cluster for educational work. You will need to access `scholar` using SSH, a secure method for remote access to servers. We reccomend that you use [Visual Studio Code](https://code.visualstudio.com/) as it has a lot of functionality including a code editor, terminal, file transfer, and a whole list of addons. If you are comfortable using a different remote SSH application, feel free to use that instead (However there may be some issues with Jupyter Notebook). 

Download and install VS Code and then open up a new window. The first thing that must be done is that you need to install the SSH addon. Click on the Extension pannel on the lefthand side bar (the one that looks like 4 squares coming together) and then type in SSH  and download the Remote - SSH addon (from Microsoft). 

After this, presse `ctrl+shift+p` or `command+shift+p` (on Mac) and type in `Remote-SSH: Open Configuration File`. Your SSH configuration file stores a list of all of the remote server hosts that you can have your personal computer connect to. Open up the one of the file options it provides (one is for the user and the other is shared across users). Each host that you want to connect to will require some information so that your personal computer knows how to reach it. The `Host` is name that will show when you use VS Code to connect, the `HostName` is the address of the server, and the `User` is your username that you use to log in. You will add this information for two different servers that you will use throught out the course.

```
Host scholar
    HostName scholar.rcac.purdue.edu
    User [YourPurudeUsername]
Host sp001
    HostName 10.164.22.16
    User [firstname_lastname]
```

Scholar is the server that you will do all of the course work on. It is a part of the Purdue cluster and has shared resources across all users. Sp001 is the class server that is owned our lab. It is where you will turn in all of your assignment. After adding these lines to the SSH config file, save and close out.

Press `ctrl+shift+p` or `command+shift+p` (on Mac) and type in `Reomote-SSH: Connect to Host`. Choose the host `scholar` and then log in using Boiler Key. After connecting to scholar, you will need to download the zip file for assignment 0 and then upload it to your account on scholar. Click the two overlapping file icon on the left hand sidebar. Click `Open Folder` and then select your home directory and click `Ok`. You will need to log in again with Boiler Key. You can uploada file or folder by dragging it onto the sidebar and relasing it under the folder that you want it to reside in.

## Launching the Jupyter Notebook

Next, you must launch Jupyter by doing the following. First load in Anaconda and activate the base enviroment. Anaconda is a package manager that will allow for you to access a Jupyter Notebook. You can do this with the following lines of code on the terminal.

```
module load anaconda
source activate
```
Next you need to launch the Jupyter Notebook interface with the following command.

```
jupyter notebook
```

It may take a moment to process, but when it is finished it should either give you a URL to paste into your browser or open the browser directly. This will open up the Jupyter application where you can view all files and notebooks that are located on scholar. You can use the `Upload` button in the top right hand corner to upload any files, images, etc. that you need for the assignment. 

## Submission Instruction

Get all of the files that you need and this Jupyter Notebook into the same folder and then use the following command to zip the folder into a compressed folder where `filename.zip` is the name you want the zip file to have and `directory_name` is the name of the directroy with all of your files in it. Do not forget the `-r` option as the folder contents will not be added with out it.

```
$zip –r filename.zip directory_name
```

Then, log onto `sp001` using VS Code and drag and drop the zip folder under your Assignment 1 directory. You can unzip the folder if you would like to check to see if everything is present, but you will not be able to run the Jupyter Notebook on this server. You do not need to unzip the folder as it will be transfered again prior to grading.