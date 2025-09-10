import 'package:flutter/material.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class ClientAndTeleHealthConsentPage extends StatefulWidget {
  @override
  _ClientAndTeleHealthConsentPageState createState() =>
      _ClientAndTeleHealthConsentPageState();
}

class _ClientAndTeleHealthConsentPageState
    extends State<ClientAndTeleHealthConsentPage> {
  PdfViewerController _pdfViewerController = PdfViewerController();
  Uint8List? _pdfData;
  // ProfileController profileController = Get.find();
  @override
  void initState() {
    super.initState();
    loadPdfFromAssets();
  }

  Future<void> loadPdfFromAssets() async {
    final ByteData bytes = await rootBundle
        .load('assets/pdf/client_Terms_and_Telehealth_Consent.pdf');
    setState(() {
      _pdfData = bytes.buffer.asUint8List();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Terms and Telehealth Consent',
      ),
      body: _pdfData == null
          ? Center(child: CircularProgressIndicator())
          : SfPdfViewer.memory(
              _pdfData!,
              controller: _pdfViewerController,
            ),
    );
  }
}
