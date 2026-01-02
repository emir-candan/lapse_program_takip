# Lapse - Okul Takip Sistemi 🎓

Lapse, öğrenciler için tasarlanmış, **Offline-First** mimarisine sahip modern ve dinamik bir okul takip uygulamasıdır. Ders programınızı, sınavlarınızı ve ders konularınızı tek bir yerden yönetmenize yardımcı olur.

## ✨ Özellikler

- **🛠️ Gelişmiş Ders Programı Kurulumu:** Okul saatlerinizi, ders ve teneffüs sürelerinizi, hatta öğle aranızı tek seferde tanımlayın. Programın iskeleti otomatik olarak oluşturulur.
- **📚 Ders ve Konu Yönetimi:** Sadece ders ismi değil; öğretmen, sınıf, AKTS ve renk gibi detaylarla derslerinizi tanımlayın.
- **📅 Dinamik Haftalık Çizelge:** Tanımladığınız slotlara göre derslerinizi yerleştirin ve günlük akışınızı takip edin.
- **📝 Sınav Takibi:** Yaklaşan sınavlarınızı derslerinizle ilişkilendirerek takip edin.
- **📶 Offline-First Mimarisi:** İnternet olmasa dahi tüm verilerinize erişin ve düzenleme yapın. İnternet geldiğinde Firebase ile otomatik senkronizasyon sağlanır, bu sayede veri kaybı olmaz ve uygulama her zaman stabil çalışır.
- **📱 PWA Desteği:** Uygulamayı telefonunuzun ana ekranına ekleyin ve bir mobil uygulama gibi tam ekran deneyimleyin. Aşağıda Android cihazlar için indirme bağlantısını da bulabilirsiniz.
- **🎨 Premium Arayüz:** Moon Design System temeli kullanılarak hazırlanmış, modern, hızlı ve kullanıcı dostu arayüz.

## 🚀 Teknoloji Yığını

- **Framework:** Flutter (Web, Android, iOS)
- **State Management:** Riverpod (StateNotifier)
- **Local Database:** Hive (Offline Cache & NoSQL)
- **Backend:** Firebase (Firestore & Auth)
- **Design System:** Moon Design Framework

## 🏗️ Mimari Yapı

Uygulama, **Clean Architecture** prensiplerinden esinlenen **Feature-First** yapısı üzerine kurulmuştur:

1. **Domain Layer:** Pure Dart entities ve repository arayüzleri. İş mantığının merkezi.
2. **Data Layer:** Cloud Firestore (Remote) ve Hive (Local) entegrasyonu. Veri tutarlılığı için cache-first stratejisi.
3. **Presentation Layer:** Riverpod ile yönetilen reaktif bileşenler ve Moon Design tabanlı UI elementleri.

---
*Geliştiren: [Emir Candan](https://github.com/emir-candan)*
*Android için APK indirme bağlantısı [APK (arm64-v8a)]([https://github.com/username/repo/releases/latest](https://github.com/emir-candan/lapse_program_takip/releases/download/v0.0.1/lapse-app-arm64-v8a-release-0.0.1.apk))
