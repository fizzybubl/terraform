resource "google_compute_instance" "test" {
    name = "test-vm"
    machine_type = var.machine_type
    boot_disk {
      
    }
    network_interface {
      network = "default"

      access_config {
        
      }
    }
}