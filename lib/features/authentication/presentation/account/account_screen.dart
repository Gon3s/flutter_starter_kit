import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gones_starter_kit/common_widgets/primary_button.dart';
import 'package:gones_starter_kit/constants/app_sizes.dart';
import 'package:gones_starter_kit/exceptions/async_value_extensions.dart';
import 'package:gones_starter_kit/features/authentication/data/firebase_auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/domain/auth_repository.dart';
import 'package:gones_starter_kit/features/authentication/presentation/account/account_controller.dart';
import 'package:gones_starter_kit/features/authentication/presentation/account/change_password_controller.dart';
import 'package:gones_starter_kit/localization/app_strings.dart';

/// Account screen — shows user info, change password and danger zone.
class AccountScreen extends ConsumerWidget {
  /// Creates a new instance of [AccountScreen].
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final accountState = ref.watch(accountControllerProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.accountTitle),
        actions: [
          IconButton(
            icon: accountState.isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  )
                : const Icon(Icons.logout_outlined),
            onPressed: accountState.isLoading
                ? null
                : () => ref.read(accountControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p16),
        children: [
          _UserInfoSection(email: user?.email ?? ''),
          gapH24,
          _ChangePasswordSection(),
          gapH24,
          _DangerZoneSection(),
        ],
      ),
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.userInfo, style: Theme.of(context).textTheme.titleMedium),
            gapH12,
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 20),
                gapW8,
                Text(email, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangePasswordSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ChangePasswordSection> createState() => _ChangePasswordSectionState();
}

class _ChangePasswordSectionState extends ConsumerState<_ChangePasswordSection> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _submitted = false;
  var _obscureCurrent = true;
  var _obscureNew = true;
  var _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await ref.read(changePasswordControllerProvider.notifier).changePassword(
          currentPassword: _currentPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        );

    if (mounted && !ref.read(changePasswordControllerProvider).hasError) {
      _formKey.currentState?.reset();
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() => _submitted = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe mis à jour.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    ref.listen(changePasswordControllerProvider, (_, state) => state.showSnackBarOnError(context));
    final state = ref.watch(changePasswordControllerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.changePassword, style: Theme.of(context).textTheme.titleMedium),
              gapH16,
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: s.currentPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                obscureText: _obscureCurrent,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) => !_submitted
                    ? null
                    : (v?.isEmpty ?? true)
                        ? s.passwordEmpty
                        : null,
              ),
              gapH12,
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: s.newPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                obscureText: _obscureNew,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) {
                  if (!_submitted) return null;
                  if (v == null || v.isEmpty) return s.passwordEmpty;
                  if (v.length < 8) return s.passwordTooShort;
                  return null;
                },
              ),
              gapH12,
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: s.confirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                obscureText: _obscureConfirm,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) {
                  if (!_submitted) return null;
                  if (v != _newPasswordController.text) return s.passwordsDoNotMatch;
                  return null;
                },
              ),
              gapH16,
              PrimaryButton(
                text: s.save,
                onPressed: state.isLoading ? null : _submit,
                width: double.infinity,
                isLoading: state.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DangerZoneSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);

    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.deleteAccount,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
            ),
            gapH12,
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                backgroundColor: Colors.transparent,
              ),
              onPressed: () => _showDeleteConfirm(context, ref, s),
              child: Text(s.deleteAccount),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirm(BuildContext context, WidgetRef ref, AppStrings s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.deleteAccountConfirmTitle),
        content: Text(s.deleteAccountConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(s.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(authRepositoryProvider) as FirebaseAuthRepository;
      await repo.deleteAccount();
    }
  }
}
