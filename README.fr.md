# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Introduction
Proxy inverse local. L'introduction est concise, intentionnellement.

## Installation
1. Téléchargez modifier et ccursor depuis https://github.com/[NAME]/cursor-rp/releases
2. Renommez-les aux noms standards et placez-les dans le même répertoire

## Configuration et utilisation

### 1. Patcher Cursor
1. Ouvrez Cursor, exécutez la commande `Open User Settings` et notez le chemin du fichier de configuration
2. Fermez Cursor, appliquez le patch (à réexécuter après chaque mise à jour) :
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
| `--debug` | | Mode débogage | - |

### Notes spécifiques aux plateformes
- **Windows** : Exécution directe
- **macOS** : Signature manuelle requise en raison du SIP (comme l'exécution directe si SIP est désactivé)
  - Script de référence : [macos.sh](macos.sh)
- **Linux** : Nécessite de gérer le format AppImage
  - Script de référence : [linux.sh](linux.sh)

Les contributions PR pour améliorer les scripts d'adaptation aux plateformes sont les bienvenues !

### 2. Configurer les Hosts
Si vous utilisez le paramètre `--skip-hosts`, ajoutez manuellement ces enregistrements hosts :
```
127.0.0.1 api2.cursor.sh.local api3.cursor.sh.local repo42.cursor.sh.local api4.cursor.sh.local us-asia.gcpp.cursor.sh.local us-eu.gcpp.cursor.sh.local us-only.gcpp.cursor.sh.local
```

### 3. Démarrer le service
```bash
/path/to/ccursor
```

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
| `tls` | Configuration du certificat TLS | object | ❌ | {cert_path="", key_path=""} | 0.3.0+ |
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

## Interfaces internes

### ConfigUpdate
**Fonction** : Déclencher le rechargement du service après la mise à jour du fichier de configuration

---

*Clause de non-responsabilité incluse dans l'EULA. Le projet peut cesser la maintenance à tout moment.*

Feel free!