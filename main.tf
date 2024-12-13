terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
    }
  }
}

variable "do_token" {}

variable "ssh-path" {}

variable "iptest"{}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "httpserver" {
    name  = "httpserver-01"
    image = "ubuntu-20-04-x64"
    size = "s-1vcpu-1gb" 
    region = "nyc1"
    ssh_keys = [digitalocean_ssh_key.httpsvkey.fingerprint]
}

resource "digitalocean_reserved_ip_assignment" "ipassing" {
  ip_address = var.iptest  # Insira o IP reservado já existente
  droplet_id = digitalocean_droplet.httpserver.id
}

resource "digitalocean_ssh_key" "httpsvkey" {
  name       = "httpsvkey-test"
  public_key = file(var.ssh-path)
}


resource "digitalocean_firewall" "korpfirewall" {
  name = "basic-rule"
  droplet_ids = [digitalocean_droplet.httpserver.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "22"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}