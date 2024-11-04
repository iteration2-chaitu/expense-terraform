data "vault_generic_secret" "rds" {
  path = "rds/dev"
  // path = "common/ssh"
}