# k8s-installation-centos
![enter image description here](https://lh3.googleusercontent.com/XLVR6VqsqNEAjfIBec5vSu1ke5e1U7fLGuKvCWZP8R-zsG_9eZRtP8VO4dBVkBPqwEt6WVDp-VQuww)
## About...

*This repository is used to create ***Kubernetes Cluster*** using **8** simple steps on ***On premise servers**** 


## Table of Contents

* [What are the pre-requisites ?](#pre-requisites)
* [What are the VM's provisioned ?](#configuration)
* [How to deploy kubernetes cluster ?](#deploy)
* [How to access Kubernetes Dashboard ?](#dashboard)
* [How to install NFS Server ?](#addons)
* [What are the addons provided ?](#addons)


<a id="pre-requisites"></a>
## What are the pre-requisites ?
* [Git](https://git-scm.com/downloads "Git")


<a id="configuration"></a>
## What are the VM's provisioned ?

***Note: We are not going to create any VM's during this process. User is expected to have VM's before proceeding with this repository***

*Below is the ***example configuration*** that we are going to refer ***through out this repository***.*

*Name*|*IP*|*OS*|*RAM*|*CPU*|
|----|----|----|----|----|
*kubemaster1*   |*10.66.30.11*|*CentOS8*|*16GB* |*4*|
*kubework1*     |*10.66.30.12*|*CentOS8*|*16GB*|*4*|
*kubework2*     |*10.66.30.13*|*CentOS8*|*16GB*|*4*|
*kubework3*     |*10.66.30.14*|*CentOS8*|*16GB*|*4*|
*kubework4*     |*10.66.30.15*|*CentOS8*|*16GB*|*4*|


<a id="deploy"></a>
## How to deploy kubernetes cluster ?

## ***Step 1***

***Update host names for all nodes***
`$ hostnamectl
   hostnamectl setname $nameserver


## ***Step 2***

***clone Kubernetes_Cluster folder to all master/worker nodes***

Then give permissions executing the below command.*

`$ chmod +x -R Kubernetes_Cluster` 


## ***Step 3***

***Execute the prerequisite script on all master/worker nodes***

![enter image description here](https://lh3.googleusercontent.com/ilOz9uQHxUPmMM1JKlg3uBHZoBFWsFkHdUu2gsxwJe679fwDgPQHdZ-vhHiNbrMJaPAJCxva8LYGqg)

 `$ cd Kubernetes_Cluster/provisioning/prerequisites/
 `$ ./install.sh`


## ***Step 4***

***The nodes will reboot...

## ***Step 5***

***Execute the below script only on master node(s)***

`$ cd Kubernetes_Cluster/provisioning/vm-master`

`$ ./install.sh`


## ***Step 6***

***Execute the below script on all worker nodes***

![enter image description here](https://lh3.googleusercontent.com/uz3dGNIXtUP9sFZNrDE3EOLbRjh7j96hIa1_g_Uf7bu23DEvn-phgyaP3QVzWGbI0EtlvWW9IS6nNQ)

`$ cd Kubernetes_Cluster/provisioning/vm-worker`

`$ ./install.sh`

Then execute the kubeadm join command you get fron master node in step 5.

## ***Step 7***

***Execute the below script only on master node IP to install HELM***

`$ cd Kubernetes_Cluster/provisioning/helm`

`$ ./install.sh`

## ***Step 8***
***Verify installation is success by executing below two commands to see all the nodes and pods.***

`$ kubectl get nodes`

`$ kubectl get pods -o wide --all-namespaces`


<a id="dashboard"></a>

## How to access Kubernetes Dashboard ?

*The ***Kubernetes Dashboard*** can be accessed via the below URL with your ***master node IP*** with the same port ***30070****

[http://100.10.10.100:30070/#!/overview?namespace=_all](http://100.10.10.100:30070/#!/overview?namespace=_all)


<a id="nfs-configuration"></a>

## How to install NFS Server ?


*Here we are going use master node IP as NFS Server IP instead of configuring separate node.*

*Execute the below command only on master node IP to install NFS-Client-Provisioner.*

*Note: Please don't forget to change nfs.server in the below unix command with your master node IP configured.*


***Unix Command!!!***

`$ helm install stable/nfs-client-provisioner --name nfs-client-provisioner --set nfs.server=100.10.10.100 --set nfs.path=/mnt/storage --set storageClass.defaultClass=true`

<a id="addons"></a>
## What are the addons provided ?
* `kubernetes dashboard`
* `helm`
