import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/services/firebase/pets_service.dart';
import 'package:pet_care/logic/services/firebase/user_service.dart';
import 'package:pet_care/logic/services/google_auth_service.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';

class SettingsPage {
  // Provider for fetching user and pet data
  final _fetchUserAndPetDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
    final user = await UserService.getUser();
    final userId = await UserService.getUserUuid();
    final petId = await PetsService().getFirstPetId(userId);

    final dbRef = FirebaseDatabase.instance.ref('userDetails/$userId');
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      return {
        'userName': user?.displayName ?? 'Unknown',
        'userEmail': user?.email ?? 'Unknown',
        'petData': null,
      };
    }

    final userData = snapshot.value as Map<dynamic, dynamic>;
    Map<String, dynamic>? petData;

    if (petId != null) {
      final petSnapshot = await dbRef.child('Pets/$petId/BaseInfo').get();
      final conditionsSnapshot = await dbRef.child('Pets/$petId/HealthConditions').get();

      if (petSnapshot.exists) {
        petData = {
          'name': petSnapshot.child('name').value,
          'breed': petSnapshot.child('breed').value,
          'age': petSnapshot.child('age').value,
          'weight': petSnapshot.child('weight').value,
          'gender': petSnapshot.child('gender').value,
          'conditions': conditionsSnapshot.exists &&
                  conditionsSnapshot.child('hasNoConditions').value == false
              ? (conditionsSnapshot.child('conditions').value as List<dynamic>?)?.cast<String>()
              : null,
        };
      }
    }

    return {
      'userName': userData['name'] ?? user?.displayName ?? 'Unknown',
      'userEmail': userData['email'] ?? user?.email ?? 'Unknown',
      'petData': petData,
    };
  });

  Future<Map<String, dynamic>> _fetchUserAndPetData() async {
    final user = await UserService.getUser();
    final userId = await UserService.getUserUuid();
    final petId = await PetsService().getFirstPetId(userId);

    final dbRef = FirebaseDatabase.instance.ref('userDetails/$userId');
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      return {
        'userName': user?.displayName ?? 'Unknown',
        'userEmail': user?.email ?? 'Unknown',
        'petData': null,
      };
    }

    final userData = snapshot.value as Map<dynamic, dynamic>;
    Map<String, dynamic>? petData;

    if (petId != null) {
      final petSnapshot = await dbRef.child('Pets/$petId/BaseInfo').get();
      final conditionsSnapshot = await dbRef.child('Pets/$petId/HealthConditions').get();

      if (petSnapshot.exists) {
        petData = {
          'name': petSnapshot.child('name').value,
          'breed': petSnapshot.child('breed').value,
          'age': petSnapshot.child('age').value,
          'weight': petSnapshot.child('weight').value,
          'gender': petSnapshot.child('gender').value,
          'conditions': conditionsSnapshot.exists &&
                  conditionsSnapshot.child('hasNoConditions').value == false
              ? (conditionsSnapshot.child('conditions').value as List<dynamic>?)?.cast<String>()
              : null,
        };
      }
    }

    return {
      'userName': userData['name'] ?? user?.displayName ?? 'Unknown',
      'userEmail': userData['email'] ?? user?.email ?? 'Unknown',
      'petData': petData,
    };
  }

  Widget _buildAnimatedCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()..scale(1.0),
      child: Card(
        elevation: 6,
        shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 1),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            shadowColor: color.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: FutureBuilder(
          future: _fetchUserAndPetData(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(
              animating: true,
              radius: 15,
            ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final data = snapshot.data!;
            final userName = data['userName'] ?? 'Unknown';
            final userEmail = data['userEmail'] ?? 'Unknown';
            final petData = data['petData'];

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // User Information Card
                    _buildAnimatedCard(
                      context,
                      title: 'Account Information',
                      icon: Icons.person_rounded,
                      children: [
                        _buildInfoRow(
                          context,
                          icon: Icons.account_circle_outlined,
                          label: 'Name',
                          value: userName,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          context,
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: userEmail,
                        ),
                        const SizedBox(height: 16),
                        _buildActionButton(
                          context,
                          label: 'Log Out',
                          icon: Icons.logout_rounded,
                          color: LightModeColors.secondaryColor,
                          onPressed: () async {
                            final authService = GoogleAuthService();
                            await authService.signOut();
                            if (context.mounted) {
                              context.router.replacePath('/auth');
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Pet Information Card
                    _buildAnimatedCard(
                      context,
                      title: 'Pet Information',
                      icon: Icons.pets_rounded,
                      children: petData != null
                          ? [
                              _buildInfoRow(context, icon: Icons.pets, label: 'Name', value: petData['name']),
                              _buildInfoRow(context, icon: Icons.pets, label: 'Breed', value: petData['breed']),
                              _buildInfoRow(context, icon: Icons.cake_rounded, label: 'Age', value: '${petData['age']} years'),
                              _buildInfoRow(context, icon: Icons.fitness_center_rounded, label: 'Weight', value: '${petData['weight']} kg'),
                              _buildInfoRow(
                                context,
                                icon: Icons.transgender_rounded,
                                label: 'Gender',
                                value: petData['gender'] == 0 ? 'Male' : 'Female',
                              ),
                              _buildInfoRow(
                                context,
                                icon: Icons.local_hospital_rounded,
                                label: 'Health Conditions',
                                value: petData['conditions']?.join(', ') ?? 'None',
                              ),
                              const SizedBox(height: 16),
                              _buildActionButton(
                                context,
                                label: 'Delete Pet data',
                                icon: Icons.delete_rounded,
                                color: LightModeColors.secondaryColor,
                                onPressed: () async {
                                  final userId = await UserService.getUserUuid();
                                  await PetsService().deleteFirstPetId(userId);
                                  
                                  final dbRef = FirebaseDatabase.instance.ref('userDetails/$userId');
                                  await dbRef.update({
                                    'hasPetProfile': false,
                                  });

                                  ref.invalidate(_fetchUserAndPetDataProvider);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Pet deleted successfully'),
                                        backgroundColor: LightModeColors.gradientTeal,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ]
                          : [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No pet profile available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}