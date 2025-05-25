import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '/services/snack_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  bool isHiddenPassword = true;
  bool isLoading = false;

  final emailTextInputController = TextEditingController();
  final passwordTextInputController = TextEditingController();
  final passwordTextRepeatInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (passwordTextInputController.text !=
        passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar(
        context,
        'signup.passwords_do_not_match'.tr(),
        true,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );

      SnackBarService.showSnackBar(
        context,
        'signup.registration_success'.tr(),
        false,
      );

      navigator.pushNamedAndRemoveUntil('/', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
          context,
          'signup.email_already_in_use'.tr(),
          true,
        );
      } else {
        SnackBarService.showSnackBar(
          context,
          'signup.unknown_error'.tr(),
          true,
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'signup.title'.tr(),
          style: const TextStyle(fontFamily: 'Pacifico', color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg', // тот же фон, что и на других экранах
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.3)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Padding(
  padding: const EdgeInsets.all(24.0),
  child: Form(
    key: formKey,
    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          controller: emailTextInputController,
                          validator: (email) => email != null && !EmailValidator.validate(email)
                              ? 'signup.enter_valid_email'.tr()
                              : null,
                          style: const TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.85),
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'signup.enter_email'.tr(),
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          controller: passwordTextInputController,
                          obscureText: isHiddenPassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6 ? 'signup.min_6_chars'.tr() : null,
                          style: const TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.85),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'signup.enter_password'.tr(),
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            suffixIcon: InkWell(
                              onTap: togglePasswordView,
                              child: Icon(
                                isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          controller: passwordTextRepeatInputController,
                          obscureText: isHiddenPassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6 ? 'signup.min_6_chars'.tr() : null,
                          style: const TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.85),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'signup.enter_password_again'.tr(),
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            suffixIcon: InkWell(
                              onTap: togglePasswordView,
                              child: Icon(
                                isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
const SizedBox(height: 30),
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: isLoading ? null : signUp,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 195, 255), // пример, подбери цвет как в логине
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
    child: isLoading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.white,
            ),
          )
        : Text(
            'signup.register'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
  ),
),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
