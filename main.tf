terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "my_token"
  cloud_id  = "my_cloud_id"
  folder_id = "my_folder_id"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name = "sql1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8u2e47jlq81vqvg87t"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#provisioner "remote-exec" {
#  inline = [
#    "sudo apt-get update",
#    "sudo apt-get install ca-certificates curl gnupg -y",
#    "sudo install -m 0755 -d /etc/apt/keyrings",
#    "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
#    "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
#    "echo \"deb [arch=\\\"$(dpkg --print-architecture)\\\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \\\"$(. /etc/os-release && echo \\\"$VERSION_CODENAME\\\")\\\" stable\" | sudo tee /etc/apt/sou$
#    "sudo apt-get update",
#    "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
#    "sudo apt-get remove docker-compose",
#    "wget https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64",
#    "sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose",
#    "sudo chmod +x /usr/local/bin/docker-compose"
#    ]
#    connection {
#      type = "ssh"
#      user = "winkel"
#      private_key = file("./ykey")
#      host = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
#    }
#  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network-1.id

}


resource "yandex_compute_instance" "vm-2" {
  name = "sql2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8u2e47jlq81vqvg87t"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }

#provisioner "remote-exec" {
#  inline = [
#    "sudo apt-get update",
#    "sudo apt-get install ca-certificates curl gnupg -y",
#    "sudo install -m 0755 -d /etc/apt/keyrings",
#    "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
#    "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
#    "echo \"deb [arch=\\\"$(dpkg --print-architecture)\\\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \\\"$(. /etc/os-release && echo \\\"$VERSION_CODENAME\\\")\\\" stable\" | sudo tee /etc/apt/sou$
#    "sudo apt-get update",
#    "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
#    "sudo apt-get remove docker-compose",
#    "wget https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64",
#    "sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose",
#    "sudo chmod +x /usr/local/bin/docker-compose"
#    ]
#    connection {
#      type = "ssh"
#      user = "winkel"
#      private_key = file("./ykey")
#      host = yandex_compute_instance.vm-2.network_interface[0].nat_ip_address
#    }
#  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}
output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

