# 📅 Lapse: Program & Takvim Modülü Geliştirme Rehberi

Bu doküman, **Lapse** projesine eklenecek olan "Programlar ve Etkinlik Takvimi" modülünün mimari yapısını, veritabanı şemasını ve geliştirme adımlarını içerir.

Bu rehber, projedeki `SYSTEM_GUIDE.md` (Mimari) ve `THEME_GUIDE.md` (Tasarım Sistemi) dosyalarıyla tam uyumlu hazırlanmıştır.

---

## 🏗️ Bölüm 1: Mimari Tasarım

### 1. Veritabanı Şeması (Firestore)

Veriler `users/{uid}/` koleksiyonu altında saklanarak güvenlik kuralları basitleştirilir ve sorgu performansı artırılır.

**Koleksiyon: `programs`**
Kullanıcının oluşturduğu kategoriler (Ders programı, Spor, İş vb.).

```json
{
  "id": "string (uuid)",
  "title": "string",
  "color": "string (Hex Code: #079F00)",
  "description": "string (nullable)",
  "createdAt": "timestamp"
}
```

**Koleksiyon: `events`**
Takvimdeki etkinlikler.

```json
{
  "id": "string (uuid)",
  "programId": "string (nullable - Eğer null ise genel etkinlik)",
  "title": "string",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "isRecurring": "boolean (Her yıl tekrar durumu)",
  "status": "string (pending/completed)"
}
```

### 2. Klasör Yapısı

Mevcut `features` yapısına aşağıdaki modüller eklenecektir:

- `lib/features/programs/` (Program Yönetimi)
- `lib/features/calendar/` (Takvim Görünümü ve Etkinlik Mantığı)

---

## 🤖 Bölüm 2: Geliştirme Promptları (7 Adım)

Aşağıdaki promptları sırasıyla AI asistanına vererek geliştirmeyi yönetin. Her adım tamamlandığında kodu SYSTEM_GUIDE kurallarına göre kontrol edip bir sonraki adıma geçin.

### 🟢 Adım 1: Domain Katmanı

**Prompt:**
> "Projeye 'Calendar & Programs' modülünü ekliyoruz. İlk olarak Domain katmanını kurmanı istiyorum. `lib/features/calendar/domain/` altında şu yapıyı oluştur:
>
> 1. **Entities**: `Program` (id, title, color, description) ve `Event` (id, title, startDate, endDate, isRecurring, programId) entitylerini oluştur. Equatable kullanmayı unutma.
> 2. **Repository Interface**: `CalendarRepository` isminde bir interface yaz. İçinde programları/eventleri getirme (Stream), ekleme ve silme (Future) metodları olsun.
> 3. **Hata Yönetimi**: Dönüş tiplerinde projedeki `Either<Failure, T>` yapısını kullan."

### 🟢 Adım 2: Data Katmanı

**Prompt:**
> "Şimdi Data katmanını FirebaseFirestore kullanarak implemente et (`CalendarRepositoryImpl`).
>
> 1. **Firestore Yolları**: Verileri `users/{uid}/programs` ve `users/{uid}/events` koleksiyonlarında tut.
> 2. **Sorgu Mantığı**: Eventleri çekerken tarih aralığına (start/end) göre sorgula.
> 3. **Tekrar Eden Etkinlikler**: `isRecurring: true` olan etkinlikleri tarih filtresinden bağımsız olarak çeken bir mantık kur (Bu etkinlikler client tarafında filtrelenecek).
> 4. **Hata Yönetimi**: Tüm try-catch bloklarında hataları `ServerFailure` veya ilgili Failure sınıfına dönüştür."

### 🟢 Adım 3: State Management (Riverpod)

**Prompt:**
> "Presentation katmanı için Riverpod providerlarını (`lib/features/calendar/presentation/providers/`) hazırla:
>
> - `programsStreamProvider`: Kullanıcının programlarını dinleyen StreamProvider.
> - `selectedDateProvider`: Takvimde seçili olan günü tutan StateProvider.
> - `eventsStreamProvider`: Seçili tarih aralığındaki etkinlikleri getiren StreamProvider.
>
> **Kritik:** Provider içinde bir filtreleme mantığı kur; eğer etkinlik `isRecurring: true` ise, yıl fark etmeksizin o günün/ayın listesine dahil edilmelidir."

### 🟢 Adım 4: UI - Özelleştirilmiş Takvim (Theme Entegrasyonu)

**Prompt:**
> "Proje tasarım sistemine uygun, `table_calendar` paketini sarmalayan `AppCalendar` widget'ını oluştur.
>
> **Tasarım Kuralları (THEME_GUIDE.md):**
> - **Renkler**: Asla hardcoded renk kullanma. `AppTheme.colors(context).brand` (seçili gün), `AppTheme.colors(context).textPrimary` (günler) ve `AppTheme.colors(context).textSecondary` (hafta sonu) kullan.
> - **Tipografi**: `context.moonTypography.body` stillerini kullan.
> - **Marker**: `eventLoader` özelliğini kullanarak, etkinlik olan günlerin altına `AppTheme.colors(context).brand` renginde küçük bir nokta koy.
> - **Container**: Takvimi `AppCard` içine sarmala."

### 🟢 Adım 5: UI - Programlar Sayfası

**Prompt:**
> "`ProgramsScreen` sayfasını oluştur.
>
> - **Layout**: `AppPageLayout` bileşenini kullan (Scaffold yasak).
> - **Liste**: Programları listelerken `AppCard` kullan. Sol tarafta programın rengini gösteren bir `CircleAvatar` olsun.
> - **Aksiyon**: `AppPageLayout`'un `trailing` parametresine bir `AppIconButton` (Ekle) koy.
> - **Boşluklar**: Padding ve marginler için mutlaka `AppTheme.tokens.spacingMd` gibi tokenları kullan."

### 🟢 Adım 6: UI - Etkinlik Ekleme Modalı & Formu

**Prompt:**
> "`showAddEventModal` fonksiyonunu ve ilgili modal içeriğini kodla.
>
> - **Modal**: `AppModal` bileşenini kullan.
> - **Form Elemanları**:
>   - `AppTextInput` (Başlık)
>   - `AppDropdown` (Program Seçimi - `programsStreamProvider`dan beslenmeli)
>   - `AppDatePicker` (Tarih Seçimi - `initialDate` bugünü göstermeli)
>   - `AppSwitch` ('Her Yıl Tekrarla' seçeneği)
> - **Buton**: `AppButton` (Kaydet).
> - **Validasyon**: Form validasyonu ekle ve işlem sonucunda `AppModal.showToast` ile geri bildirim ver."

### 🟢 Adım 7: Entegrasyon (Home & Router)

**Prompt:**
> "Geliştirdiğimiz modülleri ana yapıya entegre et.
>
> 1. **Home Screen**: `HomeScreen` içerisine `AppCalendar` widget'ını ve hemen altına seçili güne ait etkinlikleri gösteren bir ListView ekle. Etkinlik kartlarında (`AppCard`) program rengini kenar çizgisi (border) olarak kullan.
> 2. **Router**: `AppRouter` dosyasına `ProgramsScreen` rotasını ekle.
> 3. **Navigasyon**: Ana menüye (Sidebar/Drawer) 'Programlar' linkini ekle."

---

## ✅ Kalite Kontrol Listesi (QC)

- [ ] `flutter pub add table_calendar` komutu çalıştırıldı mı?
- [ ] Tüm renkler `AppTheme.colors(context)` üzerinden mi geliyor? (Hardcoded renk yasak!)
- [ ] `AppPageLayout` dışında Scaffold kullanımı var mı? (Varsa düzeltilmeli)
- [ ] "Her Yıl Tekrarla" özelliği farklı yıllarda test edildi mi?
- [ ] Dark Mode geçişinde takvim renkleri uyumlu mu?

## 📚 Technical Implementation Reference (v1.0)

Bu bölüm, modülün kod tabanındaki fiziksel yapısını, veri akışını ve kritik mantıkların nerede işlendiğini detaylandırır.

### 1. Dosya ve Klasör Haritası

Modül, Clean Architecture (Domain, Data, Presentation) prensiplerine göre aşağıdaki dosyalara dağıtılmıştır:

```
lib/features/
├── calendar/
│   ├── data/
│   │   └── repositories/
│   │       └── calendar_repository_impl.dart  # Firestore sorguları, Stream birleştirme mantığı
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── event.dart                     # Etkinlik veri modeli (isRecurring burada)
│   │   │   └── program.dart                   # Program/Kategori modeli
│   │   └── repositories/
│   │       └── calendar_repository.dart       # Interface tanımı
│   └── presentation/
│       ├── providers/
│       │   └── calendar_providers.dart        # State Management (streams, selectedDate)
│       └── widgets/
│           ├── app_calendar.dart              # Özel takvim bileşeni (Theme entegreli)
│           └── add_event_modal.dart           # Etkinlik ekleme formu
└── programs/
    └── presentation/
        ├── screens/
        │   └── programs_screen.dart           # Program listesi ve ana ekran
        └── widgets/
            └── add_program_modal.dart         # Yeni kategori ekleme formu
```

### 2. Veri Akışı ve Mantık (Data Flow)

Sistemin kalbi `CalendarRepositoryImpl` ve `calendar_providers.dart` dosyalarında atar.

#### A. Veri Çekme (Streaming)
Takvimdeki etkinlikler (`getEvents`) iki farklı Firestore sorgusunun birleşimiyle oluşur:
1.  **Aralık Sorgusu:** `startDate` değerine göre, sadece o ayın etkinliklerini getirir.
2.  **Tekrar Sorgusu:** `isRecurring == true` olan **TÜM** etkinlikleri getirir (yıl bağımsız).
3.  **Birleştirme:** `Rx.combineLatest2` kullanılarak bu iki akış birleştirilir ve tek bir liste olarak UI'a sunulur.

#### B. Provider Yapısı (`calendar_providers.dart`)
-   `calendarRepositoryProvider`: Veritabanı bağlantılarını yönetir, `FirebaseAuth` ile kullanıcıyı doğrular.
-   `programsStreamProvider`: Kullanıcının oluşturduğu kategorileri anlık olarak dinler (`ProgramsScreen` ve `AddEventModal` dropdown'ı burayı dinler).
-   `eventsStreamProvider`: Seçili ay geliştikçe (`focusedDayProvider`) veritabanından o aya ait verileri dinamik olarak çeker.

### 3. Kritik UI Bileşenleri

#### `AppCalendar` (Widget)
Standart `table_calendar` paketini sarmalar ancak Lapse tasarımına ("THEME_GUIDE") uyarlar:
-   **Renkler:** `AppTheme.colors(context).brand` ile tema bazlı dinamik renkler.
-   **Marker:** Etkinlik olan günlerin altına nokta işaretini `eventLoader` parametresi ile koyar. Burada `isRecurring` kontrolü yapılarak her yıla işaret konması sağlanır.

#### `ProgramsScreen`
-   **Yapı:** `AppPageLayout` kullanılır (Scaffold yerine).
-   **Offline Mod:** İnternet olmasa da (Web/PWA için `main.dart` ayarı sayesinde) liste anında açılır.

### 4. Entegrasyon Noktaları

Bu modül ana uygulamaya şu noktalardan bağlanır:
-   **`lib/core/router/app_router.dart`**: `/programs` rotası tanımlandı.
-   **`lib/features/layout/presentation/main_layout.dart`**: Sidebar menüsüne "Programlar" butonu eklendi.
-   **`lib/main.dart`**: Web için `enablePersistence` ayarı eklendi.
-   **`android/app/src/main/AndroidManifest.xml`**: `INTERNET` izni eklendi.