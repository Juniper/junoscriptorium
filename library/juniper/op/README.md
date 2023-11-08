## Execute an Op Script (from Juniper Documentation)
1. [Locally via op command or at login](https://www.juniper.net/documentation/us/en/software/junos/automation-scripting/topics/task/junos-script-automation-executing-an-op-script.html)
2. [From a remote site](https://www.juniper.net/documentation/us/en/software/junos/automation-scripting/topics/task/automation-op-script-checksum.html)


## Execute an Op Script via RPC
   The XML name is op-script as seen in the [YANG file](https://github.com/Juniper/yang/blob/c2dfe1caf5599af8ba5d76d1dbf9833340390dbc/16.1/operational/op.yang#L195)
   #### Example with PyEZ
   The line below shows the Python syntax used within a PyEZ script. More information on using RPCs or PyEZ can be found in the [Automation Scripting User Guide](https://www.juniper.net/documentation/us/en/software/junos/automation-scripting/topics/concept/automation-using-rpcs-and-operational-mode-commands-in-event-scripts.html) or the [Junos PyEZ Developer Guide](https://www.juniper.net/documentation/us/en/software/junos-pyez/junos-pyez-developer/index.html)
   ```
   dev.rpc.op_script(script='scriptname.py')
   ```
   #### Examples with REST
   Text, JSON, and XML supported. More information can be found in the [REST API Guide](https://www.juniper.net/documentation/us/en/software/junos/rest-api/topics/concept/rest-api-overview.html).
   ```
   curl http://username:password@X.X.X.X:3000/rpc/op-script -d "scriptname.py" -H "Content-Type: plain/text" -H "Accept: text/plain"
   ```
   ```
   curl http://X.X.X.X:3000/rpc/op-script -d "<script>scriptname.py</script>" -u "root:password" -H "Content-Type: application/xml" -H "Accept: application/xml"
   ```
