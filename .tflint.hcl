config {
  format = "compact"
  module = false
  force  = false
}

# Enable all rules, always. The bundled plugin uses only recommended.
plugin "terraform" {
  enabled = true
  preset  = "all"
}

# Disallow module source without pinning to a version.
rule "terraform_module_pinned_source" {
  enabled = true
  style   = "semver"
}

# Enforces naming conventions.
rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}
