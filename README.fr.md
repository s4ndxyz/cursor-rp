# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Introduction
Proxy inverse local. L'introduction est concise, intentionnellement.

## Installation
Téléchargez modifier et ccursor depuis https://github.com/wisdgod/cursor-rp/releases, renommez-les aux noms standards et placez-les dans le même répertoire.

## Configuration et utilisation
En prenant 2999 et .local comme exemples:

1. Ouvrez Cursor, utilisez la commande >Open User Settings dans Cursor et copiez le chemin.
2. Fermez Cursor, appliquez le patch (exécutez une fois après chaque mise à jour, exécutez à nouveau pour restaurer) :
   ```
   modifier --cursor-path /path/to/cursor --port 2999 --suffix .local local
   ```

3. Il pourrait modifier incorrectement le fichier hosts, vous devrez donc peut-être le mettre à jour manuellement en ajoutant ce qui suit :
   ```
   127.0.0.1 api2.cursor.sh.local
   127.0.0.1 api3.cursor.sh.local
   127.0.0.1 repo42.cursor.sh.local
   127.0.0.1 api4.cursor.sh.local
   127.0.0.1 us-asia.gcpp.cursor.sh.local
   127.0.0.1 us-eu.gcpp.cursor.sh.local
   127.0.0.1 us-only.gcpp.cursor.sh.local
   ```

4. Exécuter le service :
   ```
   ccursor /path/to/settings.json
   ```

## Configurations importantes
Ajoutez les éléments suivants dans settings.json :
- `ccursor.port` : Ceci nécessite un entier non signé de 16 bits
- `ccursor.lockUpdates` : Si les mises à jour doivent être verrouillées
- `ccursor.domainSuffix` : Le .local mentionné ci-dessus
- `ccursor.timezone` : L'identifiant de fuseau horaire de l'emplacement de votre IP (norme IANA)

## Mécanisme de mise à jour
Lorsqu'il y a des changements, utilisez des requêtes HTTP GET vers les chemins suivants :
- `/internal/TokenUpdate`
- `/internal/ChecksumUpdate`
- `/internal/ConfigUpdate`

---

Supprimez le dépôt et partez à tout moment. Avis de non-responsabilité joint dans l'eula. Les mises à jour ne seront pas fréquentes.

Feel free!