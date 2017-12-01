variable "db_password" {
  description = "Password for postgres_db"
}

# NOTE: This variable was set without a default value on purpose
# To set a password to this variable run `export TF_VAR_db_password="[your password]"`
