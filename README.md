Welcome to docker4dpd!
====================

This is some Dockerfiles to make [deployd](https://github.com/deployd/deployd) up and running quickly for me.

#Prerequisite
You need docker to be installed. For that purpose, see the [docker installation guide](https://docs.docker.com/installation/).

# Content
The folder contains 3 Dockerfiles and a start.sh script.

I choose from the beginning to  separate the dpd instance from the mongodb server. There is therefore a dedicated Dockerfile for mongodb.

The Dockerfile for dpd relies on the provided node docker machine.

# Configuration
Nothing really to do as everything is taken care by the start.sh script.

First start can be long as the machine images shall be built.

Just for you to know, the mongodb data is stored into a mongo\_data folder and dpd data are stored in the dpd\_data  folder.

The public website is routed to [http://localhost:3000](http://localhost:3000).
The dashboard is routed to your [http://localhost:3000/dashboard](http://localhost:3000/dashboard)

# Starting
    ./start.sh my_\app_name
# Stopping
    ./start.sh -s
# Interactive mode
It is possible to launch in "interactive" mode the dpd instance. It means that you'll have access to the dpd instance shell, and you'll have to manually issue the dpd commands.

For instance:

    ./start.sh -i
    # dpd create myapp
    # cd myapp
    # dpd -H generic_mongo -P 27017 -p 3000

> Note : No need to provide application to start.sh in interactive mode. 

# Versions
* node : 0.12.3
* npm : 2.13
* deployd : 0.8.5
* mongodb : 2.6.9


