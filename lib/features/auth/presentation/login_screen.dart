import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/components/components.dart';
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
        AppModal.showToast(context: context, message: "Lütfen ad soyad giriniz.");
        return;
      }
      await controller.signUp(email: email, password: password, name: name);
    }
  }
  
  Future<void> _forgotPassword() async {
     final email = _emailController.text.trim();
     if (email.isEmpty) {
        AppModal.showToast(context: context, message: "Lütfen e-posta adresinizi girin.");
        return;
     }
     await ref.read(authControllerProvider.notifier).resetPassword(email);
     if (mounted) {
       AppModal.showToast(context: context, message: "Şifre sıfırlama e-postası gönderildi.");
     }
  }

  @override
  Widget build(BuildContext context) {
    final moonColors = context.moonColors;
    final moonTypography = context.moonTypography;
    
    // Listen for auth errors
    ref.listen(authControllerProvider, (_, state) {
      if (state.hasError) {
         AppModal.showToast(context: context, message: state.error.toString().replaceAll("Exception: ", ""));
      } else if (!state.isLoading && !state.hasError && !_isLogin) {
         // Assuming successful registration if no error and not loading
         // Logic mainly relies on no error being thrown
         AppModal.showToast(context: context, message: "Kayıt başarılı!");
      }
    });

    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 80,
                  colorFilter: ColorFilter.mode(
                    moonColors?.piccolo ?? Colors.green,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "LAPSE",
                  style: moonTypography?.heading.text32.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                    color: moonColors?.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Program Takip Sistemi",
                  style: moonTypography?.body.text16.copyWith(
                    color: moonColors?.textSecondary,
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
                          validator: (value) => value!.contains('@') ? null : 'Geçersiz e-posta',
                        ),
                        const SizedBox(height: 16),

                        // Şifre
                        AppTextInput(
                          key: const ValueKey('password_input'),
                          controller: _passwordController,
                          hintText: "Şifre",
                          obscureText: true,
                          prefixIcon: CupertinoIcons.lock,
                          validator: (value) => value!.length < 6 ? 'En az 6 karakter' : null,
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
                            validator: (value) => value != _passwordController.text ? 'Şifreler uyuşmuyor' : null,
                          ),
                        ],

                        // Giriş Modu: Şifremi Unuttum
                        if (_isLogin)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading ? null : () {
                                  _forgotPassword();
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Şifremi Unuttum",
                                  style: moonTypography?.body.text14.copyWith(
                                    color: moonColors?.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
                        TextButton(
                          onPressed: isLoading ? null : _toggleAuthMode,
                          child: RichText(
                            text: TextSpan(
                              style: moonTypography?.body.text14.copyWith(
                                color: moonColors?.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: _isLogin
                                      ? "Hesabın yok mu? "
                                      : "Zaten hesabın var mı? ",
                                ),
                                TextSpan(
                                  text: _isLogin ? "Kayıt Ol" : "Giriş Yap",
                                  style: TextStyle(
                                    color: moonColors?.piccolo,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}