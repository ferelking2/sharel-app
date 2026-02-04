import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _urlCtrl = TextEditingController();
  
  // Simulated list of discovered servers (en MVP, vide)
  final List<Map<String, String>> discoveredServers = [];

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Découvrir envoyeurs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Envoyeurs découverts', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            if (discoveredServers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text('Aucun envoyeur trouvé sur le réseau'),
                    const Text('(En attente de broadcast mDNS)', style: TextStyle(fontSize: 12)),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: discoveredServers.length,
                  itemBuilder: (context, idx) {
                    final srv = discoveredServers[idx];
                    return ListTile(
                      title: Text(srv['name'] ?? 'Envoyeur'),
                      subtitle: Text(srv['address'] ?? ''),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Se connecter au serveur découvert
                        context.go('/transfer/client', extra: srv['address']);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            Divider(),
            const SizedBox(height: 20),
            Text('Ou collez l\'adresse manuellement :', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            TextField(
              controller: _urlCtrl,
              decoration: InputDecoration(
                hintText: 'http://192.168.x.x:xxxx',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final url = _urlCtrl.text.trim();
                  if (url.isNotEmpty) {
                    context.go('/transfer/client', extra: url);
                  }
                },
                icon: const Icon(Icons.input),
                label: const Text('Se connecter'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final result = await context.push<String>('/transfer/scan');
                  if (result != null) {
                    context.go('/transfer/client', extra: result);
                  }
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scanner QR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
