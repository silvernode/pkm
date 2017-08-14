# pkm
A shell script wrapper for package managers originally by gotbletu  

## Introduction  

Pkm is a set of bash functions which are meant to be included in your shell's rc file. It has basic support for package manager detection via the 'which' command and is designed to be run on different Linux distributions. Pkm was originally written by youtube user [gotbletu](https://www.youtube.com/channel/UCkf4VIqu3Acnfzuk3kRIFwA) who demonstrates it's functionallity in the video titled: [Universal Package Manager - Linux BASH ZSH CLI](video:  http://www.youtube.com/watch?v=N8CZhlIssdk). This repository was created to continue expanding functionality and support for other package managers.  

## Installation  

To install pkm, simply at the following line to your ~/.bashrc file:  

`if [ -f ~/.pkm ]; then
    . ~/.pkm;
fi`

Then clone this repository and copy pkm.sh to your home directory:  

`git clone https://github.com/silvernode/pkm.git`  
`cp pkm/pkm.sh ~/.pkm`  

Then close and reopen your terminal to load the functions into your shell.  

## Basic Usage  

pkm-install <package-name>   - install package(s)  
pkm-remove <package-name>    - remove package(s)  
pkm-search <keyword(s)> - Search repository/cache for packages  
pkm-upgrade - Upgrade packages on your system  


It's important to note that there may be additional commands depending on what package manager pkm detects due to each detected package manager having it's own set of functions. To find out which command are available to you, type in:  

`pkm-<tab>`  

press tab a few times to see what's there. 

## Updating  

`cd pkm`   
`git pull`  

After that just copy the updated file the same as above. That's it!

## Roadmap  

Features I plan to include as of now are:  

* help system  
* more package managers  
