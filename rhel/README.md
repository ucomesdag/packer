  # RHEL Templates for Packer

### Introduction

This repository contains RHEL templates that can be used to create boxes for Vagrant using Packer ([Website](http://www.packer.io)) ([Github](http://github.com/mitchellh/packer)).

### Packer Version

[Packer](https://github.com/mitchellh/packer/blob/master/CHANGELOG.md) `1.2.4` or greater is required.

### RHEL Versions

The following RHEL versions are known to work (built with VirtualBox 5.2.12):

 * RHEL 7.4
 * RHEL 7.5

### Registration

The `vagrant-rhel_7.x.templatel` files are configured to work correctly with the `vagrant-registration` plugin (which you can install with `vagrant plugin install vagrant-registration`). You can set your Red Hat Subscription Manager registration information in the Vagrantfile or by exporting it to your environment (recommended):

```
$ export RHSM_USERNAME="your-user-name"
$ export RHSM_PASSWORD="your-long-and-complex-password"
```

### Using .box Files With Vagrant

The generated box files include a Vagrantfile template that is suitable for
use with Vagrant 1.6.2+.

```
$ vagrant init rhel_7.5 file://./rhel_7.5_virtualbox.box

# if you want the full template
$ tar -vxf rhel_7.5_virtualbox.box Vagrantfile
```

### Getting Started

1. Download the RHEL 7.x ISO (`rhel-server-7.x-x86_64-dvd.iso`)
2. Verify the SHA256 hash ( `sha256sum rhel-server-7.x-x86_64-dvd.iso` ) of the ISO. For example for rhel-server-7.4-x86_64-dvd.iso it should be `431a58c8c0351803a608ffa56948c5a7861876f78ccbe784724dd8c987ff7000` 
3. Clone this repo to a local directory
4. Move the `rhel-server-7.x-x86_64-dvd.iso` to the `iso/7.x` directory
5. Run: 
    ```
    $ packer build \
        -var iso_url=./iso/rhel-server-7.4-x86_64-dvd.iso \
        -var iso_checksum=431a58c8c0351803a608ffa56948c5a7861876f78ccbe784724dd8c987ff7000 rhel-7.4.json
    ```
    or just
    ```
    $ packer build rhel-7.4.json
    ```

### Variables

The Packer templates support the following variables:

| Name                | Description                                                      |
| --------------------|------------------------------------------------------------------|
| `iso_url`           | Path or URL to ISO file                                          |
| `iso_checksum`      | Checksum (see also `iso_checksum_type`) of the ISO file          |
| `iso_checksum_type` | The checksum algorithm to use (out of those supported by Packer) |
