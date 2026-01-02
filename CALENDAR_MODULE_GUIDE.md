# 📅 Lapse: Ders Programı & Sınav Takibi Rehberi

Bu doküman, **Lapse** projesindeki "Haftalık Ders Programı" ve "Sınav Takip" sisteminin mimari yapısını, veritabanı şemasını ve işleyişini açıklar.

Bu rehber, projedeki `SYSTEM_GUIDE.md` (Mimari) ve `OFFLINE_FIRST_GUIDE.md` dosyalarıyla tam uyumlu hazırlanmıştır.

---

## 🏗️ Bölüm 1: Mimari Tasarım

### 1. Veritabanı Şeması (Firestore)

Veriler `users/{uid}/` koleksiyonu altında saklanır.

**Koleksiyon: `lessons`** (Haftalık Dersler)
Kullanıcının haftalık tekrarlayan dersleri.

```json
{
  "id": "string (uuid)",
  "title": "string (Örn: Matematik)",
  "dayOfWeek": "int (1=Pazartesi, 7=Pazar)",
  "startHour": "int (9)",
  "startMinute": "int (0)",
  "endHour": "int (10)",
  "endMinute": "int (30)",
  "location": "string (nullable - Örn: A-101)",
  "createdAt": "timestamp"
}
```

**Koleksiyon: `exams`** (Sınavlar)
Belirli bir tarihte yapılacak olan sınavlar.

```json
{
  "id": "string (uuid)",
  "title": "string",
  "date": "timestamp",
  "hour": "int (nullable)",
  "minute": "int (nullable)",
  "description": "string (nullable)",
  "createdAt": "timestamp"
}
```

### 2. Klasör Yapısı

Kodlar `lib/features/calendar/` altında merkezi olarak toplanmıştır:

- `domain/entities/`: `Lesson` ve `Exam` modelleri.
- `data/repositories/`: Offline-first repository (Firebase + Hive).
- `presentation/providers/`: LessonsNotifier ve ExamsNotifier.
- `presentation/widgets/`: `AddLessonModal`, `AddExamModal`.
- `presentation/screens/`: `ExamsScreen`. (Haftalık Program HomeScreen içindedir).

---

## 🏗️ Bölüm 2: Uygulama Kuralları

### 1. Haftalık Ders Programı (HomeScreen)
- Dersler `brand` rengini (Lapse Yeşili) kullanır.
- Gün bazlı filtreleme yapılır.
- Swipe-to-delete özelliği ile silinebilir.

### 2. Sınav Takibi (ExamsScreen)
- Sınavlar tarihe göre sıralanır.
- "Yaklaşan" ve "Geçmiş" olarak kategorize edilir.
- Ana ekranda (HomeScreen) sonraki 7 günün sınavları özet olarak gösterilir.

---

## ✅ Kalite Kontrol Listesi (QC)

- [ ] Tüm renkler `AppTheme.colors(context)` üzerinden mi geliyor?
- [ ] Yeni bir ders eklendiğinde Firebase ve Hive aynı anda güncelleniyor mu? (Dual-Write)
- [ ] Sınav saatleri opsiyonel mi?
- [ ] `SYSTEM_GUIDE.md` layout kurallarına uyuluyor mu?

---

## 📚 Teknik Detaylar

### Offline-First Akışı
1. **Okuma:** `getCachedLessons()` ve `getCachedExams()` ile Hive'dan anında veri çekilir.
2. **Yazma:** `addLesson()` veya `addExam()` çağrıldığında önce Hive güncellenir, ardından Firebase'e yazılır.
3. **Senkronizasyon:** `AuthController` login anında `forceRefresh()` çağrısı yaparak Firebase'deki güncel veriyi Hive'a indirir.

---
*Son Güncelleme: 2026-01-02*