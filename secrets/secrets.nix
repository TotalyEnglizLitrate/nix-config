# Used only by the `agenix` CLI (not imported by the flake).
# Create/edit a secret from this directory:  agenix -e engliz-password.age
# Re-key after changing recipients:          agenix -r
let
  # you, for editing secrets (passphrase-protected is fine here)
  engliz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtlDkVL/0TH2zsD+nSawpwChiXH9QYkDXXxtaNtji5g";

  # shared machine key, installed at /var/lib/agenix/key on every host.
  # create with: ssh-keygen -t ed25519 -N "" -C agenix-machines -f ./agenix-key
  # then paste the contents of agenix-key.pub below
  machines = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQw+aMURbj8+9F04LumAzskkG24eZNCpsvFyzB+GAVV agenix-machines";

  recipients = [engliz machines];
in {
  # hashed login password (mkpasswd -m yescrypt)
  "engliz-password.age".publicKeys = recipients;
  # private key installed at ~/.ssh/git
  "engliz-ssh-git.age".publicKeys = recipients;
  # private key installed at ~/.ssh/ssh-key-oracle
  "engliz-ssh-oracle.age".publicKeys = recipients;
  # bare Cloudflare API token (Zone:DNS:Edit, scoped to the zone)
  "cloudflare-dns-token.age".publicKeys = recipients;
  # ADMIN_TOKEN='<argon2 hash>'  (optional, enables the vaultwarden admin page)
  "vaultwarden-env.age".publicKeys = recipients;
}
