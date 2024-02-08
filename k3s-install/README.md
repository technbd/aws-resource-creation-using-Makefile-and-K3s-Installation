
# Install K3s Kubernetes Cluster:
K3s is a lightweight, easy-to-install, and certified Kubernetes distribution designed for production workloads in resource-constrained environments. Developed by Rancher Labs, K3s aims to provide a fully compliant Kubernetes distribution that is simple to deploy, yet powerful enough for various use cases.

After running this installation:

- K3s provides a built-in kubectl utility.
- Additional utilities will be installed, including kubectl, crictl, ctr, k3s-killall.sh, and k3s-uninstall.sh
- A kubeconfig file will be written to "/etc/rancher/k3s/k3s.yaml" and the kubectl installed by K3s will automatically use it.
-  The available lightweight datastore based on sqlite3 as the default storage backend (also support etcd3, MySQL, and Postgres).
- By default, K3S will run with flannel as the CNI, using VXLAN as the default backend.


## Prerequisites:
Before installing K3s, make sure your system meets the following minimum system requirements: 

- OS: Ubuntu/Debian, CentOS, RHEL and Raspberry Pi.
- CPU 2 cores
- RAM 2 GB
- Docker/Containerd
- Disable swap on your system
- K3s server needs port 6443 to be accessible by all nodes.
- Disable the firewall or allow the necessary ports: 6443, 10250, 2379 and 8472/udp

- If you wish to utilize the metrics server, all nodes must be accessible to each other on port 10250.

- If you plan on achieving high availability with embedded etcd, server nodes must be accessible to each other on ports 2379 and 2380.
- The nodes need to be able to reach other nodes over UDP port 8472 when using the Flannel VXLAN backend.

- Check the K3s documentation for a comprehensive list of required ports.


## Set Hostname:

```
hostnamectl set-hostname master
hostnamectl set-hostname worker1
hostnamectl set-hostname worker2
```


## Install K3s:

```
curl -sfL https://get.k3s.io | sh -
```



## Install K3s without ingress "traefik" controller:

```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -s -

or,

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
```


## Check K3s Master status: 

```
systemctl status k3s
```


```
k3s -version
```


```
kubectl version
```


```
kubectl cluster-info
```


```
kubectl config view
```


```
kubectl api-resources
```

```
kubectl get cs
kubectl get componentstatus
```


```
ps fxa | grep containerd
```


```
ll /var/lib/rancher/k3s/server/manifests

drwx------ 2 root root 4096 Feb  5 17:05 metrics-server/
-rw------- 1 root root 1914 Feb  5 17:05 ccm.yaml
-rw------- 1 root root 4967 Feb  5 17:05 coredns.yaml
-rw------- 1 root root 3764 Feb  5 17:05 local-storage.yaml
-rw------- 1 root root 1545 Feb  5 17:05 rolebindings.yaml
-rw------- 1 root root  927 Feb  5 17:05 runtimes.yaml
```


```
## Network device flannel.1:

ifconfig flannel.1


## Bridge cni0:

ifconfig cni0
```


```
cat /var/lib/rancher/k3s/agent/etc/cni/net.d/10-flannel.conflist
```


```
cat /run/flannel/subnet.env
```



## Check the Cluster Nodes:

```
kubectl get node

NAME     STATUS   ROLES                  AGE     VERSION
master   Ready    control-plane,master   6m33s   v1.28.5+k3s1
```



## Check the Cluster Pods:

```
kubectl get pod -A

NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   coredns-6799fbcd5-5mxkg                   1/1     Running   0          6m15s
kube-system   local-path-provisioner-84db5d44d9-b477s   1/1     Running   0          6m15s
kube-system   metrics-server-67c658944b-z7gf6           1/1     Running   0          6m15s
```


```
kubectl get deploy -A
```


```
kubectl get ns
```


```
kubectl get pods -n kube-system
```


## Check the Cluster Services:

```
kubectl get svc -A 
```



### For Normal (sudo) User: 

```
echo $USER
pwd

mkdir ~/.kube

sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER ~/.kube/config
sudo chmod 600 ~/.kube/config

ll ~/.kube/config

export KUBECONFIG=~/.kube/config
```

```
kubectl get nodes
```




## To add nodes to a K3s cluster: 

To install additional agent nodes and add them to the cluster, run the installation script with the K3S_URL and K3S_TOKEN environment variables. 

The K3s agent will register with the K3s server listening at the supplied URL. The value to use for K3S_TOKEN is stored at "/var/lib/rancher/k3s/server/node-token" on your server node.

Here is an example showing how to join an agent:

```
ll /var/lib/rancher/k3s/server/node-token
cat /var/lib/rancher/k3s/server/node-token
```

**Apply to nodes:**

``` 
curl -sfL https://get.k3s.io | K3S_URL=https://k3s_server_ip:6443 K3S_TOKEN=mynodetoken sh -
```


### Check agent nodes status: 
```
systemctl status k3s-agent
```


## To uninstall K3s from a server node, run:

```
ll /usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-uninstall.sh
```



## To uninstall K3s from an agent node, run:

```
ll /usr/local/bin/k3s-agent-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh
```


### Links:
- [K3s Install](https://docs.k3s.io/quick-start)


That's it! You now have a basic K3s Kubernetes cluster up and running. Make sure to consult the official K3s documentation for any specific requirements or advanced configurations you might need for your setup.



