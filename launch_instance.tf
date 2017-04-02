variable "region" {
  default = "us-central1-a" // We're going to need it in several places in this config
}

provider "google" {
  credentials = "${file("mycred.json")}"
  project     = "tokyo-flames-163013"
  region      = "us-central1-a"
}

resource "google_compute_instance" "taskwordpress" {
  name         = "taskwordpress" // yields "test1", "test2", etc. It's also the machine's name and hostname
  machine_type = "f1-micro" // smallest (CPU &amp; RAM) available instance
  zone         = "us-central1-a" // yields "europe-west1-d" as setup previously. Places your VM in Europe

  disk {
    image = "ubuntu-1404-trusty-v20170330" // the operative system (and Linux flavour) that your machine will run
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }
metadata_startup_script = "echo #!/bin/bash \n sudo apt-get update \n sudo apt-get upgrade \n sudo apt-get install apache2 apache2-doc apache2-utils -y \n sudo apt-get install php5 libapache2-mod-php5 -y \n sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password' \n sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password' \n sudo apt-get install mysql-server php5-mysql -y \n cd /var/www/html \n rm -r index.html \n wget https://wordpress.org/latest.tar.gz \n tar -xzf latest.tar.gz \n cp -r wordpress/* /var/www/html/ \n rm -rf wordpress \n rm -rf latest.tar.gz \n chmod -R 755 wp-content \n chown -R www-data.www-data wp-content \n sudo service apache2 restart > /startscript.sh"

}
