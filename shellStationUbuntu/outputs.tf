output "shell_station_dns_name" {
  value=azurerm_public_ip.pip.domain_name_label
}
