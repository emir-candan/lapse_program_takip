import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/components/components.dart';
import '../../../core/components/form/app_tag_input.dart';
import '../../../core/components/form/app_search_bar.dart';
import '../../../core/components/navigation/app_segmented_control.dart';
import '../../../core/theme/theme_provider.dart';

class ComponentsShowcaseScreen extends ConsumerStatefulWidget {
  const ComponentsShowcaseScreen({super.key});

  @override
  ConsumerState<ComponentsShowcaseScreen> createState() => _ComponentsShowcaseScreenState();
}

class _ComponentsShowcaseScreenState extends ConsumerState<ComponentsShowcaseScreen> with TickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: context.moonColors?.goku,
      appBar: AppAppBar(
        title: "Design System",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppIconButton(
              icon: isDark ? Icons.light_mode : Icons.dark_mode_outlined,
              onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
              tooltip: "Temayı Değiştir",
              backgroundColor: context.moonColors?.gohan,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
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
                      const AppBreadcrumbs(items: [Text("Home"), Text("Settings"), Text("Profile")]),
                      const SizedBox(height: 24),
                      AppTabs(
                        tabs: const [Text("Genel"), Text("Güvenlik"), Text("Bildirimler")],
                        controller: _tabController,
                      ),
                      const SizedBox(height: 24),
                      AppSegmentedControl(
                         children: const {0: Text("Günlük"), 1: Text("Haftalık"), 2: Text("Aylık")},
                         value: _segmentVal,
                         onValueChanged: (v) => setState(() => _segmentVal = v ?? 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- 2. INPUTS & FORMS ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Form Inputs"),
                          AppCard(
                            child: Column(
                              children: [
                                const AppSearchBar(hintText: "Kullanıcı ara..."),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: AppTextInput(hintText: "Ad", prefixIcon: Icons.person_outline)),
                                    const SizedBox(width: 16),
                                    Expanded(child: AppTextInput(hintText: "Soyad", prefixIcon: Icons.person_outline)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                AppDropdown<String>(
                                  hintText: "Ülke Seçiniz",
                                  items: const [
                                    DropdownMenuItem(value: "TR", child: Text("Türkiye")),
                                    DropdownMenuItem(value: "US", child: Text("Amerika")),
                                  ],
                                  onChanged: (v) {},
                                ),
                                const SizedBox(height: 16),
                                AppTagInput(hintText: "Yetenekler (Enter)", initialTags: const ["Flutter", "Dart"]),
                                const SizedBox(height: 16),
                                AppFileUploader(onUpload: (){}),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Interactive"),
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Dark Mode"),
                                    AppSwitch(value: _switchVal, onChanged: (v) => setState(() => _switchVal = v)),
                                  ],
                                ),
                                const AppDivider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Bildirimler"),
                                    AppCheckbox(value: _checkVal, onChanged: (v) => setState(() => _checkVal = v!), label: ""),
                                  ],
                                ),
                                const AppDivider(),
                                const SizedBox(height: 8),
                                AppSlider(value: _sliderVal, onChanged: (v) => setState(() => _sliderVal = v)),
                                Center(child: AppRating(value: _ratingVal, onChanged: (v) => setState(() => _ratingVal = v))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // --- 3. DATA DISPLAY ---
                _buildSectionTitle("Data Display"),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: AppTable(
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Kullanıcı")),
                      DataColumn(label: Text("Durum")),
                      DataColumn(label: Text("İşlem")),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text("#101")),
                        DataCell(Row(children: const [AppAvatar(imageUrl: "https://i.pravatar.cc/100", size: 24), SizedBox(width: 8), Text("Ali Veli")])),
                        const DataCell(AppTag(label: "Aktif", backgroundColor: Colors.green)),
                        DataCell(AppIconButton(icon: Icons.more_vert, onTap: (){})),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("#102")),
                        DataCell(Row(children: const [AppAvatar(imageUrl: "https://i.pravatar.cc/101", size: 24), SizedBox(width: 8), Text("Ayşe Can")])),
                        const DataCell(AppTag(label: "Beklemede", backgroundColor: Colors.orange)),
                        DataCell(AppIconButton(icon: Icons.more_vert, onTap: (){})),
                      ]),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // --- 4. FEEDBACK & OVERLAY ---
                _buildSectionTitle("Feedback System"),
                 Wrap(
                  spacing: 24, runSpacing: 24,
                  children: [
                    AppCard(child: const AppLoader()),
                    AppCard(child: const AppEmptyState(message: "Veri Yok")),
                    AppButton(
                      label: "Başarı Mesajı", 
                      onTap: () => AppModal.showToast(context: context, message: "İşlem Başarılı! 🚀"),
                    ),
                    AppButton(
                      label: "Modal Test", 
                      onTap: () => AppModal.show(context: context, child: Container(padding: const EdgeInsets.all(32), child: const Text("Modal İçeriği"))),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // --- 5. MEDIA & LISTS (The missing ones) ---
                _buildSectionTitle("Media & Lists"),
                AppCard(
                  child: Column(
                    children: [
                      // Carousel & Image
                      SizedBox(
                        height: 200,
                        child: AppCarousel(
                          items: [
                            AppImage(url: "https://picsum.photos/seed/1/300/200", width: double.infinity, height: 200),
                            AppImage(url: "https://picsum.photos/seed/2/300/200", width: double.infinity, height: 200),
                            AppImage(url: "https://picsum.photos/seed/3/300/200", width: double.infinity, height: 200),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // List Items
                      AppListItem(
                        title: const Text("List Item 1"),
                        subtitle: const Text("Açıklama metni buraya gelir."),
                        leading: const Icon(Icons.folder),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: (){},
                      ),
                      const AppDivider(),
                      AppListItem(
                        title: const Text("List Item 2"),
                        leading: const Icon(Icons.file_copy),
                        trailing: AppTooltip(
                          message: "Bu bir ipucudur",
                          child: AppIconButton(icon: Icons.info_outline, onTap: (){}),
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
      ),
    );
  }
  
  // Dummies
  static void _emptyBool(bool v) {}
  static void _emptyBoolNullable(bool? v) {}
  static void _emptyIntNullable(int? v) {}

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Design System v1.0", style: context.moonTypography?.heading.text32.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Lapse Program Takip Sistemi'nin yapı taşları.", style: context.moonTypography?.body.text18.copyWith(color: context.moonColors?.textSecondary)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }
}
