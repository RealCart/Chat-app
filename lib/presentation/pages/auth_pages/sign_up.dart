import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 180.0),
            TextFormField(
              decoration: InputDecoration(label: Text("Email")),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(label: Text("Password")),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(onPressed: () {}, child: Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
