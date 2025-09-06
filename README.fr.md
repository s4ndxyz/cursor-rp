# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Introduction
Proxy inverse local. L'introduction est concise, intentionnellement.

## Installation
1. Visitez https://github.com/[NAME]/cursor-rp/releases pour télécharger dbwriter, modifier et ccursor
2. Renommez-les aux noms standards et placez-les dans le même répertoire

## Configuration et utilisation

### 1. Gestion des comptes (dbwriter)
dbwriter est un outil de gestion de comptes pour changer rapidement les informations de compte Cursor. Il prend en charge l'application directe, la gestion d'un pool de comptes et d'autres modes.

#### Utilisation basique
```bash
# Application directe (sans sauvegarde)
dbwriter apply -a <TOKEN> -m pro -s google
dbwriter apply -a <ACCESS_TOKEN> -r <REFRESH_TOKEN> -e user@example.com -m pro_plus -s auth0

# Sauvegarder un compte dans le pool
dbwriter save -a <TOKEN> -e user@example.com -m pro -s google
dbwriter save -a <TOKEN> -e user@example.com -m free_trial -s github --apply  # Sauvegarder et appliquer immédiatement

# Changer de compte depuis le pool
dbwriter use -e user@example.com              # Sélection par email
dbwriter use -m pro                           # Sélectionner un compte Pro (le premier si plusieurs)
dbwriter use --interactive                    # Sélection interactive

# Consulter le pool de comptes
dbwriter list                                 # Lister tous les comptes
dbwriter list -m pro                          # Lister un type d'abonnement spécifique
dbwriter list --verbose                       # Afficher des informations détaillées (y compris un aperçu du jeton)

# Gérer le pool de comptes
dbwriter manage remove user@example.com       # Supprimer un compte
dbwriter manage disable user@example.com      # Désactiver un compte (suppression douce)
dbwriter manage stats                         # Afficher les statistiques
```

#### Description des paramètres de commande

**Paramètres globaux**
| Paramètre | Description | Par défaut |
|-----------|-------------|------------|
| `--pool-db` | Chemin de la base de données du pool de comptes | `./accounts.db` |

**Sous-commande : apply (application directe)**
| Paramètre | Abréviation | Description | Requis |
|-----------|-------------|-------------|--------|
| `--access-token` | `-a` | Jeton d'accès | ✅ |
| `--refresh-token` | `-r` | Jeton de rafraîchissement (par défaut identique à l'access) | ❌ |
| `--email` | `-e` | Email du compte | ❌ |
| `--membership` | `-m` | Type d'abonnement | ✅ |
| `--signup-type` | `-s` | Méthode d'inscription | ✅ |

**Sous-commande : save (sauvegarde dans le pool de comptes)**
| Paramètre | Abréviation | Description | Requis |
|-----------|-------------|-------------|--------|
| `--access-token` | `-a` | Jeton d'accès | ✅ |
| `--refresh-token` | `-r` | Jeton de rafraîchissement | ❌ |
| `--email` | `-e` | Email du compte (recommandé) | ❌ |
| `--membership` | `-m` | Type d'abonnement | ✅ |
| `--signup-type` | `-s` | Méthode d'inscription | ✅ |
| `--apply` |  | Appliquer immédiatement après la sauvegarde | ❌ |

**Sous-commande : use (utilisation depuis le pool de comptes)**
| Paramètre | Abréviation | Description | Mutuellement exclusif |
|-----------|-------------|-------------|----------------------|
| `--email` | `-e` | Sélection par email | Avec `-m` |
| `--membership` | `-m` | Sélection par type d'abonnement | Avec `-e` |
| `--interactive` | `-i` | Sélection interactive | ❌ |

**Types de valeurs supportés**
- **Types d'abonnement** : `free`, `pro`, `pro_plus`, `enterprise`, `free_trial`, `ultra`
- **Méthodes d'inscription** : `unknown`, `auth0`, `google`, `github`

#### Scénarios d'utilisation
1. **Changement temporaire** : Utilisez la commande `apply` pour appliquer directement un compte sans le sauvegarder localement
2. **Collection de comptes** : Utilisez la commande `save` pour créer un pool de comptes facilitant la gestion de plusieurs comptes
3. **Changement rapide** : Utilisez la commande `use` pour basculer rapidement entre les comptes sauvegardés
4. **Gestion par lots** : Gérez toutes les informations de compte via le pool de comptes

#### Remarques
- Le jeton supporte deux modes : jetons d'accès/rafraîchissement identiques, ou jetons différents
- La base de données du pool de comptes est sauvegardée par défaut dans `./accounts.db`, peut être spécifiée via `--pool-db`
- Il est recommandé de définir un email pour chaque compte pour faciliter l'identification et la gestion
- Lors de l'utilisation de `--verbose` pour voir des informations détaillées, seuls les 20 premiers caractères des jetons sont affichés

### 2. Patcher Cursor (modifier)
Fermez Cursor, appliquez le patch (à réexécuter après chaque mise à jour) :
```bash
# Utilisation basique (détection automatique du chemin Cursor)
/path/to/modifier --port 3000 --suffix .local

# Spécifier le chemin Cursor
/path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local

# Configuration HTTPS
/path/to/modifier --scheme https --port 443 --suffix .example.com

# Ignorer la détection des hosts (gestion manuelle des hosts)
/path/to/modifier --port 3000 --suffix .local --skip-hosts

# Sauvegarder la commande pour réutilisation
/path/to/modifier --port 3000 --suffix .local --save-command modifier.cmd

# Exemple complet
/path/to/modifier -C /path/to/cursor --scheme https -p 3000 --suffix .local --skip-hosts -s modifier.cmd --confirm --pass-token
```

### Paramètres de commande
| Paramètre | Abréviation | Description | Exemple |
|-----------|-------------|-------------|---------|
| `--cursor-path` | `-C` | Chemin d'installation de Cursor (optionnel, auto-détection) | `/Applications/Cursor.app` |
| `--scheme` | | Type de protocole (http/https) | `https` |
| `--port` | `-p` | Port de service | `3000` |
| `--suffix` | | Suffixe de domaine | `.local` |
| `--skip-hosts` | | Ignorer la modification du fichier hosts | - |
| `--save-command` | `-s` | Sauvegarder la commande dans un fichier | `modifier.cmd` |
| `--confirm` | | Confirmer les modifications (ne pas restaurer si état identique) | - |
| `--pass-token` | | Passer la validation du jeton (recommandé) | - |
| `--debug` | | Mode débogage | - |

### Notes spécifiques aux plateformes
- **Windows** : Exécution directe
- **macOS** : Signature manuelle requise en raison du SIP (comme l'exécution directe si SIP est désactivé)
  - Script de référence : [macos.sh](macos.sh)
- **Linux** : Nécessite de gérer le format AppImage
  - Script de référence : [linux.sh](linux.sh)

Les contributions PR pour améliorer les scripts d'adaptation aux plateformes sont les bienvenues !

### 3. Configurer les Hosts
Si vous utilisez le paramètre `--skip-hosts`, ajoutez manuellement ces enregistrements hosts :
```
127.0.0.1 api2.cursor.sh.local api3.cursor.sh.local repo42.cursor.sh.local api4.cursor.sh.local us-asia.gcpp.cursor.sh.local us-eu.gcpp.cursor.sh.local us-only.gcpp.cursor.sh.local
```

### 4. Démarrer le service
```bash
/path/to/ccursor
```

Pour les développeurs d'extensions ou de plugins d'IDE, ajoutez le paramètre `--debug` après le démarrage de ccursor pour voir les journaux détaillés.

## Détails de configuration
Dans `config.toml`, commentez ou supprimez les paramètres inconnus, **NE les laissez PAS vides**.

### Configuration de base
| Élément | Description | Type | Requis | Par défaut | Version supportée |
|---------|-------------|------|---------|------------|------------------|
| `check-updates` | Vérifier les mises à jour au démarrage | bool | ❌ | false | 0.2.0+ |
| `github-token` | Jeton d'accès GitHub | string | ❌ | "" | 0.2.0+ |
| ~~`usage-statistics`~~ | ~~Statistiques d'utilisation du modèle~~ | ~~bool~~ | ❌ | true | 0.2.1-0.2.x, déprécié, implémentation future dans la base de données |

### Configuration du service (`service-config`)
| Élément | Description | Type | Requis | Par défaut | Version supportée |
|---------|-------------|------|---------|------------|------------------|
| `tls` | Configuration du certificat TLS | object | ✅ | {cert_path="", key_path=""} | 0.3.0+ |
| `ip-addr` | Adresse IP d'écoute du service | object | ✅ | {ipv4="", ipv6=""} | 0.3.1+ |
| `port` | Port d'écoute du service | u16 | ✅ | - | Toutes versions |
| `dns-resolver` | Résolveur DNS (gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `lock-updates` | Verrouiller les mises à jour | bool | ✅ | false | Toutes versions |
| `fake-email` | Configuration d'e-mail fictif | object | ❌ | {email="", sign-up-type="unknown", enable=false} | 0.2.0+ |
| `service-addr` | Configuration d'adresse de service | object | ❌ | {scheme="http", suffix="", port=0} | 0.2.0+ |
| ~~`proxy`~~ | ~~Configuration du serveur proxy~~ | ~~string~~ | ❌ | - | 0.2.0-0.2.x, déprécié, migré vers `proxies._` |

### Configuration du pool de proxys (`proxies`) - Nouveau en 0.3.0
| Élément | Description | Type | Requis | Par défaut |
|---------|-------------|------|---------|------------|
| `nom_clé` | Identifiant de configuration, correspond à `overrides.nom_clé` | string | ❌ | - |
| `_` | Configuration proxy par défaut | string | ❌ | "" |

### Configuration de mappage (`override-mapping`) - Nouveau en 0.3.0
| Élément | Description | Type | Requis | Par défaut |
|---------|-------------|------|---------|------------|
| `Préfixe du jeton Bearer` | Correspondance avec le nom de configuration | string | ❌ | - |
| `_` | Mappage par défaut | string | ❌ | - |

### Configuration des substitutions (`overrides.nom_config`)
| Élément | Description | Type | Requis | Par défaut | Version supportée |
|---------|-------------|------|---------|------------|------------------|
| `token` | Jeton d'authentification JWT | string | ❌ | - | Toutes versions |
| `traceparent` | Préserver l'identifiant de trace | bool | ❌ | false | 0.2.0+ |
| `client-key` | Hash de la clé client | string | ❌ | - | 0.2.0+ |
| `checksum` | Somme de contrôle combinée | object | ❌ | - | 0.2.0+ |
| `client-version` | Numéro de version client | string | ❌ | - | 0.2.0+ |
| `config-version` | Version de configuration (UUID) | string | ❌ | - | 0.3.0+ |
| `timezone` | Identifiant de fuseau horaire IANA | string | ❌ | - | Toutes versions |
| `privacy-mode` | Paramètres du mode de confidentialité | bool | ❌ | true | 0.3.0+ |
| `session-id` | Identifiant unique de session (UUID) | string | ❌ | - | 0.2.0+ |

### Notes de migration de version
#### 0.2.x → 0.3.0
- **Changements majeurs** :
  - Suppression de `current-override`, remplacé par le mappage dynamique des jetons Bearer
  - Migration de `service-config.proxy` vers `proxies._`
  - Ajout des nouvelles sections de configuration `proxies` et `override-mapping`
  - `ghost-mode` renommé en `privacy-mode`, avec des fonctionnalités améliorées
  - Ajout du nouveau champ `config-version`
  - Ajout de la configuration `tls` pour le support HTTPS

- **Relations de configuration** :
  1. Le client envoie un jeton Bearer (par exemple, `sk-test123`)
  2. `override-mapping` recherche le nom de configuration (par exemple, `sk-test` → `example`)
  3. Utilise les paramètres de proxy de `proxies.example`
  4. Utilise les configurations de substitution de `overrides.example`

**Notes spéciales** :
- Une chaîne vide `""` signifie pas de proxy
- La clé `_` est utilisée comme configuration par défaut/de repli
- Il est recommandé de commenter les éléments de configuration optionnels pour éviter les problèmes potentiels
- Le fichier de configuration sera toujours mis à jour lors de la fermeture de ccursor. Si vous devez modifier le fichier de configuration, choisissez GET /internal/ConfigUpdate ou fermez puis mettez à jour

## Interfaces internes

### ConfigUpdate
**Fonction** : Déclencher le rechargement du service après la mise à jour du fichier de configuration
**Limitation** : Ne peut pas être déclenché via l'accès par domaine, nécessite un accès externe avec un proxy inverse personnalisé

---

*Clause de non-responsabilité incluse dans l'EULA. Le projet peut cesser la maintenance à tout moment.*

Feel free!