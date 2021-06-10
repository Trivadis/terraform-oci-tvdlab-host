# Cloud Init Files and Templates

This directory contains cloud-init user data files and templates used to setup
and bootstrap the different compute instances. Files in this folder will be uploaded
after creation of the resource to the corresponding bootstrap folder on the resource.
The default location is `/home/${var.tvd_os_user}/cloudinit`.

- [templates](templates) Templates used as basis for the bootstrap scripts. Variables
  are replaced by terraform `tempfile`.
