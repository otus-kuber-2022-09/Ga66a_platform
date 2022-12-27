terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "master-0" {
  name                      = "master-0"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8t3oa3fuqmaouri568"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
resource "yandex_compute_instance" "master-1" {
  name                      = "master-1"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8t3oa3fuqmaouri568"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
resource "yandex_compute_instance" "master-2" {
  name                      = "master-2"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8t3oa3fuqmaouri568"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "worker-0" {
  name                      = "worker-0"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8t3oa3fuqmaouri568"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
resource "yandex_compute_instance" "worker-1" {
  name                      = "worker-1"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8t3oa3fuqmaouri568"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
resource "yandex_compute_instance" "worker-2" {
  name                      = "worker-2"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8t3oa3fuqmaouri568"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}


output "external_ip_address_master-0" {
  value = yandex_compute_instance.master-0.network_interface.0.nat_ip_address
}
output "external_ip_address_master-1" {
  value = yandex_compute_instance.master-1.network_interface.0.nat_ip_address
}
output "external_ip_address_master-2" {
  value = yandex_compute_instance.master-2.network_interface.0.nat_ip_address
}
output "external_ip_address_worker-0" {
  value = yandex_compute_instance.worker-0.network_interface.0.nat_ip_address
}
output "external_ip_address_worker-1" {
  value = yandex_compute_instance.worker-1.network_interface.0.nat_ip_address
}
output "external_ip_address_worker-2" {
  value = yandex_compute_instance.worker-2.network_interface.0.nat_ip_address
}


#output "internal_ip_address_vm_1" {
#  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
#}

#output "external_ip_address_vm_2" {
#  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
#}