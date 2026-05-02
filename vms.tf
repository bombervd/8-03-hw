

#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

data "yandex_compute_image" "Gitlab16" {
  family = "gitlab"
}

resource "yandex_compute_instance" "vd_gitlab" {
  name        = "${var.flow}-gitlab" #Имя ВМ в облачной консоли
  hostname    = "${var.flow}-gitlab" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 6
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.Gitlab16.image_id
      type     = "network-hdd"
      size     = 50
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_b.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }
}


resource "yandex_compute_instance" "vd_gitrunner" {
  name        = "${var.flow}-gitrunner" #Имя ВМ в облачной консоли
  hostname    = "${var.flow}-gitrunner" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 2
    memory        = 6
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 50
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_b.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }
}


resource "yandex_compute_instance" "vd_gitspellcheck" {
  name        = "${var.flow}-gitspellcheck" #Имя ВМ в облачной консоли
  hostname    = "${var.flow}-gitspellcheck" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 6
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 50
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_b.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id]

  }
}



resource "local_file" "inventory" {
  content  = <<-XYZ
  [Gitlab]
  ${yandex_compute_instance.vd_gitlab.network_interface.0.nat_ip_address}
  
  [Runner]
  ${yandex_compute_instance.vd_gitrunner.network_interface.0.nat_ip_address}
  
  [Checker]
  ${yandex_compute_instance.vd_gitspellcheck.network_interface.0.nat_ip_address}

  XYZ
  filename = "./hosts.ini"
}

resource "local_file" "inner_ips" {
  content  = <<-XYZ
  [Gitlab]
  ${yandex_compute_instance.vd_gitlab.network_interface.0.ip_address}
  
  [Runner]
  ${yandex_compute_instance.vd_gitrunner.network_interface.0.ip_address}
  
  [Checker]
  ${yandex_compute_instance.vd_gitspellcheck.network_interface.0.ip_address}

  XYZ
  filename = "./inner_ips.txt"
}



