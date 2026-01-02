# Offline-First Architecture Guide

Bu döküman, uygulamanın **offline-first mimarisini** ve **herhangi bir modüle** yeni özellik eklerken izlenmesi gereken adımları açıklar.

## İçindekiler

1. [Mimari Genel Bakış](#mimari-genel-bakış)
2. [Temel Prensipler](#temel-prensipler)
3. [Veri Akışı](#veri-akışı)
4. [Jenerik Dosya Yapısı](#jenerik-dosya-yapısı)
5. [Yeni Modül Ekleme Rehberi](#yeni-modül-ekleme-rehberi)
6. [Mevcut Modüle Entity Ekleme](#mevcut-modüle-entity-ekleme)
7. [Kritik Kurallar](#kritik-kurallar)
8. [Login/Logout Yönetimi](#loginlogout-yönetimi)

---

## Mimari Genel Bakış

```text
┌─────────────────────────────────────────────────────────────────┐
│                        UI LAYER                                 │
│                Screens, Widgets, Modals                         │
│                            │                                    │
│                            ▼                                    │
│              ┌─────────────────────────────┐                    │
│              │   StateNotifier (Riverpod)  │                    │
│              │   [Feature]Notifier         │                    │
│              └─────────────┬───────────────┘                    │
│                            │                                    │
├────────────────────────────┼────────────────────────────────────┤
│                        DATA LAYER                               │
│                            ▼                                    │
│              ┌─────────────────────────────┐                    │
│              │   [Feature]RepositoryImpl   │                    │
│              │   (Offline-First Logic)     │                    │
│              └─────┬─────────────────┬─────┘                    │
│                    │                 │                          │
│          ┌─────────▼─────┐     ┌─────▼─────────┐                │
│          │LocalDatasource│     │   Firestore   │                │
│          │    (Hive)     │     │   (Remote)    │                │
│          └───────────────┘     └───────────────┘                │
└─────────────────────────────────────────────────────────────────┘
```

---

## Temel Prensipler

| Prensip | Açıklama |
|---------|----------|
| **Cache-First Read** | Okuma işlemleri her zaman yerel cache'den yapılır |
| **Dual-Write** | Yazma işlemleri hem cache hem remote'a yapılır |
| **Login-Triggered Sync** | Backend verisi sadece login sırasında çekilir |
| **Optimistic UI** | UI state yazma öncesinde güncellenir (anında tepki) |

---

## Veri Akışı

### Okuma (READ)

```text
App Başlangıcı → Notifier._load() → LocalDatasource.getCached() → UI
                                       (Backend'e GİTMEZ)
```

### Yazma (CREATE/UPDATE/DELETE)

```text
User Action → Notifier.add()
                ├── 1. UI State güncelle (Optimistic)
                ├── 2. LocalDatasource.cache() 
                └── 3. Remote.write()
```

### Login Sync

```text
Login Success → AuthController._syncData()
                  ├── Repository.forceRefresh() (her modül için)
                  └── Notifier.refresh() (her modül için)
```

---

## Jenerik Dosya Yapısı

Her feature modülü şu yapıyı takip eder:

```text
lib/features/[feature_name]/
├── data/
│   ├── adapters/                        # Hive TypeAdapter'ları
│   │   └── [entity]_adapter.dart
│   ├── datasources/
│   │   └── [feature]_local_datasource.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── [entity].dart
│   └── repositories/
│       └── [feature]_repository.dart    # Abstract interface
│
└── presentation/
    ├── providers/
    │   └── [feature]_providers.dart     # StateNotifier'lar
    ├── screens/
    │   └── [feature]_screen.dart
    └── widgets/
        └── [widget].dart
```

---

## Yeni Modül Ekleme Rehberi

> **Örnek:** `notes` modülü eklemek istiyorsun.

### Adım 1: Klasör Yapısını Oluştur

```text
lib/features/notes/
├── data/
│   ├── adapters/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

### Adım 2: Entity Oluştur

```dart
// lib/features/notes/domain/entities/note.dart
class Note extends Equatable {
  final String id;
  final String content;
  final DateTime createdAt;
  // ...
}
```

### Adım 3: Hive Adapter Yaz

```dart
// lib/features/notes/data/adapters/note_adapter.dart
class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = X;  // Benzersiz ID (global_type_ids.dart'tan al)
  // ...
}
```

### Adım 4: Local Datasource Oluştur

```dart
// lib/features/notes/data/datasources/notes_local_datasource.dart
class NotesLocalDatasource {
  static const String boxName = 'notes_cache';
  Box<Note>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<Note>(boxName);
  }

  List<Note> getCached() => _box?.values.toList() ?? [];
  Future<void> cache(Note note) async => await _box?.put(note.id, note);
  Future<void> delete(String id) async => await _box?.delete(id);
  Future<void> clear() async => await _box?.clear();
}
```

### Adım 5: Repository Oluştur

```dart
// lib/features/notes/data/repositories/notes_repository_impl.dart
class NotesRepositoryImpl {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final NotesLocalDatasource _local;

  // Cache okuma
  List<Note> getCached() => _local.getCached();

  // Backend'den çekip cache'e yazma
  Future<Either<Failure, List<Note>>> fetchAndCache() async {
    // 1. Firestore'dan çek
    // 2. _local.cacheAll(notes)
    // 3. return Right(notes)
  }

  // Yazma (Dual-Write)
  Future<Either<Failure, Unit>> add(Note note) async {
    await _local.cache(note);            // 1. Cache
    await _firestore...set({...});       // 2. Remote
    return const Right(unit);
  }
}
```

### Adım 6: StateNotifier Oluştur

```dart
// lib/features/notes/presentation/providers/notes_providers.dart
class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NotesRepositoryImpl _repository;

  NotesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = AsyncValue.data(_repository.getCached());
  }

  Future<void> refresh() async {
    final result = await _repository.fetchAndCache();
    result.fold(
      (f) => state = AsyncValue.error(f, StackTrace.current),
      (notes) => state = AsyncValue.data(notes),
    );
  }

  Future<void> add(Note note) async {
    state.whenData((notes) => state = AsyncValue.data([...notes, note]));
    await _repository.add(note);
  }
}
```

### Adım 7: main.dart'a Ekle

```dart
// main.dart
import 'features/notes/data/adapters/note_adapter.dart';
import 'features/notes/data/datasources/notes_local_datasource.dart';

final notesLocalDatasource = NotesLocalDatasource();

void main() async {
  Hive.registerAdapter(NoteAdapter());
  await notesLocalDatasource.init();
}
```

### Adım 8: AuthController'a Ekle

```dart
// auth_controller.dart
Future<void> _syncAllData() async {
  // Calendar
  await calendarRepository.forceRefresh();
  ref.read(eventsNotifierProvider.notifier).refresh();
  
  // Notes (YENİ)
  await notesRepository.forceRefresh();
  ref.read(notesNotifierProvider.notifier).refresh();
}
```

---

## Mevcut Modüle Entity Ekleme

Mevcut bir modüle (örn. calendar) yeni entity (örn. Task) eklemek için:

1. `domain/entities/` → Entity oluştur
2. `data/adapters/` → Adapter yaz (typeId benzersiz!)
3. `data/datasources/` → Box ve metodları ekle
4. `data/repositories/` → CRUD metodları ekle
5. `presentation/providers/` → Notifier ekle
6. `main.dart` → Adapter register et
7. `auth_controller.dart` → Sync'e ekle

---

## Kritik Kurallar

### TypeId Yönetimi

Merkezi bir dosyada typeId'leri takip et:

```dart
// lib/core/constants/hive_type_ids.dart
class HiveTypeIds {
  static const int event = 0;
  static const int program = 1;
  static const int note = 2;
  static const int task = 3;
  // Yeni entity eklerken buraya ekle
}
```

### Hive Adapter'da Double-Read Yapma

```dart
// ❌ YANLIŞ
title: reader.readString().isEmpty ? null : reader.readString()

// ✅ DOĞRU
final titleRaw = reader.readString();
title: titleRaw.isEmpty ? null : titleRaw
```

### Optimistic Update Sırası

```dart
Future<void> add(Entity entity) async {
  // 1. UI State (anında)
  state.whenData((list) => state = AsyncValue.data([...list, entity]));
  
  // 2. Cache
  await _localDatasource.cache(entity);
  
  // 3. Remote
  await _firestore.doc(entity.id).set({...});
}
```

---

## Login/Logout Yönetimi

### Login - Tüm Modülleri Sync Et

```dart
Future<void> _syncAllData() async {
  // Her modül için:
  await [module]Repository.forceRefresh();
  ref.read([module]NotifierProvider.notifier).refresh();
}
```

### Logout - Tüm Cache'leri Temizle

```dart
Future<void> signOut() async {
  await calendarLocalDatasource.clear();
  await notesLocalDatasource.clear();
  // ... diğer modüller
  
  await _authRepository.signOut();
}
```

---

## Checklist: Yeni Modül Eklerken

- [ ] Klasör yapısı oluşturuldu
- [ ] Entity tanımlandı (`Equatable` extends)
- [ ] Hive Adapter yazıldı (typeId benzersiz)
- [ ] LocalDatasource oluşturuldu (init, cache, get, delete, clear)
- [ ] Repository oluşturuldu (getCached, fetchAndCache, add, delete)
- [ ] StateNotifier oluşturuldu (_load, refresh, add, delete)
- [ ] Provider tanımlandı
- [ ] main.dart'ta adapter register edildi
- [ ] main.dart'ta datasource init edildi
- [ ] AuthController'da sync eklendi
- [ ] AuthController'da logout temizleme eklendi

---

*Son güncelleme: 2026-01-02*
