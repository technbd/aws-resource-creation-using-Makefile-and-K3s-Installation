
# Install OpenELB on Kubernetes:
OpenELB is an open-source load balancer implementation designed for exposing the LoadBalancer type of Kubernetes services in bare metal, edge, and virtualization environments.


```
kubectl apply -f https://raw.githubusercontent.com/openelb/openelb/master/deploy/openelb.yaml

or,

wget https://raw.githubusercontent.com/openelb/openelb/master/deploy/openelb.yaml


kubectl apply -f openelb.yaml
```

Run the following command to check whether the status of openelb-manager is READY: 1/1 and STATUS: Running. If yes, OpenELB has been installed successfully.

```
kubectl get ns
```

```
kubectl get deploy -n openelb-system
```


```
kubectl get pod -n openelb-system
```


---
---


# Install OpenELB on K3s:

Log in to the master node of the K3s Kubernetes cluster and run the following command:


```
kubectl apply -f https://raw.githubusercontent.com/openelb/openelb/master/deploy/openelb.yaml


or,

wget https://raw.githubusercontent.com/openelb/openelb/master/deploy/openelb.yaml


kubectl apply -f openelb.yaml
```


```
kubectl get ns
```


```
kubectl get pods -n openelb-system

NAME                              READY   STATUS      RESTARTS   AGE
openelb-manager-99b49789c-zqnjm   0/1     Pending     0          26s
openelb-admission-create-dqss2    0/1     Completed   0          26s
openelb-admission-patch-zvwqm     0/1     Completed   1          26s
```


```
kubectl describe pods openelb-manager-99b49789c-zqnjm -n openelb-system


Events:
  Type     Reason            Age                From               Message
  ----     ------            ----               ----               -------
  Warning  FailedScheduling  59s                default-scheduler  0/3 nodes are available: 3 node(s) didn't have free ports for the reque sted pod ports. preemption: 0/3 nodes are available: 3 No preemption victims found for incoming pod..
```



## Edit the openelb-manager Deployment:

By default, both OpenELB and K3s use port 443. Therefore, you need to change port 443 of OpenELB to avoid the port conflict.

Change port 443 to a different value (for example, 30443) to avoid a port conflict with K3s:

```
kubectl edit deployment openelb-manager -n openelb-system


spec:
...
...
  template:
  ...
  ...
    spec:
	...
	...
      containers:
      - args:
        - --webhook-port=443 # Change the port number.
		...
		...
        ports:
        - containerPort: 443 # Change the port number.
          hostPort: 443 # Change the port number.

```



```
kubectl get deploy -n openelb-system

NAME              READY   UP-TO-DATE   AVAILABLE   AGE
openelb-manager   1/1     1            1           5m34s
```


```
kubectl get pods -n openelb-system

NAME                               READY   STATUS      RESTARTS   AGE
openelb-admission-create-dqss2     0/1     Completed   0          5m52s
openelb-admission-patch-zvwqm      0/1     Completed   1          5m52s
openelb-manager-6dccc5b44c-ddx9c   1/1     Running     0          53s
openelb-keepalive-vip-cpjq7        1/1     Running     0          51s
openelb-keepalive-vip-cflfs        1/1     Running     0          51s
openelb-keepalive-vip-mmhfz        1/1     Running     0          51s
```


```
kubectl get -n openelb-system svc
```


---
---



## Configuration OpenELB:

**Configure IP Address Pools Using Eip:**

OpenELB assigns IP addresses in Eip objects to LoadBalancer Services in the Kubernetes cluster. Currently, OpenELB supports only IPv4 and will soon support IPv6.


You can create an Eip object to provide an IP address pool for OpenELB. The following is an example of the Eip YAML configuration:

```
apiVersion: network.kubesphere.io/v1alpha2
kind: Eip
metadata:
    name: eip-sample-pool
    annotations:
      eip.openelb.kubesphere.io/is-default-eip: "true"
spec:
    address: 192.168.10.193-192.168.10.194  # change IP
    protocol: layer2
    interface: ens33  # change interface
    disable: false
status:
    occupied: false
    usage: 1
    poolSize: 10
    used:
      "192.168.10.193": "default/test-svc"
    firstIP: 192.168.10.193
    lastIP: 192.168.10.194
    ready: true
    v4: true
```


```
kubectl get eip

NAME              CIDR                            USAGE   TOTAL
eip-sample-pool   192.168.10.193-192.168.10.194           2
```


### Links:
- [OpenELB on-kubernetes](https://openelb.io/docs/getting-started/installation/install-openelb-on-kubernetes/)
- [OpenELB openelb-on-k3s](https://openelb.io/docs/getting-started/installation/install-openelb-on-k3s/)
- [OpenELB configuration](https://openelb.io/docs/getting-started/configuration/configure-ip-address-pools-using-eip/)
- [OpenELB Github](https://github.com/openelb/openelb)
- [OpenELB L2](https://openelb.io/docs/concepts/layer-2-mode/)


Make sure to refer to the official documentation and engage with the community (if available) for any troubleshooting, tips, or best practices related to OpenELB.


