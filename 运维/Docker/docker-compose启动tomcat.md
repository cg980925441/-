~~~yml
version: '3'
services:
  tomcat:
    restart: always
    image: tomcat
    ports: [8080:8080]
    container_name: tomcat
~~~

