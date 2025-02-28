import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simup_up/views/components/action_card.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/dashboard_view.dart';
import 'package:simup_up/views/signature_form_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class SignatureView extends StatefulWidget {
  const SignatureView({Key? key}) : super(key: key);

  @override
  State<SignatureView> createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  Map<String, dynamic>? _signatureData;
  bool _isLoading = true;

  Future<void> _loadSignature() async {
    try {
      // Get local storage path
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/virtual_signature.enc';
      final file = File(filePath);

      if (!await file.exists()) {
        setState(() {
          _signatureData = null;
          _isLoading = false;
        });
        return;
      }

      // Read encrypted data from file
      final Uint8List encryptedData = await file.readAsBytes();

      // Get stored encryption key
      final key = await _getEncryptionKey();

      // Decrypt data
      final decryptedData = _decryptData(encryptedData, key);

      // Convert decrypted JSON to Map
      setState(() {
        _signatureData = jsonDecode(decryptedData);
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading Virtual Signature: $e");
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }

  Future<bool> _deleteSignature() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/virtual_signature.enc';
      final file = File(filePath);

      // Delete the encrypted file if it exists
      if (await file.exists()) {
        await file.delete();
      }

      // Remove encryption key from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('signature_key');

      setState(() {
        _signatureData = null; // Clear UI
      });

      return true; // Deletion successful
    } catch (e) {
      print("Error deleting signature: $e");
      return false;
    }
  }

// Decrypt AES-encrypted data
  String _decryptData(Uint8List encryptedData, encrypt.Key key) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    // Extract IV (first 16 bytes)
    final iv = encrypt.IV(Uint8List.fromList(encryptedData.sublist(0, 16)));

    // Extract encrypted text
    final encryptedText =
        encrypt.Encrypted(Uint8List.fromList(encryptedData.sublist(16)));

    // Decrypt
    return encrypter.decrypt(encryptedText, iv: iv);
  }

// Function to retrieve the encryption key
  Future<encrypt.Key> _getEncryptionKey() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedKey = prefs.getString('signature_key');

    if (storedKey == null) {
      throw Exception(
          "Encryption key not found. Signature might not have been set up.");
    }
    return encrypt.Key.fromBase64(storedKey);
  }

  @override
  void initState() {
    super.initState();
    _loadSignature();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              elevation: 4,
              shadowColor: Colors.grey[100]!,
              backgroundColor: Theme.of(context).colorScheme.surface,
              scrolledUnderElevation: 0.4,
              title: Text(
                AppLocalizations.of(context)!.digitalSignature,
                style: Theme.of(context).textTheme.labelLarge,
                textScaler: const TextScaler.linear(1.0),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16.0, left: 24.0, right: 24.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.myDigitalSignature,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        VerticalSpacing(8.0),
                        Text(
                          AppLocalizations.of(context)!.myDigitalSignatureInfo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        VerticalSpacing(16.0),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : _signatureData == null
                                ? ActionCard(
                                    onSchedulesTap: () {
                                      Navigator.of(context).push(
                                          CustomPageRoute(SignatureFormView(
                                            onSignatureSaved: _loadSignature,
                                          )));
                                    },
                                    subtitle: AppLocalizations.of(context)!
                                        .myAttendance,
                                    title: AppLocalizations.of(context)!
                                        .createYourSignature,
                                    isPrimaryAction: true,
                                  )
                                : _buildSignatureDetails(context),
                        VerticalSpacing(16.0),
                        if (_signatureData != null) ...[
                          PrimaryButton(
                            buttonText:
                                AppLocalizations.of(context)!.editSignature,
                            onButtonPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignatureFormView(
                                      signatureData: _signatureData,
                                      onSignatureSaved: _loadSignature,
                                      startStep: 1),
                                ),
                              );
                            },
                            isButtonEnabled: true,
                            hasPadding: false,
                          ),
                          VerticalSpacing(16.0),
                          PrimaryButton(
                            buttonText:
                                AppLocalizations.of(context)!.deleteSignature,
                            onButtonPressed: () async {
                              bool deleted = await _deleteSignature();
                              if (deleted && context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    CustomPageRoute(ShowCaseWidget(
                                      builder: (context) =>
                                          const DashboardView(customIndex: 2),
                                    )),
                                    (Route<dynamic> route) => false);
                              }
                            },
                            isButtonEnabled: true,
                            primaryStyle: false,
                            hasPadding: false,
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                VerticalSpacing(24.0),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureDetails(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetail(context, AppLocalizations.of(context)!.name,
                  _signatureData!['name'] ?? "N/A"),
              _buildDetail(context, AppLocalizations.of(context)!.lastName,
                  _signatureData!['lastName'] ?? "N/A"),
              _buildDetail(context, AppLocalizations.of(context)!.documentType,
                  _signatureData!['documentType'] ?? "N/A"),
              _buildDetail(
                  context,
                  AppLocalizations.of(context)!.documentNumber,
                  _signatureData!['documentNumber'] ?? "N/A"),
              _buildDetail(context, AppLocalizations.of(context)!.affiliation,
                  _signatureData!['academicProgram'] ?? "N/A"),
              VerticalSpacing(4.0),
              Text(AppLocalizations.of(context)!.signature,
                  style: Theme.of(context).textTheme.headlineMedium),
              VerticalSpacing(8.0),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: _signatureData!['signatureImage'] != null
                        ? Image.memory(
                            base64Decode(_signatureData!['signatureImage']))
                        : Text("No signature image available"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textScaler: const TextScaler.linear(1.0),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge,
          textScaler: const TextScaler.linear(1.0),
        ),
        VerticalSpacing(8.0),
      ],
    );
  }
}
