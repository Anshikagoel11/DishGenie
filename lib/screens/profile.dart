import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishgenie/auth/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _email = '';
  String _joinDate = '';
  bool _isLoading = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNotificationPref();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('userEmail') ?? 'No email found';
      _joinDate = _formatJoinDate(prefs.getString('joinDate'));
      _isLoading = false;
    });
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _saveNotificationPref(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  String _formatJoinDate(String? timestamp) {
    if (timestamp == null) return 'Joined recently';

    try {
      final date = DateTime.parse(timestamp);
      return 'Joined ${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Joined recently';
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color.fromARGB(255, 239, 133, 27),
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 239, 236, 236),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange[100],
                            border: Border.all(
                              color: Colors.orange[400]!,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.orange[600],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        Text(
                          _email,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Join Date
                        Text(
                          _joinDate,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Details Card
                  _buildDetailCard(
                    icon: Icons.account_circle,
                    title: 'Account Details',
                    items: [
                      _buildDetailItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: _email,
                      ),
                      _buildDetailItem(
                        icon: Icons.calendar_today,
                        label: 'Member Since',
                        value: _joinDate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // App Settings Card
                  _buildDetailCard(
                    icon: Icons.settings,
                    title: 'App Settings',
                    items: [
                      _buildDetailItem(
                        icon: Icons.notifications,
                        label: 'Notifications',
                        value: _notificationsEnabled ? 'Enabled' : 'Disabled',
                        isToggle: true,
                        initialValue: _notificationsEnabled,
                        onToggle: (value) => _saveNotificationPref(value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Actions Card
                  _buildDetailCard(
                    icon: Icons.more_horiz,
                    title: 'More',
                    items: [
                      _buildActionItem(
                        icon: Icons.help,
                        label: 'Help & Support',
                        onTap: () {},
                      ),
                      _buildActionItem(
                        icon: Icons.privacy_tip,
                        label: 'Privacy Policy',
                        onTap: () {},
                      ),
                      _buildActionItem(
                        icon: Icons.star,
                        label: 'Rate App',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        side: BorderSide(color: Colors.red[300]!),
                      ),
                      onPressed: _logout,
                      child: const Text(
                        'LOGOUT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.orange[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isToggle = false,
    bool initialValue = false,
    Function(bool)? onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.orange[600],
            size: 22,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isToggle)
            Switch(
              value: initialValue,
              activeColor: Colors.orange[600],
              onChanged: onToggle,
            ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.orange[600],
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }
}
