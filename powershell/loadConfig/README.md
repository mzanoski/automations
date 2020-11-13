# Load Configuration From File

## Using JSON
JSON is a very popular format used widely by Microsoft related technologies with reasonable support in PowerShell. JSON 
can get a bit wordy but on the plus side, it is often simpler to understand than YAML.  A nice added bonus is JSON schema 
that can be defined and used to validate JSON file format.  JSON is not space-sensitive but each key/variable value 
must end with a comma if followed by another variable.  Last variable value must not end with a comma.

For more info on JSON schema, see [json-schema.org](https://json-schema.org)

### Get-ConfigFromJson.ps1
Script loads a JSON file into a PSCustomObject.  

Example config file
~~~~JSON
{
    "parameter1": "parameter1value",
    "serverList": [
        {
            "name": "server1",
            "role": "web"
        },
        {
            "name": "server2",
            "role": "database"
        }
    ]
}
~~~~

Load config file:
~~~~powershell
> $conf = ./Get-ConfigFromJson.ps1 -ConfigFilePath ./config.json

# some examples on how $conf is used
> $conf.parameter1
parameter1value
> $conf.serverList

name    role
----    ----
server1 web
server2 database

> $conf.serverList.GetType()

IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     Object[]                                 System.Array

> $conf.serverList[0]

name    role
----    ----
server1 web

> $conf.serverList[0].role
web
~~~~


## Using YAML
Less wordy than JSON and some say easier to read; true for simple structures.  Can get pretty messy if using more complex 
structures like nested dictionaries and lists.  YAML syntax is space-sensitive, meaning that incorrect spaces or 
indents will cause errors.

Poor support in PowerShell