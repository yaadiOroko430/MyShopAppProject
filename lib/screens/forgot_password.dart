import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.resetPassword(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset email sent!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains('@')
                    ? 'Invalid email'
                    : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Send Reset Email'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}