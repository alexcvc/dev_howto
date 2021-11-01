# How to install debian 11


  https://trendoceans.com/how-to-install-cmake-on-debian-10-11/

  https://www.how2shout.com/linux/install-docker-ce-on-debian-11-bullseye-linux/
  
  https://markontech.com/linux/setup-nfs-server-on-debian/  

  https://www.how2shout.com/linux/install-ifconfigon-debian-11-or-10-if-command-not-found/
  
  https://trendoceans.com/how-to-install-cmake-on-debian-10-11/
  
  https://www.troublenow.org/752/debian-10-add-rc-local/
  
  ### Setup TFTP in debian 11
  
  https://www.cyberciti.biz/faq/install-configure-tftp-server-ubuntu-debian-howto/
  
  #### Configuration
  
Edit /etc/default/tftpd-hpa, run:

    vi /etc/default/tftpd-hpa

Sample configuration with root!:

    TFTP_USERNAME="root"
    TFTP_DIRECTORY="/srv/tftp"
    TFTP_ADDRESS="0.0.0.0:69"
    TFTP_OPTIONS="--secure"
