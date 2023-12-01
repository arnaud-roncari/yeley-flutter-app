import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/commons/constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: kMainGreen,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Politique de confidentialité',
                    style: kBold16,
                  ),
                  const Spacer()
                ],
              ),
            ),
            Expanded(
              child: SfPdfViewer.network(
                "$kApiUrl/legalities/privacy-policy",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
