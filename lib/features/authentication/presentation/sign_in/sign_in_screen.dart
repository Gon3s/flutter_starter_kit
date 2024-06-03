import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/common_widgets/primary_button.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:gones_starter_kit/localization/string_hardcoded.dart';

/// Sign In Screen
/// Wraps the [SignInContent] widget in a [Scaffold]
class SignInScreen extends StatelessWidget {
  /// Constructor
  const SignInScreen({super.key});

  /// Key for email field
  static const emailKey = Key('email');

  /// Key for password field
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              gapH64,
              Text(
                'Bon retour'.hardcoded,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              gapH4,
              Text(
                'Connectez-vous à votre compte'.hardcoded,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              gapH32,
              const Expanded(
                child: SignInContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sign In Content
class SignInContent extends ConsumerStatefulWidget {
  /// Constructor
  const SignInContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInContentState();
}

class _SignInContentState extends ConsumerState<SignInContent> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text.trim();

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    _node.nextFocus();
  }

  void _passwordEditingComplete() {
    _node.nextFocus();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _node,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: SignInScreen.emailKey,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email'.hardcoded,
                      hintText: 'test@test.com'.hardcoded,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) => null,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: _emailEditingComplete,
                  ),
                  gapH8,
                  TextFormField(
                    key: SignInScreen.passwordKey,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe'.hardcoded,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => null,
                    autocorrect: false,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _passwordEditingComplete,
                  ),
                  gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Créer un compte'.hardcoded,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Mot de passe oublié ?'.hardcoded,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PrimaryButton(text: 'Se connecter'.hardcoded, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
