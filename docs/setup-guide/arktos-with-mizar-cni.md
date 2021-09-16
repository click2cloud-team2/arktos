# Deploy Arktos cluster with Mizar CNI

This document captures the steps to deploy an Arktos cluster lab with mizar cni. The machines in this lab used are AWS EC2 t2-large (2 CPUs, 8GB mem), Ubuntu 18.04 LTS.
 
1. Arktos requires a few dependencies to build and run, and a bash script is provided to install them.
```bash
wget https://raw.githubusercontent.com/CentaurusInfra/arktos/master/hack/setup-dev-node.sh
sudo bash setup-dev-node.sh
git clone https://github.com/CentaurusInfra/arktos.git ~/go/src/k8s.io/arktos
echo export PATH=$PATH:/usr/local/go/bin\ >> ~/.profile
echo cd \$HOME/go/src/k8s.io/arktos >> ~/.profile
source ~/.profile
```
   
2. To check kernel, run following command

```bash
uname -a
```

If it is greater or equal to version`5.6.0-rc2` then you can skip this step

To update Kernel, download and run:
```bash
wget https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/kernelupdate.sh
sudo bash kernelupdate.sh
```

3. Start Arktos cluster
```bash
cd $HOME/go/src/k8s.io/arktos
CNIPLUGIN=mizar ./hack/arktos-up.sh
```

4. Leave the "arktos-up.sh" terminal and open another terminal. Run the following command to confirm that the first network, "default", in system tenant, has already been created. Its state is empty at this moment.
```bash
./cluster/kubectl.sh get net
NAME      TYPE    VPC                      PHASE   DNS
default   mizar   system-default-network    
```

Now, the default network of system tenant should be Ready.
```bash
./cluster/kubectl.sh get net
NAME      TYPE   VPC                       PHASE   DNS
default   mizar  system-default-network    Ready   10.0.0.207
```

From now on, you should be able to use the arktos cluster with mizar cni.
