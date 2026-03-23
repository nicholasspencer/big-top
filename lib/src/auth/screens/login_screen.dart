import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/logger.dart';
import '../repositories/auth_repository.dart';
import '../services/github_auth_service.dart';

const _tag = 'LoginScreen';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isPolling = false;
  DeviceCodeResponse? _deviceCode;
  String? _error;

  Future<void> _startLogin() async {
    Log.d(_tag, 'startLogin tapped');
    setState(() {
      _isLoading = true;
      _error = null;
      _deviceCode = null;
      _isPolling = false;
    });

    final authRepo = context.read<AuthRepository>();

    try {
      Log.d(_tag, 'Calling startDeviceFlow...');
      final deviceCode = await authRepo.startDeviceFlow();
      Log.d(_tag, 'Got device code: ${deviceCode.userCode}');

      if (!mounted) {
        Log.d(_tag, 'Widget unmounted after startDeviceFlow');
        return;
      }
      setState(() {
        _deviceCode = deviceCode;
        _isPolling = true;
      });
      Log.d(_tag, 'setState done — deviceCode set, showing code UI');

      // Launch verification URL
      final uri = Uri.parse(deviceCode.verificationUri);
      final canLaunch = await canLaunchUrl(uri);
      Log.d(_tag, 'canLaunchUrl: $canLaunch');
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Log.d(_tag, 'URL launched');
      }

      // Poll for token
      Log.d(_tag, 'Starting token poll...');
      final success = await authRepo.pollForToken(deviceCode);
      Log.d(_tag, 'Poll result: success=$success');

      if (!mounted) return;
      if (!success) {
        setState(() {
          _isLoading = false;
          _isPolling = false;
          _deviceCode = null;
          _error = 'Authorization expired or denied. Try again.';
        });
      }
      // If success, the router redirect handles navigation.
    } catch (e) {
      Log.e(_tag, 'startLogin error', e);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isPolling = false;
        _deviceCode = null;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    if (_isPolling) ...[
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
                      onPressed: _isLoading ? null : _startLogin,
                      icon: const Icon(Icons.login),
                      label: _isLoading
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
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
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
  }
}
