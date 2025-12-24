# Tests LogSee / LogSee Tests

## 🇫🇷 Version Française

### Vue d'ensemble
Les tests de LogSee sont conçus pour valider le **comportement métier** et non l'implémentation technique. Cette approche garantit que les tests restent valides même lors de changements d'architecture.

### Philosophie des tests
- **Tests métier uniquement** : Nous testons ce que fait le code, pas comment il le fait
- **Isolation complète** : Chaque test utilise ses propres instances pour éviter la contamination d'état
- **Noms explicites** : Les noms des tests décrivent clairement leur utilité business

### Structure des tests

#### 1. LoggerBusinessLogicTests
Test le comportement métier du système de logging :
- Enregistrer et récupérer des logs par channel
- Séparer les logs entre différents channels
- Nettoyer sélectivement les logs
- Préserver les métadonnées

#### 2. LoggerStorageBusinessLogicTests  
Test la persistance et la gestion des logs :
- Ordre chronologique (plus récent en premier)
- Historique indépendant par channel
- Vue globale de tous les logs
- Découverte des channels actifs

#### 3. LogsViewBusinessLogicTests
Test l'affichage et la gestion visuelle des logs :
- Visualisation de tous les channels
- Nettoyage de l'historique
- Affichage complet des informations de debug

#### 4. LiveStreamBusinessLogicTests
Test le streaming en temps réel des logs :
- Activation/désactivation du streaming
- Sélection des channels à streamer
- Persistance des préférences

### Bonnes pratiques

#### Isolation des tests
```swift
// ✅ BON - Instance isolée
let logger = Logger(logger: LoggerRepository())

// ❌ MAUVAIS - Singleton partagé
let logger = Logger.shared
```

#### Gestion de l'asynchrone
```swift
// Toujours attendre après un log
logger.log("Message", channel: .debug)
try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
let logs = await logger.get(for: .debug)
```

### Exécution des tests

```bash
# Tous les tests
swift test

# Tests spécifiques
swift test --filter LoggerBusinessLogicTests
swift test --filter LoggerStorageBusinessLogicTests
```

### Notes Techniques

#### Limitations connues
- Les tests LiveStream peuvent avoir des problèmes d'isolation UserDefaults en parallèle

#### Améliorations futures
- Mocker UserDefaults pour une isolation complète
- Ajouter des tests de performance pour de gros volumes

---

## 🇬🇧 English Version

### Overview
LogSee tests are designed to validate **business behavior** rather than technical implementation. This approach ensures tests remain valid even when architecture changes.

### Testing Philosophy
- **Business tests only**: We test what the code does, not how it does it
- **Complete isolation**: Each test uses its own instances to avoid state contamination
- **Explicit names**: Test names clearly describe their business utility

### Test Structure

#### 1. LoggerBusinessLogicTests
Tests logging system business behavior:
- Log and retrieve messages by channel
- Separate logs between different channels
- Selectively clear logs
- Preserve metadata

#### 2. LoggerStorageBusinessLogicTests
Tests log persistence and management:
- Chronological order (newest first)
- Independent history per channel
- Complete view of all logs
- Active channel discovery

#### 3. LogsViewBusinessLogicTests
Tests log display and visual management:
- View all available channels
- Clear history
- Display complete debug information

#### 4. LiveStreamBusinessLogicTests
Tests real-time log streaming:
- Enable/disable streaming
- Select channels to stream
- Persist preferences

### Best Practices

#### Test Isolation
```swift
// ✅ GOOD - Isolated instance
let logger = Logger(logger: LoggerRepository())

// ❌ BAD - Shared singleton
let logger = Logger.shared
```

#### Async Handling
```swift
// Always wait after logging
logger.log("Message", channel: .debug)
try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
let logs = await logger.get(for: .debug)
```

### Running Tests

```bash
# All tests
swift test

# Specific tests
swift test --filter LoggerBusinessLogicTests
swift test --filter LoggerStorageBusinessLogicTests
```

### Technical Notes

#### Known Limitations
- LiveStream tests may have UserDefaults isolation issues when run in parallel

#### Future Improvements
- Mock UserDefaults for complete test isolation
- Add performance tests for large log volumes
