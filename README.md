# docker-atom-editor
The [atom editor](https://atom.io/) inside a docker container.

# General Information
The docker container will have a volume of your whole system! The hosts root system will mount into __/host/__ inside the docker container.
So for example: if you want to open your file "/home/user/workspace/file.txt" you will find it under "/host/home/user/workspace/file.txt" inside
your atom docker container.

Inside the docker container there is a user named __atom__. This user have the __same Permissions__ like the user who starts
the docker container. 

# Systemintegration
Just use the __docker-atom-editor.sh__ script

To open a blank atom-editor instance.
```
$> docker-atom-editor.sh
```

To open a file in atom-editor. If an editor is already started, the file will be opened in this window.
```
$> docker-atom-editor.sh <path to file>
```
