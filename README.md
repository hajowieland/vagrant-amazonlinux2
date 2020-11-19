# vagrant-amazonlinux2
Vagrant Box (vmware_desktop) for Amazon Linux 2

**Vagrant Cloud:** [hajowieland/amazonlinux2](https://app.vagrantup.com/hajowieland/boxes/amazonlinux2)


## Requirements

* `brew install gnu-sed jq wget`
* Vagrant Cloud account


## Steps

0. Create a Vagrant Cloud API Token and put in the Makefile at `ACCESS_TOKEN` (or export it as Environment Variable)
1. Create a new Box at Vagrant Cloud
2. Create a new Version for this Box [More info](https://www.vagrantup.com/vagrant-cloud/boxes/create-version) and put in the Makefile at `BOX_VERSION`
3. Add a provider for the Version and choose e.g. **vmware_desktop**
4. Set the `VERSION` in Makefile to the VMware Amazon Linux 2 image at: https://cdn.amazonlinux.com/os-images/2.0.20200304.0/vmware/
5. Run `make all`
6. Release the version [More Info](https://www.vagrantup.com/vagrant-cloud/boxes/release-workflow)

## Links

* https://cdn.amazonlinux.com/os-images/latest/vmware/
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html
* https://www.vagrantup.com/vagrant-cloud/boxes/create-version
* https://www.vagrantup.com/vagrant-cloud/boxes/release-workflow
