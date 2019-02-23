export OCP_USERNAME=andrew
oc create clusterquota clusterquota-${OCP_USERNAME} \
 --project-annotation-selector=openshift.io/requester=$OCP_USERNAME \
 --hard pods=25 \
 --hard requests.memory=6Gi \
 --hard requests.cpu=5 \
 --hard limits.cpu=25  \
 --hard limits.memory=40Gi \
 --hard configmaps=25 \
 --hard persistentvolumeclaims=25  \
 --hard services=25
