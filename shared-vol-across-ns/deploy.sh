kubectl -n kube-system exec -it $(kubectl get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}') -- /opt/pwx/bin/pxctl v create px-shared-vol --size 1 --sharedv4=true
kubectl create ns test1
kubectl create ns test2
cat <<EOF |kubectl apply -f -
---
apiVersion: v1
kind: Pod
metadata:
   name: nginx-px
   namespace: test1
spec:
   containers:
   - image: nginx
     name: nginx-px
     volumeMounts:
     - mountPath: /test-portworx-volume
       name: px-shared-vol
   volumes:
   - name: px-shared-vol
     portworxVolume:
       volumeID: px-shared-vol
---
apiVersion: v1
kind: Pod
metadata:
   name: nginx-px
   namespace: test2
spec:
   containers:
   - image: nginx
     name: nginx-px
     volumeMounts:
     - mountPath: /test-portworx-volume
       name: px-shared-vol
   volumes:
   - name: px-shared-vol
     portworxVolume:
       volumeID: px-shared-vol
EOF
