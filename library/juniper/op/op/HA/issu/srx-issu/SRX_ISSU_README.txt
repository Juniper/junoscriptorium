TO PREPARE:
-----------
1) Refer to ISSU upgrade limitations article in Knowledge Base:

	http://kb.juniper.net/InfoCenter/index 	page=content&id=S:KB17946) 

   to determine whether your configured features and existing  
   image are compatible to proceed with ISSU.

2) Open console connection to both nodes.

3) Because script executes commands on remote node, set up ssh-
   agent and keys as needed to allow unprompted login and update   
   username and passwd in the script file.

3) Make sure you specify ISSU upgrade image file location and 
   name correctly in script.

TO CONFIGURE:
-------------
1) Copy script to /var/db/scripts/op/ location.

1) In config mode, enter:

	set system scripts op file srx-issu.slax

   and then commit.

2) In operational mode, enter:

	op srx-issu file <location>

   For example:

	op srx-issu file /var/tmp/junos-srx5000-11.4R2.10-domestic.tgz


CAVEAT:
-------
Once all the prerequisites are met and ISSU command is executed, script will 
not monitor ISSU process unless an error occurs. Status of both nodes can be 
monitored via console connection.
