# gogs container image was pulled into the isolated registry with skopeo.  Now import that image into your integrated registry with oc tools.
oc import-image docker-registry.default.svc:5000/gogs:latest --from=isolated1.7ad6.internal:5000/wkulhanek/gogs:latest --confirm --insecure=true -n openshift

# nexus was pulling into the isolated registry with skopeo.  Now import that image into your integrated registry with oc tools so you can deploy it soon.
oc import-image docker-registry.default.svc:5000/sonatype/nexus3:latest --from=isolated1.7ad6.internal:5000/sonatype/nexus3:latest --confirm --insecure=true -n openshift

# gogs will require a postgresql database.  Import it from the isolated registry into the integrated registry, so we can deploy it soon.
# delete the postgresql image stream first
oc delete is postgresql -n openshift
oc import-image docker-registry.default.svc:5000/rhscl/postgresql:9.6 --from=isolated1.7ad6.internal:5000/rhscl/postgresql-96-rhel7:latest --confirm --insecure=true -n openshift
# tag the postgresql as the lastest available
oc tag postgresql:9.6 postgresql:latest -n openshift

oc delete is jboss-eap71-openshift -n openshift
oc import-image docker-registry.default.svc:5000/openshift/jboss-eap71-openshift:1.3 --from=isolated1.7ad6.internal:5000/jboss-eap-7/eap71-openshift --confirm --insecure=true -n openshift
