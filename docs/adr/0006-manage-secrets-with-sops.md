# Manage secrets encrypted with SOPS

Store only SOPS-encrypted files containing secrets in the repository, keep age private keys outside the repository, and materialize required configuration files during Home Manager activation. Configuring every secret manually would remove the need to prepare a key, but would exclude secret placement from the environment reconstruction procedure, so that approach is not adopted. A new target environment needs its age private key provisioned separately; routine investigation and documentation must not open encrypted file contents.
