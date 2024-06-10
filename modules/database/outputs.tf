output "db_instance_ip" {
  value = scaleway_rdb_instance.db_instance.private_network
}

output "read_replica_ip" {
  value = [for replica in scaleway_rdb_read_replica.replica : replica.private_network]
}
