import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_name}}/common_widgets/primary_button.dart';
import 'package:{{app_name}}/constants/app_sizes.dart';
import 'package:{{app_name}}/exceptions/async_value_extensions.dart';
import 'package:{{app_name}}/features/authentication/presentation/auth_validators.dart';
import 'package:{{app_name}}/features/authentication/presentation/sign_in/sign_in_controller.dart';
import 'package:{{app_name}}/localization/app_strings.dart';
import 'package:{{app_name}}/routing/app_router.dart';

/// Sign In Screen
class SignInScreen extends StatelessWidget {
  /// Constructor
  const SignInScreen({super.key});

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
              Text(s.welcomeBack, style: Theme.of(context).textTheme.headlineLarge),
              gapH4,
              Text(s.signInSubtitle, style: Theme.of(context).textTheme.bodyMedium),
              gapH32,
              const Expanded(child: SignInContent()),
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
      await ref.read(signInControllerProvider.notifier).submit(
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

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
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
                    key: SignInScreen.passwordKey,
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
                    onEditingComplete: () {
                      if (!canSubmitEmail(_email)) {
                        _node.nextFocus();
                        return;
                      }
                      _submit();
                    },
                  ),
                  gapH16,
                  GestureDetector(
                    onTap: () => ref.read(goRouterProvider).goNamed(AppRouter.signUp.name),
                    child: Text(s.createAccount, style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ),
            PrimaryButton(
              text: s.signIn,
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
