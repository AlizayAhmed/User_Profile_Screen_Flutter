import 'package:flutter/material.dart';
import 'screens/user_profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  // Store registered users (in production, use a real database)
  static final Map<String, Map<String, String>> _registeredUsers = {};

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This ensures form is cleared when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Small delay to ensure smooth transition
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _clearForm();
        }
      });
    });
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _nameController.clear();
    _formKey.currentState?.reset();
    setState(() {
      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });
  }

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
      _clearForm();
      _animationController.reset();
      _animationController.forward();
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate network delay for auth
      await Future.delayed(const Duration(milliseconds: 800));

      final String email = _emailController.text.toLowerCase().trim();
      final String password = _passwordController.text;

      if (isLogin) {
        // Login logic
        if (_registeredUsers.containsKey(email)) {
          if (_registeredUsers[email]!['password'] == password) {
            // Successful login
            final userName = _registeredUsers[email]!['name']!;
            setState(() => _isLoading = false);
            _navigateToProfile(userName, email);
          } else {
            // Wrong password
            setState(() => _isLoading = false);
            _showError('Incorrect password. Please try again.');
          }
        } else {
          // User not found
          setState(() => _isLoading = false);
          _showError('No account found with this email. Please sign up.');
        }
      } else {
        // Signup logic
        if (_registeredUsers.containsKey(email)) {
          // Email already exists
          setState(() => _isLoading = false);
          _showError('Account already exists. Please login.');
        } else {
          // Register new user
          final String userName = _nameController.text.trim();
          _registeredUsers[email] = {
            'name': userName,
            'password': password,
          };
          
          setState(() => _isLoading = false);
          _showSuccess('Account created successfully!');
          
          // Auto-navigate to profile after signup
          await Future.delayed(const Duration(milliseconds: 500));
          _navigateToProfile(userName, email);
        }
      }
    }
  }

  void _navigateToProfile(String userName, String userEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(
          userName: userName,
          userEmail: userEmail,
          onLogout: () {
            _clearForm(); // Clear the login/signup form immediately on logout
          },
          onUsernameUpdate: (newName) => _handleUsernameUpdate(userEmail, newName),
        ),
      ),
    );
  }

  void _handleUsernameUpdate(String email, String newName) {
    if (_registeredUsers.containsKey(email)) {
      _registeredUsers[email]!['name'] = newName;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.greenAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E21), Color(0xFF1D1E33), Color(0xFF0A0E21)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Title
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, double value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                        child: const Icon(
                          Icons.flutter_dash,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Welcome Text
                    Text(
                      isLogin ? 'Welcome Back' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLogin
                          ? 'Sign in to continue'
                          : 'Sign up to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Form Card
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D1E33),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Name Field (only for signup)
                            if (!isLogin) ...[
                              _buildTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                icon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email Field
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            // Confirm Password (only for signup)
                            if (!isLogin) ...[
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],

                            // Forgot Password (only for login)
                            if (isLogin) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Password reset feature coming soon!'),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.purpleAccent.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isLoading
                                          ? [
                                              Colors.grey.withOpacity(0.5),
                                              Colors.grey.withOpacity(0.5),
                                            ]
                                          : [
                                              Colors.purpleAccent.withOpacity(0.8),
                                              Colors.blueAccent.withOpacity(0.8),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            isLogin ? 'Sign In' : 'Sign Up',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Toggle Login/Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin
                              ? "Don't have an account? "
                              : "Already have an account? ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: _toggleMode,
                          child: Text(
                            isLogin ? 'Sign Up' : 'Sign In',
                            style: const TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.purpleAccent.withOpacity(0.7)),
        suffixIcon: suffixIcon,
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
    );
  }
}