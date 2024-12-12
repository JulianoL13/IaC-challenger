terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
    }
  }
}

variable "do_token" {}

variable "ssh-path" {}

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


resource "digitalocean_ssh_key" "httpsvkey" {
  name       = "httpsvkey-1"
  public_key = file(var.ssh-path)
}


resource "digitalocean_firewall" "korpfirewall" {
  name = "basic-rule"

  droplet_ids = [digitalocean_droplet.httpserver.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["192.168.1.0/24", "2002:1:2::/48"]
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
}