import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/common_widgets/primary_button.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:gones_starter_kit/exceptions/async_value_extensions.dart';
import 'package:gones_starter_kit/features/authentication/presentation/auth_validators.dart';
import 'package:gones_starter_kit/features/authentication/presentation/sign_in/sign_in_controller.dart';
import 'package:gones_starter_kit/localization/string_hardcoded.dart';
import 'package:gones_starter_kit/routing/app_router.dart';

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

class _SignInContentState extends ConsumerState<SignInContent> with AuthValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text.trim();

  var _submitted = false;
  var _isObscure = true;

  Future<void> _submit() async {
    setState(() => _submitted = true);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (_formKey.currentState!.validate()) {
      final controller = ref.read(signInControllerProvider.notifier);
      await controller.submit(
        email: _email,
        password: _password,
      );
    }
  }

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(_email)) _node.nextFocus();
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(_email)) {
      _node.nextFocus();
      return;
    }
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInControllerProvider, (_, state) => state.showSnackBarOnError(context));
    final state = ref.watch(signInControllerProvider);

    return FocusScope(
      node: _node,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    key: SignInScreen.emailKey,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email'.hardcoded,
                      hintText: 'test@test.com'.hardcoded,
                      enabled: !state.isLoading,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) => !_submitted ? null : validateEmail(email ?? ''),
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: _emailEditingComplete,
                  ),
                  gapH16,
                  TextFormField(
                    key: SignInScreen.passwordKey,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe'.hardcoded,
                      enabled: !state.isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isObscure = !_isObscure),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => !_submitted ? null : validatePassword(password ?? ''),
                    autocorrect: false,
                    obscureText: _isObscure,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _passwordEditingComplete,
                  ),
                  gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => ref.read(goRouterProvider).goNamed(AppRouter.signUp.name),
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
            PrimaryButton(
              text: 'Se connecter'.hardcoded,
              onPressed: state.isLoading ? null : _submit,
              width: double.infinity,
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
