# Documentation Développeur


[Retour](./README.md)

Ce document explique comment configurer, construire, lancer, inspecter et maintenir le projet Inception en tant que développeur.

## Structure du projet

```text
.
|-- Makefile
|-- README.md
|-- USER_DOC.md
|-- DEV_DOC.md
|-- srcs
|   |-- docker-compose.yml
|   |-- .env.example
|   `-- requirements
|       |-- mariadb
|       |-- nginx
|       `-- wordpress
`-- bonus
    |-- Makefile
    `-- srcs
        |-- docker-compose.yml
        |-- .env.example
        `-- requirements
            |-- adminer
            |-- fail2ban
            |-- ftp
            |-- mariadb
            |-- nginx
            |-- redis
            `-- wordpress
```

La stack obligatoire se trouve dans `srcs`. La stack bonus se trouve dans `bonus/srcs`.

## Prérequis

Installez :

- `make`
- `docker`
- `docker compose`
- `sudo`
- `curl`

Les Makefiles utilisent `sudo` car ils créent et suppriment des répertoires de données sous `/inception/data` et exécutent des commandes Docker.

## Configuration des hôtes

Ajoutez les domaines locaux à `/etc/hosts` :

```text
127.0.0.1 jmougel.local
127.0.0.1 jmougel2.local
```

Utilisez `jmougel.local` pour WordPress et `jmougel2.local` pour le site statique bonus.

## Fichiers d’environnement et secrets

Créez le fichier d’environnement de la partie obligatoire :

```bash
cp srcs/.env.example srcs/.env
```

Créez le fichier d’environnement de la partie bonus :

```bash
cp bonus/srcs/.env.example bonus/srcs/.env
```

Variables obligatoires :

```env
DOMAIN_NAME=jmougel.local
CERTIF_NAME=cert

MARIADB_PORT=3306
MARIADB_USER=user
MARIADB_HOST=mariadb
MARIADB_NAME=mariadb
MARIADB_USER_PASSWORD=user_password
MARIADB_ROOT_PASSWORD=root_password
```

Variables supplémentaires pour le bonus :

```env
DOMAIN_NAME2=jmougel2.local
CERTIF_NAME2=cert2
FTP_USER=ftp_user
FTP_PASS=ftp_password
```

Ne committez pas les vrais fichiers `.env` ni les vrais secrets. Les fichiers `.env.example` documentent les clés requises.

## Construction et lancement

Stack obligatoire :

```bash
make up
```

Le Makefile à la racine exécute :

```bash
sudo mkdir -p /inception/data
sudo mkdir -p /inception/data/wp
sudo mkdir -p /inception/data/db
sudo chmod -R 777 /inception/data
sudo docker compose -f ./srcs/docker-compose.yml up --build -d
```

Stack bonus :

```bash
cd bonus
make up
```

Le Makefile du bonus utilise :

```bash
sudo docker compose -f ./srcs/docker-compose.yml up --build --timeout 300 -d
```

## Commandes du Makefile

| Commande | Description |
| --- | --- |
| `make up` | Démarre ou reconstruit la stack. |
| `make down` | Arrête les conteneurs sans supprimer les données persistantes. |
| `make re` | Supprime les volumes du projet et `/inception/data`, puis reconstruit la stack. |
| `make clean` | Arrête les conteneurs et supprime les volumes du projet ainsi que les données du projet. |
| `make fclean` | Exécute `clean` puis nettoie globalement les ressources Docker inutilisées. |

Utilisez `fclean` avec précaution, car `docker system prune -af` affecte des ressources Docker au-delà de ce projet.

## Commandes Docker Compose

Afficher et valider la configuration Compose :

```bash
docker compose -f srcs/docker-compose.yml config
docker compose -f bonus/srcs/docker-compose.yml config
```

Lister les conteneurs :

```bash
sudo docker compose -f srcs/docker-compose.yml ps
sudo docker compose -f bonus/srcs/docker-compose.yml ps
```

Construire les images sans démarrer les conteneurs :

```bash
sudo docker compose -f srcs/docker-compose.yml build
sudo docker compose -f bonus/srcs/docker-compose.yml build
```

Démarrer au premier plan pour déboguer :

```bash
sudo docker compose -f srcs/docker-compose.yml up --build
sudo docker compose -f bonus/srcs/docker-compose.yml up --build
```

Arrêter et supprimer les conteneurs :

```bash
sudo docker compose -f srcs/docker-compose.yml down
sudo docker compose -f bonus/srcs/docker-compose.yml down
```

Arrêter et supprimer les conteneurs ainsi que les volumes nommés :

```bash
sudo docker compose -f srcs/docker-compose.yml down -v
sudo docker compose -f bonus/srcs/docker-compose.yml down -v
```

## Gestion des conteneurs

Inspecter les logs :

```bash
sudo docker logs nginx
sudo docker logs wordpress
sudo docker logs mariadb
```

Ouvrir un shell dans un conteneur :

```bash
sudo docker exec -it nginx bash
sudo docker exec -it wordpress bash
sudo docker exec -it mariadb bash
```

Vérifier les réseaux Docker :

```bash
sudo docker network ls
sudo docker network inspect srcs_docker-network
```

Lister les volumes du projet :

```bash
sudo docker volume ls
```

Inspecter un volume du projet :

```bash
sudo docker volume inspect srcs_wordpress
sudo docker volume inspect srcs_mariadb
```

## Stockage des données et persistance

Les fichiers Compose définissent des volumes nommés basés sur des bind mounts côté hôte :

```text
srcs_wordpress -> /inception/data/wp
srcs_mariadb   -> /inception/data/db
```

Les fichiers WordPress persistent dans :

```text
/inception/data/wp
```

Les fichiers MariaDB persistent dans :

```text
/inception/data/db
```

`make down` conserve ces répertoires. `make clean` et `make re` les suppriment.

Le conteneur FTP bonus monte le volume WordPress dans :

```text
/inception/ftp
```

Cela signifie que les fichiers envoyés par FTP sont stockés dans le même volume persistant que WordPress.

## Rôle des services

### Nginx

Fichiers :

```text
srcs/requirements/nginx
bonus/srcs/requirements/nginx
```

Responsabilités :

- Générer des certificats TLS auto-signés.
- Servir le trafic HTTPS sur le port `443`.
- Transférer les requêtes PHP vers `wordpress:9000`.
- Dans le bonus, router `/adminer/` vers `adminer:9000`.
- Dans le bonus, servir le site statique pour `jmougel2.local`.

### WordPress

Fichiers :

```text
srcs/requirements/wordpress
bonus/srcs/requirements/wordpress
```

Responsabilités :

- Exécuter PHP-FPM sur le port interne `9000`.
- Télécharger WordPress avec WP-CLI.
- Déplacer et adapter `wp-config.php`.
- Générer les salts WordPress.
- Installer WordPress en utilisant les valeurs du `.env`.
- Dans le bonus, configurer l’intégration du cache Redis.

### MariaDB

Fichiers :

```text
srcs/requirements/mariadb
bonus/srcs/requirements/mariadb
```

Responsabilités :

- Écouter sur le port interne `3306`.
- Initialiser le répertoire de base de données si nécessaire.
- Créer la base de données et les utilisateurs configurés.
- Stocker les fichiers persistants de la base dans `/inception/data/db`.

### Services bonus

- `redis` : backend de cache pour WordPress.
- `adminer` : interface d’administration de base de données servie via Nginx.
- `ftp` : serveur vsftpd monté sur le volume WordPress.
- `fail2ban` : surveille `/var/log/vsftpd/vsftpd.log`.

## Checklist de validation

Exécuter les vérifications de syntaxe :

```bash
docker compose -f srcs/docker-compose.yml config
docker compose -f bonus/srcs/docker-compose.yml config
bash -n srcs/requirements/*/script/*.sh
bash -n bonus/srcs/requirements/*/script/*.sh
```

Vérifier les réponses HTTP :

```bash
curl -kI https://jmougel.local
curl -kI https://jmougel.local/wp-admin/
curl -kI https://jmougel.local/adminer/
curl -kI https://jmougel2.local
```

Comportement attendu :

- La configuration Compose est générée sans erreur.
- Tous les conteneurs attendus sont en cours d’exécution.
- Nginx répond sur le port `443`.
- WordPress peut se connecter à MariaDB.
- Les données restent présentes après `make down` puis `make up`.
- Les données sont recréées après `make clean` ou `make re`.

## Dépannage

Gateway timeout depuis Nginx :

- Vérifiez `sudo docker logs wordpress`.
- Confirmez que PHP-FPM fonctionne dans le conteneur WordPress.
- Confirmez que Nginx utilise `fastcgi_pass wordpress:9000`.
- Confirmez que MariaDB est prête avant que l’installation de WordPress ne se lance.

Erreurs de connexion à la base de données :

- Vérifiez `MARIADB_HOST=mariadb`.
- Vérifiez le nom de la base, l’utilisateur et le mot de passe dans `.env`.
- Vérifiez `sudo docker logs mariadb`.
- Recréez les données persistantes si d’anciens identifiants sont encore stockés.

Le domaine ne se résout pas :

- Vérifiez `/etc/hosts`.
- Utilisez `curl -kI https://jmougel.local` pour contourner le cache du navigateur et l’interface liée au certificat.

Conflit de port :

- Vérifiez si un autre service utilise déjà le port `443`.
- Arrêtez ce service ou modifiez le mapping de port Compose pour les tests en local.

État de volume obsolète :

- Exécutez `make clean` ou `make re`.
- Vérifiez que `/inception/data/wp` et `/inception/data/db` ont bien été supprimés.

[Retour](./README.md)
