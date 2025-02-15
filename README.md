# Firedancer ansible role
This repo contains Ansible role for deploying a Firedancer instance in docker with docker-compose.

Firedancer is a new validator client for [Solana](https://github.com/anza-xyz/agave).

## Skill requirements
- Experience working with [Ansible](https://github.com/ansible/ansible)
- Experience working with Docker

## Requirements for the host system
- Docker
- Docker Compose

## Docker setup
Docker must be configured with firewall disabled and without a bridge.

Example `/etc/docker/daemon.json`
```json
{
    "bridge": "none",
    "containerd": "/run/containerd/containerd.sock",
    "data-root": "/var/lib/docker",
    "dns": [
        "1.1.1.1",
        "8.8.8.8"
    ],
    "hosts": [
        "fd://"
    ],
    "insecure-registries": [],
    "iptables": false,
    "storage-driver": "overlay2"
}
```

## Set Firedancer paramenters

| Variable                       | Description                                         |
|--------------------------------|-----------------------------------------------------|
| `firedancer_release`           | Current Firedancer release                          |
| `firedancer_workdir`           | The root directory for Firedancer data and configurations |
| `firedancer_ledger_path`       | Path to the ledger                                  |
| `firedancer_accounts_path`     | Path to the persistent accounts directory           |
| `firedancer_log_path`          | Path to the log directory                           |
| `firedancer_config_path`       | Path to the configuration directory                 |
| `firedancer_expected_genesis_hash` | Required genesis hash                           |
| `firedancer_validator_keypair` | Private validator keypair                           |
| `firedancer_vote_keypair`      | Private vote keypair                                |

> **Warning:** It is strongly recommended to fill the variables `firedancer_validator_keypair` and `firedancer_vote_keypair` from a secure secret storage solution, such as [Ansible Vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html), HashiCorp Vault, or any other similar service.

## Buld the Firedancer image

Go to Firedancer `firedancer_workdir` and bulid an image
```
cd /opt/firedancer
docker compose build
```

## Run Firedancer

```
systemctl start firedancer
```

Enable auto-start of the Firedancer container

```
systemctl enable firedancer
```

## Logs

Viewing logs using `docker logs`
```
docker logs -f firedancer
```

Viewing logs using `journald`
```
journalctl -fu firedancer
```

Viewing logs using log file
```
tail -f /opt/firedancer/log/firedancer.log
```

