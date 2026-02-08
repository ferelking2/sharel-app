import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/design_system.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/');
    }
  }

  void _skipOnboarding() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            children: [
              _buildWelcomeSlide(
                title: t?.labelSend ?? 'Envoyer',
                description: 'Partagez vos fichiers instantanément avec d\'autres appareils via WiFi',
                icon: Icons.send_rounded,
                color: AppColors.sendColor,
              ),
              _buildWelcomeSlide(
                title: t?.labelReceive ?? 'Recevoir',
                description: 'Recevez des fichiers en toute sécurité de vos amis et collègues',
                icon: Icons.cloud_download_rounded,
                color: AppColors.receiveColor,
              ),
              _buildWelcomeSlide(
                title: t?.labelFiles ?? 'Fichiers',
                description: 'Gérez et organisez tous vos fichiers partagés',
                icon: Icons.folder_open_rounded,
                color: AppColors.filesColor,
              ),
              _buildWelcomeSlide(
                title: 'Prêt à commencer?',
                description: 'SHAREL rend le partage de fichiers facile, rapide et sécurisé',
                icon: Icons.check_circle_rounded,
                color: AppColors.primary,
              ),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _skipOnboarding,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                        ),
                        child: const Text('Passer'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == 3 ? 'Démarrer' : 'Suivant',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSlide({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
            ),
            child: Icon(
              icon,
              size: 64,
              color: color,
            ),
          )
              .animate()
              .scale(duration: const Duration(milliseconds: 600))
              .shimmer(duration: const Duration(milliseconds: 1500)),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 400))
              .slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textGrey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.2),
        ],
      ),
    );
  }
}
