FROM java:8

ENV KNOWAGE_VERSION 6_4_4
ENV KNOWAGE_EDITION CE
ENV KNOWAGE_RELEASE_DATE 20190920
ENV KNOWAGE_PACKAGE_SUFFIX bin-${KNOWAGE_VERSION}-${KNOWAGE_EDITION}-${KNOWAGE_RELEASE_DATE}
ENV FILEEXTENSION .zip
ENV KNOWAGE_REPO_VERSION 6.4.0
ENV KNOWAGE_OW2_BASE_URL http://release.ow2.org/knowage/${KNOWAGE_REPO_VERSION}/Applications
ENV KNOWAGE_OW2_DDL_URL http://release.ow2.org/knowage/${KNOWAGE_REPO_VERSION}/Database%20scripts

ENV KNOWAGE_CORE_ENGINE knowage
ENV KNOWAGE_CORE_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_CORE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_BIRTREPORT_ENGINE ${KNOWAGE_CORE_ENGINE}birtreportengine
ENV KNOWAGE_BIRTREPORT_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_BIRTREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_COCKPIT_ENGINE ${KNOWAGE_CORE_ENGINE}cockpitengine
ENV KNOWAGE_COCKPIT_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_COCKPIT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_COMMONJ_ENGINE ${KNOWAGE_CORE_ENGINE}commonjengine
ENV KNOWAGE_COMMONJ_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_COMMONJ_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_DATAMINING_ENGINE ${KNOWAGE_CORE_ENGINE}dataminingengine
ENV KNOWAGE_DATAMINING_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_DATAMINING_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_GEOREPORT_ENGINE ${KNOWAGE_CORE_ENGINE}georeportengine
ENV KNOWAGE_GEOREPORT_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_GEOREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_JASPERREPORT_ENGINE ${KNOWAGE_CORE_ENGINE}jasperreportengine
ENV KNOWAGE_JASPERREPORT_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_JASPERREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_KPI_ENGINE ${KNOWAGE_CORE_ENGINE}kpiengine
ENV KNOWAGE_KPI_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_KPI_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_META_ENGINE ${KNOWAGE_CORE_ENGINE}meta
ENV KNOWAGE_META_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_META_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_NETWORK_ENGINE ${KNOWAGE_CORE_ENGINE}networkengine
ENV KNOWAGE_NETWORK_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_NETWORK_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_QBE_ENGINE ${KNOWAGE_CORE_ENGINE}qbeengine
ENV KNOWAGE_QBE_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_QBE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_SVGVIEWER_ENGINE ${KNOWAGE_CORE_ENGINE}svgviewerengine
ENV KNOWAGE_SVGVIEWER_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_SVGVIEWER_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_TALEND_ENGINE ${KNOWAGE_CORE_ENGINE}talendengine
ENV KNOWAGE_TALEND_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_TALEND_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV KNOWAGE_WHATIF_ENGINE ${KNOWAGE_CORE_ENGINE}whatifengine
ENV KNOWAGE_WHATIF_URL ${KNOWAGE_OW2_BASE_URL}/${KNOWAGE_WHATIF_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}${FILEEXTENSION}

ENV APACHE_TOMCAT_VERSION 8.5.37
ENV APACHE_TOMCAT_PACKAGE apache-tomcat-${APACHE_TOMCAT_VERSION}
ENV APACHE_TOMCAT_URL https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/${APACHE_TOMCAT_PACKAGE}.zip

#location of mysql script to init knowage db
ENV KNOWAGE_MYSQL_SCRIPT_URL ${KNOWAGE_OW2_DDL_URL}/mysql-dbscripts-${KNOWAGE_VERSION}-${KNOWAGE_RELEASE_DATE}.zip

ENV LIB_COMMONS_LOGGING_URL https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar
ENV LIB_COMMONS_LOGGING_API_URL https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging-api/1.1/commons-logging-api-1.1.jar
ENV LIB_CONCURRENT_URL https://search.maven.org/remotecontent?filepath=org/lucee/oswego-concurrent/1.3.4/oswego-concurrent-1.3.4.jar
ENV LIB_MYSQL_CONNECTOR_URL https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.33/mysql-connector-java-5.1.33.jar
ENV LIB_GERONIMO_COMMONJ_URL https://search.maven.org/remotecontent?filepath=org/apache/geronimo/specs/geronimo-commonj_1.1_spec/1.0/geronimo-commonj_1.1_spec-1.0.jar
ENV LIB_MYFOO_COMMONJ_URL https://github.com/SpagoBILabs/SpagoBI/blob/mvn-repo/releases/de/myfoo/commonj/1.0/commonj-1.0.jar?raw=true

ENV LIB_POSTGRESQL_CONNECTOR_URL https://jdbc.postgresql.org/download/postgresql-42.2.4.jar

#knowage directory
ENV KNOWAGE_DIRECTORY /home/knowage
#mysql script directory
ENV MYSQL_SCRIPT_DIRECTORY ${KNOWAGE_DIRECTORY}/mysql

#go to knowage home directory
WORKDIR ${KNOWAGE_DIRECTORY}

    #install required packages and clean up to save space
RUN apt-get update && apt-get install -y wget coreutils unzip mysql-client  && rm -rf /var/lib/apt/lists/* && \
    #download mysql scripts
    wget "${KNOWAGE_MYSQL_SCRIPT_URL}" -O mysql.zip && \
        unzip mysql.zip && \
        rm mysql.zip && \
    #download apache tomcat and extract it
    wget "${APACHE_TOMCAT_URL}" && \
       unzip ${APACHE_TOMCAT_PACKAGE}.zip && \
       rm ${APACHE_TOMCAT_PACKAGE}.zip

#go to apache tomcat webapps directory
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/webapps

    #download knowage engines and extract them
RUN wget "${KNOWAGE_CORE_URL}" -O ${KNOWAGE_CORE_ENGINE}.zip && \
       unzip ${KNOWAGE_CORE_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_CORE_ENGINE}.war -d ${KNOWAGE_CORE_ENGINE} && \
       rm -rf tmp ${KNOWAGE_CORE_ENGINE}.* && \
    wget "${KNOWAGE_BIRTREPORT_URL}" -O ${KNOWAGE_BIRTREPORT_ENGINE}.zip && \
       unzip ${KNOWAGE_BIRTREPORT_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_BIRTREPORT_ENGINE}.war -d ${KNOWAGE_BIRTREPORT_ENGINE} && \
       rm -rf tmp ${KNOWAGE_BIRTREPORT_ENGINE}.* && \
    wget "${KNOWAGE_COCKPIT_URL}" -O ${KNOWAGE_COCKPIT_ENGINE}.zip && \
       unzip ${KNOWAGE_COCKPIT_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_COCKPIT_ENGINE}.war -d ${KNOWAGE_COCKPIT_ENGINE} && \
       rm -rf tmp ${KNOWAGE_COCKPIT_ENGINE}.* && \
    wget "${KNOWAGE_COMMONJ_URL}" -O ${KNOWAGE_COMMONJ_ENGINE}.zip && \
       unzip ${KNOWAGE_COMMONJ_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_COMMONJ_ENGINE}.war -d ${KNOWAGE_COMMONJ_ENGINE} && \
       rm -rf tmp ${KNOWAGE_COMMONJ_ENGINE}.* && \
    wget "${KNOWAGE_DATAMINING_URL}" -O ${KNOWAGE_DATAMINING_ENGINE}.zip && \
       unzip ${KNOWAGE_DATAMINING_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_DATAMINING_ENGINE}.war -d ${KNOWAGE_DATAMINING_ENGINE} && \
       rm -rf tmp ${KNOWAGE_DATAMINING_ENGINE}.* && \
    wget "${KNOWAGE_GEOREPORT_URL}" -O ${KNOWAGE_GEOREPORT_ENGINE}.zip && \
       unzip ${KNOWAGE_GEOREPORT_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_GEOREPORT_ENGINE}.war -d ${KNOWAGE_GEOREPORT_ENGINE} && \
       rm -rf tmp ${KNOWAGE_GEOREPORT_ENGINE}.* && \
    wget "${KNOWAGE_JASPERREPORT_URL}" -O ${KNOWAGE_JASPERREPORT_ENGINE}.zip && \
       unzip ${KNOWAGE_JASPERREPORT_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_JASPERREPORT_ENGINE}.war -d ${KNOWAGE_JASPERREPORT_ENGINE} && \
       rm -rf tmp ${KNOWAGE_JASPERREPORT_ENGINE}.* && \
    wget "${KNOWAGE_KPI_URL}" -O ${KNOWAGE_KPI_ENGINE}.zip && \
       unzip ${KNOWAGE_KPI_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_KPI_ENGINE}.war -d ${KNOWAGE_KPI_ENGINE} && \
       rm -rf tmp ${KNOWAGE_KPI_ENGINE}.* && \
    wget "${KNOWAGE_META_URL}" -O ${KNOWAGE_META_ENGINE}.zip && \
       unzip ${KNOWAGE_META_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_META_ENGINE}.war -d ${KNOWAGE_META_ENGINE} && \
       rm -rf tmp ${KNOWAGE_META_ENGINE}.* && \
    wget "${KNOWAGE_NETWORK_URL}" -O ${KNOWAGE_NETWORK_ENGINE}.zip && \
       unzip ${KNOWAGE_NETWORK_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_NETWORK_ENGINE}.war -d ${KNOWAGE_NETWORK_ENGINE} && \
       rm -rf tmp ${KNOWAGE_NETWORK_ENGINE}.* && \
    wget "${KNOWAGE_QBE_URL}" -O ${KNOWAGE_QBE_ENGINE}.zip && \
       unzip ${KNOWAGE_QBE_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_QBE_ENGINE}.war -d ${KNOWAGE_QBE_ENGINE} && \
       rm -rf tmp ${KNOWAGE_QBE_ENGINE}.* && \
    wget "${KNOWAGE_SDK_URL}" -O ${KNOWAGE_SDK_ENGINE}.zip && \
       unzip ${KNOWAGE_SDK_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_SDK_ENGINE}.war -d ${KNOWAGE_SDK_ENGINE} && \
       rm -rf tmp ${KNOWAGE_SDK_ENGINE}.* && \
    wget "${KNOWAGE_SVGVIEWER_URL}" -O ${KNOWAGE_SVGVIEWER_ENGINE}.zip && \
       unzip ${KNOWAGE_SVGVIEWER_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_SVGVIEWER_ENGINE}.war -d ${KNOWAGE_SVGVIEWER_ENGINE} && \
       rm -rf tmp ${KNOWAGE_SVGVIEWER_ENGINE}.* && \
    wget "${KNOWAGE_TALEND_URL}" -O ${KNOWAGE_TALEND_ENGINE}.zip && \
       unzip ${KNOWAGE_TALEND_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_TALEND_ENGINE}.war -d ${KNOWAGE_TALEND_ENGINE} && \
       rm -rf tmp ${KNOWAGE_TALEND_ENGINE}.* && \
    wget "${KNOWAGE_WHATIF_URL}" -O ${KNOWAGE_WHATIF_ENGINE}.zip && \
       unzip ${KNOWAGE_WHATIF_ENGINE}.zip -d tmp && \
       unzip tmp/${KNOWAGE_WHATIF_ENGINE}.war -d ${KNOWAGE_WHATIF_ENGINE} && \
       rm -rf tmp ${KNOWAGE_WHATIF_ENGINE}.*

#go to apache tomcat lib directory
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/lib

#download knowage libs and put them into apache tomcat lib
RUN wget "${LIB_COMMONS_LOGGING_URL}" && \
    wget "${LIB_COMMONS_LOGGING_API_URL}" && \
    wget "${LIB_CONCURRENT_URL}" && \
    wget "${LIB_MYSQL_CONNECTOR_URL}" && \
    wget "${LIB_GERONIMO_COMMONJ_URL}" && \
    wget "${LIB_MYFOO_COMMONJ_URL}" && \
    #download DBs libraries and put them into apache tomcat lib
    wget "${LIB_POSTGRESQL_CONNECTOR_URL}" && \
    #create setenv.sh file
    #increase Java Heap memory to 4GB - JAVA_OPTS
    touch ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/bin/setenv.sh && \
    echo "JAVA_OPTS=\"${JAVA_OPTS} -Xmx4g\"" >> ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/bin/setenv.sh

#go to apache tomcat configuration directory
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/conf

#override apache tomcat server configuration
COPY ./server.xml ./

#go to binary folder in order to execute tomcat startup
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/bin

#make the script executable by bash (not only sh) and
#make knowage running forever without exiting when running the container
RUN sed -i "s/bin\/sh/bin\/bash/" startup.sh && \
	sed -i "s/EXECUTABLE\" start/EXECUTABLE\" run/" startup.sh

#copy entrypoint to be used at runtime
COPY ./entrypoint.sh ./

#make all scripts executable
RUN chmod +x *.sh

#expose common tomcat port
#this can be used by the host to expose the application
#you can use it while running image with the param '-p 8080:8080'
EXPOSE 8080

#-d option is passed to run knowage forever without exiting from container
ENTRYPOINT ["./entrypoint.sh"]

#this will start knowage just after the previous entrypoint
CMD ["./startup.sh"]