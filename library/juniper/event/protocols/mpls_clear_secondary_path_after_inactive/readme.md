
Instructions
============

1. Copy the file to /var/db/scripts/event on each routing-engine 
2. add the following configuration to the router

  event-options { 
      event-script {
          file clear_secondary_path_after_inactive.slax;
      }
  }


