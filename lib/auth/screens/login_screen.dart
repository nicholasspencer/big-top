import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:big_top/core/async_value.dart';
import '../models/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(
      authRepo: context.read<AuthRepository>(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _startLogin() async {
    // Listen for device code to open URL
    late final Function() removeListener;
    removeListener = _viewModel.addListener((loginState) {
      if (loginState.deviceCode != null) {
        removeListener();
        final uri = Uri.parse(loginState.deviceCode!.verificationUri);
        canLaunchUrl(uri).then((canLaunch) {
          if (canLaunch) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        });
      }
    });
    await _viewModel.startLogin();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authValue = context.watch<AsyncValue<AuthSession>>();
    final isAuthLoading =
        authValue is AsyncValueWaiting || authValue is AsyncValueActive;
    final authError = authValue.error?.toString();

    return StateNotifierBuilder<LoginState>(
      stateNotifier: _viewModel,
      builder: (context, loginState, _) {
        return Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.festival,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text('Big Top', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in with GitHub to continue',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (loginState.deviceCode != null) ...[
                        Text(
                          'Enter this code on GitHub:',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                  text: loginState.deviceCode!.userCode),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Code copied!')),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SelectableText(
                              loginState.deviceCode!.userCode,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(
                                loginState.deviceCode!.verificationUri);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text('Open github.com/login/device'),
                        ),
                        if (loginState.isPolling) ...[
                          const SizedBox(height: 24),
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Waiting for authorization...',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ] else ...[
                        FilledButton.icon(
                          onPressed: isAuthLoading ? null : _startLogin,
                          icon: const Icon(Icons.login),
                          label: isAuthLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Sign in with GitHub'),
                        ),
                      ],
                      if (loginState.error != null ||
                          authError != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          loginState.error ?? authError ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
