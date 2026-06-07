import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_name}}/common_widgets/primary_button.dart';
import 'package:{{app_name}}/constants/app_sizes.dart';
import 'package:{{app_name}}/exceptions/async_value_extensions.dart';
import 'package:{{app_name}}/features/authentication/presentation/auth_validators.dart';
import 'package:{{app_name}}/features/authentication/presentation/sign_up/sign_up_controller.dart';
import 'package:{{app_name}}/localization/app_strings.dart';
import 'package:{{app_name}}/routing/app_router.dart';

/// Sign Up Screen
class SignUpScreen extends StatelessWidget {
  /// Constructor
  const SignUpScreen({super.key});

  /// Key for email field
  static const emailKey = Key('email');

  /// Key for password field
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              gapH64,
              Text(
                s.createAccountTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              gapH4,
              Text(
                s.createAccountSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              gapH32,
              const Expanded(child: _SignUpContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpContent extends ConsumerStatefulWidget {
  const _SignUpContent();

  @override
  ConsumerState<_SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends ConsumerState<_SignUpContent> with AuthValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text.trim();

  var _submitted = false;
  var _isObscure = true;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      await ref.read(signUpControllerProvider.notifier).submit(
            email: _email,
            password: _password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    ref.listen(signUpControllerProvider, (_, state) => state.showSnackBarOnError(context));
    final state = ref.watch(signUpControllerProvider);

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
                    key: SignUpScreen.emailKey,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: s.email,
                      hintText: s.emailHint,
                      enabled: !state.isLoading,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) => !_submitted ? null : validateEmail(email ?? ''),
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () {
                      if (canSubmitEmail(_email)) _node.nextFocus();
                    },
                  ),
                  gapH16,
                  TextFormField(
                    key: SignUpScreen.passwordKey,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: s.password,
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
                    onEditingComplete: _submit,
                  ),
                  gapH16,
                  GestureDetector(
                    onTap: () => ref.read(goRouterProvider).goNamed(AppRouter.login.name),
                    child: Text(
                      s.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            PrimaryButton(
              text: s.signUp,
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
