import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // In _handleGoogleSignIn() method
  void _handleGoogleSignIn() async {
    try {
      await GoogleSignIn().signOut();
      await AuthService.signInWithGoogle();
    } catch (e) {
      String errorMessage = 'Sign-in failed';

      if (e.toString().contains('12500')) {
        errorMessage = 'Google Play Services error';
      } else if (e.toString().contains('12501')) {
        errorMessage = 'Sign-in canceled';
      } else if (e.toString().contains('10')) {
        errorMessage = 'Network error';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _submitLoginForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AuthService.getErrorMessage(e))));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: _submitLoginForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: Text('Login', style: TextStyle(fontSize: 16)),
                        ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen(),
                            ),
                          ),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey[300]),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: Image.asset('assets/google_logo.png', width: 24),
                      label: Text('Continue with Google'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 14),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegisterScreen(),
                                ),
                              ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
}
