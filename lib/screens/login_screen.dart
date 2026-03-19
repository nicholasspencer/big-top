import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/auth_provider.dart';
import '../services/github_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DeviceCodeResponse? _deviceCode;
  bool _polling = false;
  String? _error;

  Future<void> _startLogin() async {
    setState(() {
      _error = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final deviceCode = await authProvider.startDeviceFlow();
      setState(() {
        _deviceCode = deviceCode;
      });

      // Open the verification URL
      final uri = Uri.parse(deviceCode.verificationUri);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      // Start polling
      setState(() {
        _polling = true;
      });
      await authProvider.pollForToken(deviceCode);
      if (mounted) {
        setState(() {
          _polling = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _polling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StateNotifierBuilder<AuthState>(
      stateNotifier: context.read<AuthProvider>(),
      builder: (context, authState, _) {
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
                      if (_deviceCode != null) ...[
                        Text(
                          'Enter this code on GitHub:',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: _deviceCode!.userCode),
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
                              _deviceCode!.userCode,
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
                            final uri =
                                Uri.parse(_deviceCode!.verificationUri);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text('Open github.com/login/device'),
                        ),
                        if (_polling) ...[
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
                          onPressed:
                              authState.isLoading ? null : _startLogin,
                          icon: const Icon(Icons.login),
                          label: authState.isLoading
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
                      if (_error != null || authState.error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error ?? authState.error ?? '',
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
