# 🎬 Home Media Automation Stack

A complete, Infrastructure-as-Code deployment for an automated home media server. This stack handles secure downloading, media management, metadata scraping, and streaming via a unified Docker Compose architecture.

## 🏗 Architecture Overview

* **Network Security:** [Gluetun](https://github.com/qdm12/gluetun) routing traffic through Mullvad VPN (WireGuard).
* **Download Client:** [qBittorrent](https://www.qbittorrent.org/) (forced through the Gluetun VPN network).
* **Indexer Management:** [Prowlarr](https://prowlarr.com/) for managing tracker APIs.
* **Media Automation:** [Sonarr](https://sonarr.tv/) (TV/Anime) and [Radarr](https://radarr.video/) (Movies).
* **Media Servers:** [Jellyfin](https://jellyfin.org/) (Primary) and [Plex](https://www.plex.tv/) (Fallback/Host Network).
* **Request Portal:** [Jellyseerr](https://github.com/Fallenbagel/jellyseerr) for a unified UI to request new media.

## 📋 Prerequisites

1. A Linux server (Debian/Ubuntu recommended).
2. [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) installed.
3. A [Mullvad VPN](https://mullvad.net/) account with a generated WireGuard configuration file.
4. A standard non-root user with `sudo` privileges.

## 🚀 Installation & Deployment

### 1. Prepare the Host Environment
Because we are deploying to `/opt/media`, we need to create the directory, grant your user ownership, and clone the repository directly into it.

```bash
sudo mkdir -p /opt/media
sudo chown -R $USER:$USER /opt/media
git clone [https://github.com/Smile9799/home-media.git](https://github.com/Smile9799/home-media.git) /opt/media/.
cd /opt/media
```

### 2. Initialize the Filesystem
Run the initialization script to automatically build out the required folder structure (`/data`, `/config`, `/scripts`, `/backups`) and set the strict permissions required for Docker and hardlinking.

```bash
chmod +x init.sh
sudo ./init.sh
```

### 3. Configure the Environment Variables
Create a `.env` file to hold your secrets and configuration variables. **Do not commit this file to version control.**

```bash
nano .env
```

Paste the following template and update the Mullvad keys with your actual WireGuard details:

```env
# User / Group Identifiers
PUID=1000
PGID=1000
TZ=Africa/Johannesburg

# File System Paths
ROOT_DIR=/opt/media/data

# Mullvad VPN Configuration
VPN_PROVIDER=mullvad
VPN_TYPE=wireguard
WG_PRIVATE_KEY=your_private_key_here
WG_ADDRESSES=your_address_here
VPN_CITY=Johannesburg
```

### 4. Deploy the Stack
Spin up the containers in the background. Docker will automatically read the `.env` file and provision the stack.

```bash
docker compose up -d
```

---

## 🌐 Service Access & Ports

Once the stack is running, access your web interfaces using your server's local IP address and the corresponding port.

| Service | Local URL | Notes |
| :--- | :--- | :--- |
| **Jellyseerr** | `http://<SERVER_IP>:5055` | Your main frontend for requesting media. |
| **Jellyfin** | `http://<SERVER_IP>:8096` | Primary media server. |
| **Plex** | `http://<SERVER_IP>:32400/web` | Secondary media server (running on host network). |
| **qBittorrent** | `http://<SERVER_IP>:8080` | Default credentials: `admin` / `adminadmin`. |
| **Prowlarr** | `http://<SERVER_IP>:9696` | Configure indexers here first. |
| **Sonarr** | `http://<SERVER_IP>:8989` | TV Show automation. |
| **Radarr** | `http://<SERVER_IP>:7878` | Movie automation. |

---

## ⚙️ Post-Installation Configuration

### Enabling Hardlinks (Crucial for Storage)
To ensure files are not duplicated across your hard drive, you must configure the Arrs to use hardlinks.
1. In both Sonarr and Radarr, go to **Settings > Media Management**.
2. Check the box for **"Show Advanced"** at the top.
3. Under the "Importing" section, ensure **Use Hardlinks instead of Copy** is enabled.

### Internal Docker Paths
When configuring root folders inside Sonarr, Radarr, and qBittorrent, **do not use the host paths**. Use the internal container paths mapped in the `docker-compose.yml`:
* **Torrents:** `/data/torrents/`
* **TV Shows:** `/data/media/tv/`
* **Movies:** `/data/media/movies/`

---

## 🛠 Maintenance Scripts

The `/scripts` directory contains utilities to keep the server healthy.

* `backup_configs.sh`: Compresses the entire `/config` directory and stores it in `/backups` (keeps a 7-day rolling archive).
* `fix_permissions.sh`: Rapidly resets ownership and permissions (775/664) across the `/data` directory if manual file moves break media server access.
* `update_stack.sh`: Pulls the latest Docker images, recreates outdated containers, and prunes dangling images to save space.

**Automating Backups (Cron):**
It is highly recommended to run the backup script nightly via `crontab -e`:
```bash
0 2 * * * /opt/media/scripts/backup_configs.sh >> /opt/media/scripts/backup.log 2>&1
```
