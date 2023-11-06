import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/commons/constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMainGreen,
          title: const Text('Politique de confidentialité'),
        ),
        body: SfPdfViewer.network(
          "$kApiUrl/legalities/privacy-policy",
        ),
      ),
    );
  }
}
