
#NAMES=$(kubectl get csv cert-manager.v1.5.4 -n openshift-operators -o=jsonpath={.status..requirementStatus..name})
#
#if [[ "${NAMES}" =~ cert-manager.v1.5.4 && "${NAMES}" =~ certificaterequests.cert-manager.io ]]; then
#    echo "yes"
#fi


count=0
NAMES=$(kubectl get csv cert-manager.v1.5.4 -n openshift-operators -o=jsonpath={.status..requirementStatus..name})

until [[ "${NAMES}" =~ cert-manager.v1.5.4 && "${NAMES}" =~ certificaterequests.cert-manager.io  ]] || [[ $count -eq 3 ]]; do
    count=$((count + 1))
    sleep 5
    NAMES=$(kubectl get csv cert-manager.v1.5.4 -n openshift-operators -o=jsonpath={.status..requirementStatus..name})
done

if [[ $count -eq 3 ]]; then
  echo "Timed out waiting for CertManager to deploy"
  exit 1
fi

