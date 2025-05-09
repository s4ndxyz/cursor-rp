# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Introduction
Proxy inverse local. L'introduction est concise, intentionnellement.

## Installation
1. Téléchargez modifier et ccursor depuis https://github.com/wisdgod/cursor-rp/releases
2. Renommez-les aux noms standards et placez-les dans le même répertoire

## Configuration et utilisation
En prenant le port 3000 et .local comme exemples :

### 1. Patcher Cursor
1. Ouvrez Cursor, exécutez la commande `Open User Settings` et notez le chemin du fichier de configuration
2. Fermez Cursor, appliquez le patch (à réexécuter après chaque mise à jour) :
   ```bash
   /path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local local
   ```

**Notes spéciales** :
- Utilisateurs Windows : Aucune attention particulière nécessaire
- Utilisateurs macOS : Signature manuelle requise en raison du SIP (identique à Windows si SIP est désactivé)
- Utilisateurs Linux : Nécessite de gérer le format AppImage
- Scripts de référence : [macos.sh](macos.sh) | [linux.sh](linux.sh) (PR bienvenus)

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

Lors de la migration depuis la version 0.1.x, générez un modèle de configuration en utilisant :
```bash
/path/to/ccursor /path/to/settings.json
```

### Configuration de base
| Élément | Description | Type | Requis | Par défaut | Version supportée |
|---------|-------------|------|---------|------------|------------------|
| `check-updates` | Vérifier les mises à jour au démarrage | bool | ❌ | false | 0.2.0+ |
| `github-token` | Jeton d'accès GitHub | string | ❌ | "" | 0.2.0+ |
| `usage-statistics` | Statistiques d'utilisation du modèle | bool | ❌ | true | 0.2.1+ |
| `current-override` | Identifiant de substitution actif | string | ✅ | - | 0.2.0+ |

### Configuration du service (`service-config`)
| Élément | Description | Type | Requis | Par défaut | Version supportée |
|---------|-------------|------|---------|------------|------------------|
| `port` | Port d'écoute du service | u16 | ✅ | - | Toutes versions |
| `lock-updates` | Verrouiller les mises à jour | bool | ✅ | false | Toutes versions |
| `domain-suffix` | Suffixe de domaine | string | ✅ | - | Toutes versions |
| `proxy` | Configuration du serveur proxy | string | ❌ | "" | 0.2.0+ |
| `dns-resolver` | Résolveur DNS (gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `fake-email` | Configuration d'e-mail fictif | object | ❌ | {email="",sign-up-type="unknown",enable=false} | 0.2.0+ |
| `service-addr` | Configuration d'adresse de service | object | ❌ | {mode="local",suffix=".example.com",port=8080} | 0.2.0+ |

### Configuration des substitutions (`overrides`)
| Élément | Description | Type | Requis | Par défaut | Version supportée |
|---------|-------------|------|---------|------------|------------------|
| `token` | Jeton d'authentification JWT | string | ❌ | - | Toutes versions |
| `traceparent` | Préserver l'identifiant de trace | bool | ❌ | false | 0.2.0+ |
| `client-key` | Hash de la clé client | string | ❌ | - | 0.2.0+ |
| `checksum` | Somme de contrôle combinée | string | ❌ | - | 0.2.0+ |
| `client-version` | Numéro de version client | string | ❌ | - | 0.2.0+ |
| `timezone` | Identifiant de fuseau horaire IANA | string | ❌ | - | Toutes versions |
| `ghost-mode` | Paramètres du mode privé | bool | ❌ | true | 0.2.0+ |
| `session-id` | Identifiant unique de session | string | ❌ | - | 0.2.0+ |

**Notes spéciales** :
- Les éléments marqués "0.2.0+" n'étaient pas présents dans 0.1.x, mais les éléments marqués "Toutes versions" peuvent ne pas être complètement équivalents
- Les éléments de configuration avec des valeurs par défaut peuvent être commentés ou supprimés pour éviter des problèmes potentiels

## Interfaces internes
Les interfaces sous `/internal/` sont contrôlées par les fichiers du répertoire internal (renvoie index.html lorsque le fichier n'existe pas), à l'exception des interfaces spécifiques suivantes :

### 1. TokenUpdate
**Fonction** : Mise à jour du paramètre current-override pendant l'exécution
**Paramètres** :
| Paramètre | Requis | Description |
|-----------|--------|-------------|
| key | ✅ | Identifiant de configuration de substitution |

**Exemple** :
```bash
curl http://127.0.0.1:3000/internal/TokenUpdate?key=${KEY_NAME}
```

### 2. TokenAdd
**Fonction** : Obtenir l'URL d'autorisation et le temps d'attente
**Retourne** : `["url",100]`, où url est le lien d'autorisation et 100 est le temps d'attente en secondes

**Paramètres** :
| Paramètre | Requis | Description |
|-----------|--------|-------------|
| timezone | ✅ | Identifiant de fuseau horaire IANA (par exemple, "Asia/Shanghai" ou "America/Los_Angeles") |
| wait | ❌ | Temps d'attente en secondes, par défaut 100 |
| client_version | ❌ | Numéro de version client, par défaut 0.49.6 |

**Exemple** :
```bash
# Utilisation de base
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai

# Temps d'attente personnalisé
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai&wait=50
```

### 3. ConfigUpdate
**Fonction** : Déclencher le rechargement du service après la mise à jour du fichier de configuration

### 4. GetUsage
**Fonction** : Obtenir les statistiques d'utilisation du modèle

---

*Clause de non-responsabilité incluse dans l'EULA. Le projet peut cesser la maintenance à tout moment.*

Feel free!