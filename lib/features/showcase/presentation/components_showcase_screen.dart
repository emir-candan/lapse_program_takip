import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/components/components.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';

class ComponentsShowcaseScreen extends ConsumerStatefulWidget {
  const ComponentsShowcaseScreen({super.key});

  @override
  ConsumerState<ComponentsShowcaseScreen> createState() =>
      _ComponentsShowcaseScreenState();
}

class _ComponentsShowcaseScreenState
    extends ConsumerState<ComponentsShowcaseScreen>
    with TickerProviderStateMixin {
  // State for interactivity
  bool _switchVal = true;
  bool _checkVal = true;
  int _radioVal = 1;
  double _sliderVal = 0.5;
  double _ratingVal = 3;
  String _codeVal = "";
  DateTime? _dateVal;
  late TabController _tabController;
  int _segmentVal = 0;

  // Chip state demo
  final List<String> _chips = ["Flutter", "Dart", "Moon Design"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return AppPageLayout(
      title: "Design System Showcase",
      trailing: AppIconButton(
        icon: isDark ? Icons.light_mode : Icons.dark_mode_outlined,
        onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
        tooltip: "Temayı Değiştir",
        backgroundColor: AppTheme.colors(context).surface,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 48),

              // --- 1. NAVIGATION & STRUCTURE ---
              _buildSectionTitle("Navigation & Structure"),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBreadcrumbs(
                      items: [
                        Text("Home"),
                        Text("Showcase"),
                        Text("All Components"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppTabs(
                      tabs: const [
                        Text("Genel"),
                        Text("Güvenlik"),
                        Text("Ayarlar"),
                      ],
                      controller: _tabController,
                    ),
                    const SizedBox(height: 24),
                    AppSegmentedControl(
                      children: const {
                        0: Text("Günlük"),
                        1: Text("Haftalık"),
                        2: Text("Aylık"),
                      },
                      value: _segmentVal,
                      onValueChanged: (v) =>
                          setState(() => _segmentVal = v ?? 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- 2. INPUTS & FORMS ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sol Kolon: Text Inputs
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Text Inputs"),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppSearchBar(hintText: "Sistemde ara..."),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextInput(
                                      hintText: "Ad",
                                      prefixIcon: Icons.person_outline,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AppTextInput(
                                      hintText: "Soyad",
                                      prefixIcon: Icons.person_outline,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              AppTextInput(
                                hintText: "E-posta",
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              const AppTextArea(
                                hintText: "Bize bir not bırakın (TextArea)...",
                                minLines: 3,
                              ),
                              const SizedBox(height: 16),
                              AppCodeInput(
                                length: 4,
                                onCompleted: (v) =>
                                    setState(() => _codeVal = v),
                              ),
                              Center(
                                child: Text(
                                  "Girilen Kod: $_codeVal",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Sağ Kolon: Selectors & Pickers
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Selectors & Pickers"),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppDropdown<String>(
                                hintText: "Departman Seçiniz",
                                items: const [
                                  DropdownMenuItem(
                                    value: "IT",
                                    child: Text("Bilgi İşlem"),
                                  ),
                                  DropdownMenuItem(
                                    value: "HR",
                                    child: Text("İnsan Kaynakları"),
                                  ),
                                  DropdownMenuItem(
                                    value: "MKT",
                                    child: Text("Pazarlama"),
                                  ),
                                ],
                                onChanged: (v) {},
                              ),
                              const SizedBox(height: 16),
                              AppDatePicker(
                                value: _dateVal,
                                label: "Doğum Tarihi",
                                onChanged: (d) => setState(() => _dateVal = d),
                              ),
                              const SizedBox(height: 16),
                              AppTagInput(
                                hintText: "Yetenekler (Enter)",
                                initialTags: const ["Flutter", "Dart"],
                              ),
                              const SizedBox(height: 16),
                              AppFileUploader(
                                label: "Profil Resmi Yükle",
                                onUpload: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- 3. INTERACTIVE & TOGGLES ---
              _buildSectionTitle("Interactive & Toggles"),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Karanlık Mod"),
                                  AppSwitch(
                                    value: _switchVal,
                                    onChanged: (v) =>
                                        setState(() => _switchVal = v),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Bildirimleri Aç"),
                                  AppCheckbox(
                                    value: _checkVal,
                                    onChanged: (v) =>
                                        setState(() => _checkVal = v!),
                                    label: "",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 80,
                          color: AppTheme.colors(context).border,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Cinsiyet (Radio):",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  AppRadio<int>(
                                    value: 1,
                                    groupValue: _radioVal,
                                    onChanged: (v) =>
                                        setState(() => _radioVal = v!),
                                    label: "Kadın",
                                  ),
                                  const SizedBox(width: 16),
                                  AppRadio<int>(
                                    value: 2,
                                    groupValue: _radioVal,
                                    onChanged: (v) =>
                                        setState(() => _radioVal = v!),
                                    label: "Erkek",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const AppDivider(indent: 0, endIndent: 0),
                    const SizedBox(height: 16),
                    const Text("Ses Seviyesi (Slider)"),
                    AppSlider(
                      value: _sliderVal,
                      onChanged: (v) => setState(() => _sliderVal = v),
                    ),
                    const SizedBox(height: 16),
                    const Text("Memnuniyet (Rating)"),
                    AppRating(
                      value: _ratingVal,
                      onChanged: (v) => setState(() => _ratingVal = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- 4. DATA DISPLAY ---
              _buildSectionTitle("Data Display & Tables"),
              AppCard(
                padding: EdgeInsets.zero,
                child: AppTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Kullanıcı")),
                    DataColumn(label: Text("Durum (Tag)")),
                    DataColumn(label: Text("İşlem")),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text("#101")),
                        DataCell(
                          Row(
                            children: const [
                              AppAvatar(
                                imageUrl: "https://i.pravatar.cc/100",
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text("Ali Veli"),
                            ],
                          ),
                        ),
                        const DataCell(
                          AppTag(label: "Aktif", backgroundColor: Colors.green),
                        ),
                        DataCell(AppIconButton(icon: Icons.edit, onTap: () {})),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("#102")),
                        DataCell(
                          Row(
                            children: const [
                              AppAvatar(
                                imageUrl: "https://i.pravatar.cc/101",
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text("Ayşe Can"),
                            ],
                          ),
                        ),
                        const DataCell(
                          AppTag(
                            label: "Beklemede",
                            backgroundColor: Colors.orange,
                          ),
                        ),
                        DataCell(
                          AppIconButton(
                            icon: Icons.delete,
                            color: Colors.red,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- 5. FEEDBACK & ALERTS ---
              _buildSectionTitle("Feedback & Alerts"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const AppAlert(
                          title: "Bilgi",
                          body: "Bu bir bilgilendirme mesajıdır (AppAlert).",
                          showIcon: true,
                        ),
                        const SizedBox(height: 16),
                        AppCard(
                          child: Wrap(
                            spacing: 8,
                            children: _chips
                                .map(
                                  (c) => AppChip(
                                    label: c,
                                    onRemove: () =>
                                        setState(() => _chips.remove(c)),
                                    icon: Icons.check,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AppLoader(size: 24),
                              Text("Yükleniyor..."),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const AppEmptyState(
                            message: "Veri Bulunamadı (EmptyState)",
                            icon: Icons.inbox,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            children: [
                              AppButton(
                                label: "Toast Göster",
                                onTap: () => AppModal.showToast(
                                  context: context,
                                  message: "İşlem Başarılı! 🚀",
                                ),
                              ),
                              AppButton(
                                label: "Modal Aç",
                                onTap: () => AppModal.show(
                                  context: context,
                                  child: Container(
                                    padding: const EdgeInsets.all(32),
                                    child: const Text(
                                      "Bu bir Modal içeriğidir.",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- 6. MEDIA & LISTS ---
              _buildSectionTitle("Media & Lists"),
              AppCard(
                child: Column(
                  children: [
                    // Carousel
                    SizedBox(
                      height: 200,
                      child: AppCarousel(
                        items: [
                          AppImage(
                            url: "https://picsum.photos/seed/1/400/200",
                            width: double.infinity,
                            height: 200,
                          ),
                          AppImage(
                            url: "https://picsum.photos/seed/2/400/200",
                            width: double.infinity,
                            height: 200,
                          ),
                          AppImage(
                            url: "https://picsum.photos/seed/3/400/200",
                            width: double.infinity,
                            height: 200,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // List Items
                    AppListItem(
                      title: const Text("Hesap Ayarları"),
                      subtitle: const Text(
                        "Şifre ve güvenlik işlemlerini buradan yapın.",
                      ),
                      leading: const Icon(Icons.security),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const AppDivider(),
                    AppListItem(
                      title: const Text("Hakkında"),
                      leading: const Icon(Icons.info_outline),
                      trailing: AppTooltip(
                        message: "Versiyon 1.0.0",
                        child: AppIconButton(
                          icon: Icons.help_outline,
                          onTap: () {},
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Skeleton
                    const Row(
                      children: [
                        AppSkeleton(width: 50, height: 50, borderRadius: 25),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppSkeleton(width: double.infinity, height: 16),
                              SizedBox(height: 8),
                              AppSkeleton(width: 150, height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Design System v1.0",
          style: context.moonTypography?.heading.text32.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Lapse Program Takip Sistemi - Bileşen Kataloğu",
          style: context.moonTypography?.body.text18.copyWith(
            color: AppTheme.colors(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
