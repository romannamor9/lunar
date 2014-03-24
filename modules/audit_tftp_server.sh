# audit_tftp_server
#
# Turn off tftp
#
# Trivial File Transfer Protocol (TFTP) is a simple file transfer protocol,
# typically used to automatically transfer configuration or boot machines
# from a boot server. The package tftp-server is the server package used to
# define and support a TFTP server.
# TFTP does not support authentication nor does it ensure the confidentiality
# of integrity of data. It is recommended that TFTP be removed, unless there
# is a specific need for TFTP. In that case, extreme caution must be used when
# configuring the services.
#
# Refer to Section 2.1.8 Page(s) 52 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_tftp_server () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "TFTP Server Daemon"
      service_name="svc:/network/tftp/udp6:default"
      funct_service $service_name disabled
      service_name="svc:/network/tftp/udp4:default"
      funct_service $service_name disabled
      funct_check_perms /tftpboot 0744 root root
      funct_check_perms /etc/netboot 0744 root root
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "TFTP Server Daemon"
    funct_chkconfig_service tftp 3 off
    funct_chkconfig_service tftp 5 off
    funct_check_perms /tftpboot 0744 root root
    funct_check_perms /var/tftpboot 0744 root root
    if [ "$os_vendor" = "CentOS" ]; then
      funct_linux_package uninstall tftp-server
    fi
  fi
}