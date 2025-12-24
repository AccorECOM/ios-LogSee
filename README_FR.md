# LogSee

*[Read in English](README.md)*

Un framework de logging léger et basé sur des canaux pour Swift, avec une interface de debug SwiftUI intégrée.

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%20|%20macOS%2013%20|%20tvOS%2016-blue.svg)
![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)

<p align="center">
  <img src="Media/demo.gif" alt="LogSee Demo" width="280"/>
</p>

## Fonctionnalités

- **Logging par canaux** - Organisez vos logs par catégorie (Network, Auth, Database, etc.)
- **Streaming temps réel** - Abonnez-vous aux logs via `AsyncStream`
- **Interface de debug SwiftUI** - UI intégrée pour parcourir et filtrer les logs
- **Notifications de logs** - Overlay flottant affichant les logs en direct
- **Canaux personnalisés** - Définissez vos propres catégories avec des emojis
- **Zéro overhead en production** - Tout le logging est supprimé en Release
- **Swift 6 ready** - Support complet de la concurrency avec types `Sendable`

## Installation

### Swift Package Manager

Ajoutez LogSee à votre `Package.swift` :

```swift
dependencies: [
    .package(url: "https://github.com/AccorECOM/ios-LogSee.git", from: "1.0.0")
]
```

Puis ajoutez les produits nécessaires à votre target :

```swift
.target(
    name: "VotreApp",
    dependencies: [
        "Logger",  // Fonctionnalités de logging
        "LogSee"   // Interface de debug SwiftUI (optionnel)
    ]
)
```

Ou dans Xcode : **File > Add Package Dependencies...** et entrez l'URL du repository.

## Démarrage rapide

### Logging basique

```swift
import Logger

let logger = Logger.shared

// Utiliser les canaux par défaut
logger.log("Requête démarrée", channel: .network)
logger.log("Utilisateur connecté", channel: .auth)
logger.log("Requête SQL exécutée", channel: .database, level: .info)
logger.log("Une erreur s'est produite", channel: .error, level: .error)

// Logger avec contexte additionnel
logger.log(
    "Appel API terminé",
    channel: .network,
    level: .info,
    env: [
        "url": "https://api.example.com/users",
        "statusCode": 200,
        "duration": 0.35
    ]
)
```

### Canaux par défaut

| Canal | Emoji | Usage |
|-------|-------|-------|
| `.network` | `🌐` | Appels API, requêtes, réponses |
| `.database` | `🗄️` | Opérations base de données |
| `.auth` | `🔐` | Événements d'authentification |
| `.error` | `❌` | Erreurs et échecs |
| `.debug` | `🐛` | Informations de debug |
| `.info` | `ℹ️` | Informations générales |

### Canaux personnalisés

```swift
extension LogChannel {
    static let analytics = LogChannel(id: "analytics", title: "Analytics", emoji: "📊")
    static let payment = LogChannel(id: "payment", title: "Paiement", emoji: "💳")
}

// Configurer au démarrage de l'app
await Logger.configure(channels: LogChannel.defaultChannels + [.analytics, .payment])

// Utiliser vos canaux personnalisés
Logger.shared.log("Achat effectué", channel: .payment, level: .info)
```

## Interface de debug

LogSee fournit deux composants UI pour le debug :

| Composant | Description |
|-----------|-------------|
| `LogSeeModuleFactory.makeAnalyticsView()` | Visualiseur de logs plein écran avec filtrage |
| `LogSeeModuleFactory.initLogNotificationModule()` | Overlay flottant affichant les logs en direct |

Consultez l'**App Démo** pour un exemple complet d'intégration avec geste shake-to-open.

## Architecture

LogSee est divisé en deux modules :

- **Logger** - Fonctionnalités de logging sans dépendance UI
- **LogSee** - Interface de debug SwiftUI qui dépend de Logger

Cela vous permet d'utiliser uniquement le module Logger dans des packages ou frameworks qui n'ont pas besoin de l'UI.

## Prérequis

- iOS 16.0+ / macOS 13.0+ / tvOS 16.0+
- Swift 6.0+
- Xcode 16.0+

## App Démo

Le dossier `LogSeeDemo` contient une application exemple complète démontrant :
- Configuration des canaux
- Overlay de notifications de logs
- Geste shake pour ouvrir le visualiseur de debug
- Définition de canaux personnalisés

## Licence

LogSee est disponible sous licence Apache 2.0. Voir le fichier [LICENSE](LICENSE) pour plus de détails.
