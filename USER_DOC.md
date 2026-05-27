# Documentation Utilisateur


[Retour](../README.md)

Ce document explique comment un utilisateur final ou un administrateur peut comprendre, démarrer, arrêter, accéder et vérifier la stack Inception.

## Services fournis

La stack obligatoire fournit trois services :

- **Nginx :** serveur web HTTPS public. Il reçoit le trafic navigateur sur le port `443` et transfère les requêtes PHP vers WordPress.
- **WordPress :** application web servie par PHP-FPM sur le port interne `9000`.
- **MariaDB :** serveur de base de données utilisé par WordPress sur le port interne `3306`.

La stack bonus ajoute :

- **Redis :** service de cache utilisé par WordPress.
- **Adminer :** interface d’administration de base de données accessible depuis le navigateur.
- **FTP :** accès aux fichiers du volume WordPress.
- **Fail2ban :** surveille les logs FTP et bloque les tentatives répétées échouées.
- **Site statique :** second site web servi par Nginx sur `jmougel2.local`.

Seuls Nginx et FTP exposent des ports publics sur l’hôte. Les autres services restent à l’intérieur du réseau Docker.

## Démarrer le projet

Démarrer la stack obligatoire depuis la racine du dépôt :

```bash
make up
```

Démarrer la stack bonus :

```bash
cd bonus
make up
```

Le Makefile crée les répertoires de données persistantes sous `/inception/data`, construit les images et démarre les conteneurs en arrière-plan.

## Arrêter le projet

Arrêter les conteneurs en cours d’exécution tout en conservant les données stockées :

```bash
make down
```

Reconstruire entièrement le projet à partir d’un répertoire de données propre :

```bash
make re
```

Supprimer les conteneurs du projet, les volumes Docker et le contenu de `/inception/data` :

```bash
make clean
```

Utilisez `make fclean` uniquement si vous souhaitez aussi nettoyer globalement les ressources Docker inutilisées :

```bash
make fclean
```

## Accéder au site web

Avant d’ouvrir le site, assurez-vous que les entrées suivantes existent dans `/etc/hosts` :

```text
127.0.0.1 jmougel.local
127.0.0.1 jmougel2.local
```

Ouvrir WordPress :

```text
https://jmougel.local
```

Votre navigateur peut afficher un avertissement concernant le certificat. C’est normal, car le projet génère un certificat auto-signé.

## Accéder aux panneaux d’administration

Panneau d’administration WordPress :

```text
https://jmougel.local/wp-admin/
```

Panneau Adminer bonus :

```text
https://jmougel.local/adminer/
```

Site statique bonus :

```text
https://jmougel2.local
```

Service FTP bonus :

```text
ftp://jmougel.local
```

Le FTP utilise les ports `20`, `21` et les ports passifs `65500-65515`.

## Localiser et gérer les identifiants

Les identifiants sont stockés dans le fichier `.env` utilisé par la stack.

Stack obligatoire :

```text
srcs/.env
```

Stack bonus :

```text
bonus/srcs/.env
```

Variables principales d’identification :

- `MARIADB_USER` : utilisateur MariaDB et nom d’utilisateur de l’auteur WordPress.
- `MARIADB_USER_PASSWORD` : mot de passe de l’utilisateur MariaDB et mot de passe de l’auteur WordPress.
- `MARIADB_ROOT_PASSWORD` : mot de passe root MariaDB et mot de passe administrateur WordPress.
- `FTP_USER` : nom d’utilisateur FTP bonus.
- `FTP_PASS` : mot de passe FTP bonus.

Identifiants générés pour l’application :

- **Administrateur WordPress :** `jmougel` / `MARIADB_ROOT_PASSWORD`
- **Auteur WordPress :** `MARIADB_USER` / `MARIADB_USER_PASSWORD`
- **Utilisateur MariaDB :** `MARIADB_USER` / `MARIADB_USER_PASSWORD`
- **Root MariaDB :** `root` / `MARIADB_ROOT_PASSWORD`
- **Utilisateur FTP bonus :** `FTP_USER` / `FTP_PASS`

Si les identifiants changent après l’initialisation de WordPress ou MariaDB, utilisez `make clean` ou `make re` pour supprimer les anciennes données persistantes et reconstruire avec les nouvelles valeurs.

## Vérifier l’état des services

Stack obligatoire :

```bash
sudo docker compose -f srcs/docker-compose.yml ps
```

Stack bonus :

```bash
sudo docker compose -f bonus/srcs/docker-compose.yml ps
```

Une stack en bonne santé doit afficher les conteneurs attendus en cours d’exécution :

- `nginx`
- `wordpress`
- `mariadb`
- Bonus : `redis`, `adminer`, `ftp`, `fail2ban`

## Vérifier les logs

Utilisez les logs pour comprendre les problèmes de démarrage ou d’accès :

```bash
sudo docker logs nginx
sudo docker logs wordpress
sudo docker logs mariadb
```

Logs bonus :

```bash
sudo docker logs redis
sudo docker logs adminer
sudo docker logs ftp
sudo docker logs fail2ban
```

## Vérifier l’accès web

Tester WordPress :

```bash
curl -kI https://jmougel.local
```

Tester l’administration WordPress :

```bash
curl -kI https://jmougel.local/wp-admin/
```

Tester Adminer bonus :

```bash
curl -kI https://jmougel.local/adminer/
```

Tester le site statique bonus :

```bash
curl -kI https://jmougel2.local
```

## Problèmes courants

Si le domaine ne charge pas :

- Vérifiez `/etc/hosts`.
- Vérifiez que Nginx est bien en cours d’exécution.
- Vérifiez que le port `443` n’est pas déjà utilisé par un autre service.

Si le navigateur affiche un avertissement de certificat :

- C’est normal pour un certificat local auto-signé.

Si Nginx retourne un gateway timeout :

- Vérifiez `sudo docker logs wordpress`.
- Vérifiez que le conteneur WordPress est bien en cours d’exécution.
- Vérifiez que PHP-FPM écoute sur le port interne `9000`.
- Vérifiez que MariaDB est en cours d’exécution et joignable.

Si WordPress ne parvient pas à se connecter à la base de données :

- Vérifiez `srcs/.env` ou `bonus/srcs/.env`.
- Vérifiez `MARIADB_HOST`, `MARIADB_NAME`, `MARIADB_USER` et `MARIADB_USER_PASSWORD`.
- Vérifiez `sudo docker logs mariadb`.

Si les anciens identifiants fonctionnent encore après modification du `.env` :

- Des données persistantes existent déjà.
- Exécutez `make re` pour supprimer et recréer les données du projet.

[Retour](../README.md)
