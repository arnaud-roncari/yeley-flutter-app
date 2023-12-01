import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/commons/validators.dart';
import 'package:yeley_frontend/providers/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLegaliciesChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kScaffoldBackground,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kScaffoldBackground,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/yeley.svg',
                    height: 95,
                    width: 95,
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Inscrivez-vous",
                    style: kBold22,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Pour découvrir les restaurants et activités près de chez vous !",
                      style: kRegular14,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 150,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "S'inscrire",
                        style: kBold22,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        decoration: const BoxDecoration(
                          color: kMainGreen,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Email", style: kRegular14),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: 'Entrer email',
                      hintStyle: kRegular16,
                    ),
                    controller: _emailController,
                    validator: Validator.email,
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Mot de passe", style: kRegular14),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: 'Entrer mot de passe',
                      hintStyle: kRegular16,
                    ),
                    controller: _passwordController,
                    validator: Validator.password,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: kMainGreen,
                        value: _isLegaliciesChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isLegaliciesChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: "Lato",
                            ),
                            children: [
                              TextSpan(
                                text: 'En vous inscrivant, vous acceptez les ',
                                style: kRegular16.copyWith(color: Colors.grey),
                              ),
                              TextSpan(
                                style: kRegular16.copyWith(color: kMainGreen),
                                text: 'Conditions Générales d\'Utilisation',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/terms-of-use');
                                  },
                              ),
                              TextSpan(text: ' et la ', style: kRegular16.copyWith(color: Colors.grey)),
                              TextSpan(
                                style: kRegular16.copyWith(color: kMainGreen),
                                text: 'Politique de Confidentialité',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/privacy-policy');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: context.watch<AuthProvider>().isRegistering
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: kMainGreen,
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: kMainGreen),
                            onPressed: _isLegaliciesChecked
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      await context
                                          .read<AuthProvider>()
                                          .signup(context, _emailController.text, _emailController.text);
                                    }
                                  }
                                : null,
                            child: Text("S'inscrire", style: kBold16.copyWith(color: Colors.white)),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: "Lato",
                      ),
                      children: [
                        TextSpan(
                          text: 'Vous avez déjà un compte ? ',
                          style: kRegular16.copyWith(color: Colors.black),
                        ),
                        TextSpan(
                          style: kRegular16.copyWith(color: kMainGreen),
                          text: 'Connectez-vous.',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/login');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
