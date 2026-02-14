// widgets/profile_tab.dart
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;
  final Function(String) onUsernameUpdate;

  const ProfileTab({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
    required this.onUsernameUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Profile Picture with user's initials
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.8),
                  Colors.blueAccent.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF1D1E33),
              child: Text(
                _getInitials(userName),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // User's actual name
          Text(
            userName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Username from email
          Text(
            '@${userEmail.split('@')[0]}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 30),
          // Account Information Section
          _buildSectionHeader('Account Information'),
          const SizedBox(height: 12),
          // Email
          _buildInfoCard(
            icon: Icons.email,
            title: 'Email',
            content: userEmail,
          ),
          const SizedBox(height: 12),
          // Member since
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: 'Member Since',
            content: _getMemberSince(),
          ),
          const SizedBox(height: 12),
          // Account Status
          _buildInfoCard(
            icon: Icons.verified_user,
            title: 'Account Status',
            content: 'Active',
            subtitle: 'Your account is in good standing',
          ),
          const SizedBox(height: 30),
          // Quick Actions Section
          _buildSectionHeader('Quick Actions'),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.edit,
            label: 'Edit Username',
            color: Colors.blueAccent,
            onTap: () => _showEditUsernameDialog(context),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.logout,
            label: 'Logout',
            color: Colors.redAccent,
            onTap: onLogout,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showEditUsernameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: userName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.purpleAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Edit Username',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New Username',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.purpleAccent.withOpacity(0.7),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111328),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.purpleAccent.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.trim().length < 2) {
                    return 'Username must be at least 2 characters';
                  }
                  if (value.trim() == userName) {
                    return 'Please enter a different username';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newName = nameController.text.trim();
                Navigator.pop(context);
                onUsernameUpdate(newName);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    
    List<String> parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _getMemberSince() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    String? subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.3),
                  Colors.blueAccent.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.purpleAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}