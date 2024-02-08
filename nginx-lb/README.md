
## Install Nginx LB:

To configure Nginx as a Layer 7 host-based load balancer, where traffic is routed based on the hostnames (domain names), you can follow these steps:


```
### Ubuntu/Debian:

sudo apt update
sudo apt install nginx
```


```
### CentOS/RHEL:

sudo yum install epel-release
sudo yum install nginx
```


## Set Hostname:

```
hostnamectl set-hostname nginx-lb
```


## Configuration:

Create a Load Balancer Configuration File locate the "/etc/nginx/nginx.conf" and Check configuration file and restart the service:

```
nginx -t
systemctl restart nginx
```


**Local DNS Entry:**
Binding local DNS entries involves configuring your local system to map domain names to specific IP addresses, allowing you to access services or websites using custom domain names without relying on public DNS servers. This can be useful for development environments or testing purposes. 

- On Unix-like systems (Linux, macOS, etc.), you can edit the "/etc/hosts" file.
- On Windows, the hosts file is located at "C:\Windows\System32\drivers\etc\hosts".

Here's how you can set up local DNS entry binding:

```
54.89.251.24x	wear.idea.com
54.89.251.24x	watch.idea.com
```


With this setup, Nginx will act as a Layer 7 load balancer, forwarding requests to the appropriate backend servers based on the requested hostname. Make sure to adjust the configuration according to your specific requirements and add any additional settings, such as SSL/TLS termination or caching, as needed.

