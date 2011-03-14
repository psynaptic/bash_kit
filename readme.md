#Bash Kit

Bash kit is a collection of functions, scripts and aliases for Drupal developers.

The main goal of this project is to consolidate commonly used helpers into an easily installable package. Sick of adding our common aliases and functions to every server we worked on, we created bash kit to simplify the process.

By collaborating on a single package, we hope to avoid the duplication of effort in individually creating custom helpers for own our personal workflows.

Do yourself and other users a favour by unifying our command line workflows, and save some carpal tunnel in the process!

##Installation

###Download bash kit

Clone or otherwise download bash kit to your computer. The recommended install location is `/opt/local/bash_kit`, but you can customise this.

The recommended way to install bash kit is via git. Using this method you will be able to pull in new changes without too much effort. To clone using git run the following in terminal (assuming you already have git installed on the machine):

    git clone git://github.com/psynaptic/bash_kit.git

If you do not have git installed on your machine you can [download an archive](https://github.com/psynaptic/bash_kit/archives/master) from github:

###Append variables to your bash profile

Figure out which bash profile file your system is using (e.g., .profile or .bash_profile). If you don't know which one is being used, you can check to see if only one of the above examples exists:

    ls -a ~

This will list all files in your user directory, including the ones starting with a dot.

Next, to append the variables to your bash profile run the following command (change the path to bash kit and the filename for your bash profile):

    cat /opt/local/bash_kit/profile_example >> ~/.bash_profile

Edit your bash profile and modify the newly appended variables to suit your own personal workflow.

    vim ~/.bash_profile

Source your bash profile (you only have to do this once).

    source ~/.bash_profile

If nothing went wrong, bash kit should now be installed.

##Usage

For now, please see the inline documentation for each command.
