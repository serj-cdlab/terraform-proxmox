FROM hashicorp/terraform:0.12.27

RUN apk add --no-cache make go

WORKDIR /root
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.io,direct
RUN git clone https://github.com/lausser/terraform-provider-proxmox && \
    go get github.com/Telmate/proxmox-api-go && \
    go install github.com/Telmate/proxmox-api-go && \
    cp go/bin/proxmox-api-go /usr/local/bin && \
    go get github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provider-proxmox && \
    cp terraform-provider-proxmox/proxmox/resource_vm_qemu.go ./go/pkg/mod/github.com/!telmate/terraform-provider-proxmox@*/proxmox/resource_vm_qemu.go && \
    rm -rf terraform-provider-proxmox && \
    go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provider-proxmox && \
    cp go/bin/terraform-provider-proxmox /usr/local/bin && \
    go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provisioner-proxmox && \
    cp go/bin/terraform-provisioner-proxmox /usr/local/bin && \
    mkdir -p ~/.terraform.d/plugins && \
    cp go/bin/terraform-provider-proxmox ~/.terraform.d/plugins && \
    cp go/bin/terraform-provisioner-proxmox ~/.terraform.d/plugins
