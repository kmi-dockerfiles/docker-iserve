iServe Docker Image
================================

Docker container for [iServe](https://github.com/kmi/iserve) a Linked Services and Sensors registry.

iServe Automated Deployment
---------------------------
iServe relies on an RDF Store in the backend in order to store service and sensor descriptions. You should thus link iServe to an existing RDF Store over which you have Read/Write privileges. 

In order to simplify it's use we include in this project a simple [Fig](http://www.fig.sh) script that will obtain the appropriate dependencies and launch a configured iServe instance. 

Requirements

* Docker 1.3+

* Fig 1.0 +

Usage
-----

To build a self-contained iServe simply do on the docker-iserve folder:

	fig build
	
Then, once built, to launch the image do:

	fig up
	
After a few seconds where the server is being setup you should have access to iServe in the port 8080 or your docker host. On port 9090 you should have access to the underlying Sesame store.

For correct behaviour, iServe needs to know the public host and port under which it will be available. Currently it is configured by default at:

	http://192.168.59.103:8080/iserve
	
You may change this by using the tweaking the environment variables in fig.yml.

NOTE: The fig script is configured to use a data container for persistence. As long as the data container is available locally, iServe will have access to that data any time it is launched. Should you wish to start afresh simple find the docker container for the data volume (using `docker ps -a`) and then remove it (`docker rm XXXX`).

Container Usage
---------------
You may also use iServe directly as a distinct container but you will need in this case to configure iServe appropriately in order to use the correct RDF Store, etc. See [iServe configuration documentation](http://kmi.github.io/iserve/latest/configuration.html) for further details

To create the image 'openuniversity/iserve', execute the following command on the docker-iserve folder:  

	docker build -t openuniversity/iserve .
	
(Note: do not forget to include the final '.' in the line above)

To run the image and bind iServe to port 8080:

	docker run -d -p 8080:8080 openuniversity/iserve
		
When you launch the container a new user and password will be created for the Tomcat manager (see logs).

Container Configuration
-----------------------

iServe relies on an RDF Store in the backend in order to store service and sensor descriptions. You should thus link iServe to an existing RDF Store over which you have Read/Write privileges.

By default iServe will be serving URLs using as base the following:

	 http://{ISERVE_HOST}:{ISERVE_PORT}/{ISERVE_APP_NAME}
	 
Each of these parameters may be changed to suit your particular deployment. Notably, should you wish your service URLs to be publicly resolvable, you should change the Host and Port to whatever will be publicly accessible in your case. You may do so when you launch the container as follows:

	docker run -d -p 8080:8080 -e JAVA_MAXMEMORY=2048 openuniversity/iserve


By default the memory devoted to iServe is setup to 1 GB. You may override this using the `JAVA_MAXMEMORY` environment variable:
	
	docker run -d -p 8080:8080 -e ISERVE_HOST="www.example.org" -e ISERVE_PORT="80" openuniversity/iserve
	
By default iServe's data will be stored at /data/iserve. You may configure this using the `ISERVE_DATA` environment variable:
	
	docker run -d -p 8080:8080 -e ISERVE_DATA="/myfolder" openuniversity/iserve

Source
------
The source for this docker contained is [available on GitHub](https://github.com/kmi-dockerfiles/docker-sesame).
See [RDF4J.org](http://rdf4j.org) for Sesame's source code.

Issues
------
Please report any issues on [GitHub](https://github.com/kmi-dockerfiles/docker-sesame/issues).