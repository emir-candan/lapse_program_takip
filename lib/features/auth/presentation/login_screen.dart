import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/components/components.dart';
import 'layout/auth_layout.dart';
import 'providers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nameController.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isLogin) {
      await controller.signIn(email: email, password: password);
    } else {
      if (password != _confirmPasswordController.text.trim()) {
        AppModal.showToast(context: context, message: "Şifreler uyuşmuyor.");
        return;
      }
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        AppModal.showToast(
          context: context,
          message: "Lütfen ad soyad giriniz.",
        );
        return;
      }
      await controller.signUp(email: email, password: password, name: name);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      AppModal.showToast(
        context: context,
        message: "Lütfen e-posta adresinizi girin.",
      );
      return;
    }
    await ref.read(authControllerProvider.notifier).resetPassword(email);
    if (mounted) {
      AppModal.showToast(
        context: context,
        message: "Şifre sıfırlama e-postası gönderildi.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final moonTypography = context.moonTypography;

    // Listen for auth errors
    ref.listen(authControllerProvider, (_, state) {
      if (state.hasError) {
        AppModal.showToast(
          context: context,
          message: state.error.toString().replaceAll("Exception: ", ""),
        );
      } else if (!state.isLoading && !state.hasError && !_isLogin) {
        // Assuming successful registration if no error and not loading
        // Logic mainly relies on no error being thrown
        AppModal.showToast(context: context, message: "Kayıt başarılı!");
      }
    });

    final isLoading = ref.watch(authControllerProvider).isLoading;

    return AuthLayout(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SvgPicture.asset(
              'assets/images/logo.svg',
              height: 80,
              colorFilter: ColorFilter.mode(colors.brand, BlendMode.srcIn),
            ),
            const SizedBox(height: 24),
            Text(
              "LAPSE",
              style: moonTypography?.heading.text32.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Program Takip Sistemi",
              style: moonTypography?.body.text16.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),

            // Form Alanı
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AppCard(
                child: Column(
                  children: [
                    // Kayıt Ol Modu: İsim Soyisim
                    if (!_isLogin) ...[
                      AppTextInput(
                        key: const ValueKey('name_input'),
                        controller: _nameController,
                        hintText: "Ad Soyad",
                        prefixIcon: CupertinoIcons.person,
                        keyboardType: TextInputType.name,
                        // inputFormatters removed to avoid confusion if empty. Or use const []
                        validator: (value) => value!.isEmpty ? 'Zorunlu' : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // E-posta
                    AppTextInput(
                      key: const ValueKey('email_input'),
                      controller: _emailController,
                      hintText: "E-posta",
                      prefixIcon: CupertinoIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.contains('@') ? null : 'Geçersiz e-posta',
                    ),
                    const SizedBox(height: 16),

                    // Şifre
                    AppTextInput(
                      key: const ValueKey('password_input'),
                      controller: _passwordController,
                      hintText: "Şifre",
                      obscureText: true,
                      prefixIcon: CupertinoIcons.lock,
                      validator: (value) =>
                          value!.length < 6 ? 'En az 6 karakter' : null,
                    ),

                    // Kayıt Ol Modu: Şifre Tekrar
                    if (!_isLogin) ...[
                      const SizedBox(height: 16),
                      AppTextInput(
                        key: const ValueKey('confirm_password_input'),
                        controller: _confirmPasswordController,
                        hintText: "Şifre Tekrar",
                        obscureText: true,
                        prefixIcon: CupertinoIcons.lock,
                        validator: (value) => value != _passwordController.text
                            ? 'Şifreler uyuşmuyor'
                            : null,
                      ),
                    ],

                    // Giriş Modu: Şifremi Unuttum
                    if (_isLogin)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AppTextButton(
                            label: "Şifremi Unuttum",
                            onTap: isLoading ? null : _forgotPassword,
                            textColor: colors.textSecondary,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 24),

                    if (_isLogin) const SizedBox(height: 24),

                    // Ana Buton (Giriş Yap / Kayıt Ol)
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: _isLogin ? "Giriş Yap" : "Kayıt Ol",
                        isLoading: isLoading,
                        onTap: () {
                          _submit();
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Toggle Butonu (Hesabın var mı? / Yok mu?)
                    AppTextButton(
                      onTap: isLoading ? null : _toggleAuthMode,
                      label: _isLogin
                          ? "Hesabın yok mu? Kayıt Ol"
                          : "Zaten hesabın var mı? Giriş Yap", // Simplified for now, or use RichText if AppTextButton supports child. AppTextButton only supports String label.
                      // Wait, the original code used RichText. AppTextButton as defined only handles String label.
                      // I should probably stick to the original design intent which was multi-styled text.
                      // But the rules say "NO RAW WIDGETS". TextButton is a raw widget.
                      // Ideally AppTextButton should support RichText or I should use a Row of Text/AppTextButton.
                      // For now, I will use a simple workaround: Keep the RichText inside a GestureDetector or similar?
                      // OR, better, update AppTextButton to receive a widget label? No, that breaks consistency.
                      // Actually, the best way here is to use a Row with Text + AppTextButton(small).
                      // OR, just use a single AppTextButton with the full text, it's fine for now.
                      // Let's improve AppTextButton to allow a child or just stick to string.
                      // Actually, looking at the previous code, it was "Hesabın yok mu?" (grey) + "Kayıt Ol" (brand color).
                      // AppTextButton usually takes one color.
                      // I will compromise: Use AppTextButton for the whole thing and let it be one actionable color.
                      // This is better than raw widget usage.
                      textColor: colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
