.PHONY: all clean get build push

VERSION := 2.0.20200304.0
VAGRANT_USER := <your-vagrant-cloud-user>
BOX_NAME := amazonlinux2
BOX_VERSION := 1.0.0
PROVIDER := vmware_desktop
ACCESS_TOKEN := <your-vagrant-cloud-token>

all: clean get build push

clean:
	rm -rf build
	rm -f *.ova
	rm -f *.box
	rm -f amzn2-vmware_esx-*-x86_64.xfs.gpt.vmx
	rm -f SHA256SUMS

get:
	@echo "Get Amazon Linux 2 VMware OVA ..."
	wget https://cdn.amazonlinux.com/os-images/$(VERSION)/vmware/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.ova
	wget https://cdn.amazonlinux.com/os-images/$(VERSION)/vmware/SHA256SUMS	
	shasum -a 256 -c SHA256SUMS

build:
	@echo "Build Vagrant box ..."
	mkdir build
	hdiutil makehybrid -o build/seed.iso -hfs -joliet -iso -default-volume-name cidata seedconfig/
	/Applications/VMware\ Fusion.app/Contents/Library/VMware\ OVF\ Tool/ovftool amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.ova build/
	cp vmware_extendedConfigFile.vmx build/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmwarevm/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmx
	gsed -i "s/^displayname =.*/displayname = \"amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt\"/g" build/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmwarevm/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmx
	gsed -i "s/^scsi0:0\.fileName =.*/scsi0:0\.fileName = \"amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt-disk1.vmdk\"/g" build/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmwarevm/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmx
	gsed -i "s/^extendedConfigFile =.*/extendedConfigFile = \"amzn2-vmware_esx-$(VERSION).gpt.vmxf\"/g" build/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmwarevm/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmx
	/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -d build/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmwarevm/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt-disk1.vmdk
	mv build/seed.iso build/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmwarevm/seed.iso
	cd build/amzn2-vmware_esx-$(VERSION)-x86_64.xfs.gpt.vmwarevm && tar cvzf ../../$(BOX_NAME).box ./*

push:
	@echo "Push Box to Vagrant Cloud ..."
	$(eval UPLOAD_PATH=$(shell curl -s "https://vagrantcloud.com/api/v1/box/$(VAGRANT_USER)/$(BOX_NAME)/version/$(BOX_VERSION)/provider/$(PROVIDER)/upload?access_token=$(ACCESS_TOKEN)" | jq .upload_path))
	@echo "Uploading to Vagrant Cloud ..."
	curl -X PUT --upload-file $(BOX_NAME).box $(UPLOAD_PATH)
	@echo "Upload finished."

