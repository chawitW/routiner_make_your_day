import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_1/main.dart';
import 'package:project_1/provider/google_sign_in.dart';
import 'package:project_1/widget/background_painter.dart';
// import 'package:project_1/widget/logged_in_widget.dart';
import 'package:project_1/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);

              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return HomePage();
              } else {
                return SignUpWidget();
              }
            },
          ),
        ),
      );

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}