import 'package:flutter/material.dart';
import 'package:github_oauth/github_oauth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  final GitHubSignIn githubSignIn = GitHubSignIn(
    clientId: 'Ov23lihlSQEBkPiEoOKH', // clientId buraya
    clientSecret: '9475dc4b4471da6c6598eec1796cdafd924a67d8', // clientSecret buraya
    redirectUrl: 'https://yks-deneme-takip.firebaseapp.com/__/auth/handler', // redirectUrl buraya
  );

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub OAuth Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await githubSignIn.signIn(context);

            if (result.status == GitHubSignInResultStatus.ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Token: ${result.token}')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${result.errorMessage}')),
              );
            }
          },
          child: const Text('Sign in with GitHub'),
        ),
      ),
    );
  }
}
