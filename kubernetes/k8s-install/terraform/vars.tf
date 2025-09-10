variable "pves" {
  type = list(object({
    name = string
    address = string
  }))
}

variable "endpoint" {
  type = string
}

variable "api_token" {
  type = string
  sensitive = true
}

variable "k8s_controllers" {
  type = list(object({
    address = string
    cpu = number
    disk = number
    memory = number
    name = string
    node_name = string
    vm_id = number
  }))
}

variable "k8s_workers" {
  type = list(object({
    address = string
    cpu = number
    disk = number
    disk_data = number
    memory = number
    name = string
    node_name = string
    vm_id = number
  }))
}

variable "username" {
  type = string
}

variable "password" {
  type = string
  sensitive = true
}
