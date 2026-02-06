import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/design_system.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final TextEditingController _urlController = TextEditingController();
  List<Map<String, String>> _discoveredServers = [];
  bool _isScanning = false;
  late Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  void _startDiscovery() {
    setState(() => _isScanning = true);
    _scanLocalNetwork();
    
    // Scan every 5 seconds for new servers
    _scanTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _scanLocalNetwork();
    });
  }

  Future<void> _scanLocalNetwork() async {
    try {
      // Get local IP range
      final interfaces = await NetworkInterface.list();
      final List<Map<String, String>> found = [];

      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            // Scan /24 subnet (common for LAN)
            final parts = addr.address.split('.');
            if (parts.length == 4) {
              final subnet = '${parts[0]}.${parts[1]}.${parts[2]}';
              // Try common ports where sharEngine might be running
              for (int i = 1; i <= 255; i += 20) {
                // Skip local IP
                if (i.toString() == parts[3]) continue;
                
                final ip = '$subnet.$i';
                try {
                  // Fast timeout - just check if port is open
                  final socket = await Socket.connect(ip, 8080, timeout: const Duration(milliseconds: 500));
                  await socket.close();
                  
                  // If we can connect, try to get session info
                  try {
                    final client = HttpClient();
                    client.connectionTimeout = const Duration(milliseconds: 500);
                    final request = await client.getUrl(Uri.parse('http://$ip:8080/session'));
                    final response = await request.close();
                    
                    if (response.statusCode == 200) {
                      final body = await response.transform(utf8.decoder).join();
                      found.add({
                        'ip': ip,
                        'port': '8080',
                        'name': 'Serveur SHAREL',
                        'info': body,
                      });
                    }
                    client.close();
                  } catch (_) {
                    // Server found but session endpoint failed
                    found.add({
                      'ip': ip,
                      'port': '8080',
                      'name': 'Serveur SHAREL',
                      'info': '',
                    });
                  }
                } catch (_) {
                  // Connection failed, skip
                }
              }
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          _discoveredServers = found;
          if (found.isEmpty && !_isScanning) {
            _isScanning = false;
          }
        });
      }
    } catch (e) {
      // Silently fail discovery
    }
  }

  void _connectToServer(String ip, String port) {
    final url = 'http://$ip:$port';
    context.push('/transfer/join', extra: url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Découvrir des serveurs'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? AppTheme.spacing16 : AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scan status
            Container(
              padding: EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.12),
                    theme.colorScheme.primary.withValues(alpha: 0.04),
                  ],
                ),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  if (_isScanning)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                      ),
                    )
                  else
                    Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 24),
                  SizedBox(width: AppTheme.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isScanning ? 'Recherche en cours...' : 'Recherche terminée',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${_discoveredServers.length} serveur(s) trouvé(s)',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppTheme.spacing24),

            // Discovered servers list
            if (_discoveredServers.isNotEmpty) ...[
              Text(
                'Serveurs disponibles',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: AppTheme.spacing12),
              ..._discoveredServers.map((server) {
                return GestureDetector(
                  onTap: () => _connectToServer(server['ip']!, server['port']!),
                  child: Container(
                    margin: EdgeInsets.only(bottom: AppTheme.spacing12),
                    padding: EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                      border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppTheme.spacing8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              ),
                              child: Icon(Icons.cloud, color: theme.colorScheme.primary),
                            ),
                            SizedBox(width: AppTheme.spacing12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    server['name']!,
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '${server['ip']}:${server['port']}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: AppTheme.spacing24),
            ],

            // Manual entry
            Text(
              'Ou saisir manuellement',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AppTheme.spacing12),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'http://192.168.x.x:8080',
                prefixIcon: Icon(Icons.link, color: theme.colorScheme.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
            SizedBox(height: AppTheme.spacing12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_urlController.text.isNotEmpty) {
                    context.push('/transfer/join', extra: _urlController.text);
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Connecter'),
              ),
            ),

            SizedBox(height: AppTheme.spacing24),

            // QR scan button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/transfer/scan'),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scanner un QR code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
