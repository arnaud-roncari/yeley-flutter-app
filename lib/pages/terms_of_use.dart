import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/commons/constants.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kScaffoldBackground,
        appBar: AppBar(
          backgroundColor: kMainGreen,
          title: const Text('Conditions générales d\'utilisation'),
        ),
        body: SfPdfViewer.network(
          "$kApiUrl/legalities/terms-of-use",
        ),
      ),
    );
  }
}