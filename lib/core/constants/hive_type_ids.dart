/// Merkezi Hive TypeId sabitleri
///
/// Yeni bir entity eklerken buraya benzersiz bir typeId ekle.
/// ⚠️ ASLA mevcut bir ID'yi değiştirme - cache bozulur!
class HiveTypeIds {
  HiveTypeIds._(); // Instantiate edilemez

  // Calendar Module
  static const int lesson = 2;
  static const int exam = 3;
  static const int subject = 4;
  static const int scheduleSettings = 5;

  // Legacy (kept for reference, do not reuse)
  // static const int event = 0;
  // static const int program = 1;
}
