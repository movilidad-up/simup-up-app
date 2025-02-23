import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignatureFormView extends StatefulWidget {
  @override
  _SignatureFormViewState createState() => _SignatureFormViewState();
}

class _SignatureFormViewState extends State<SignatureFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _documentNumberController =
      TextEditingController();
  bool _isSignatureDrawn = false;
  String? _documentType;
  String? _role;
  int _currentStep = 0;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    _signatureController.addListener(() {
      setState(() {
        _isSignatureDrawn = !_signatureController.isEmpty;
      });
    });
  }

  InputDecoration _buildDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      hintText: labelText,
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 0.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 0.0),
      ),
      border: const OutlineInputBorder(),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState?.validate() == true) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1 && !_signatureController.isEmpty) {
      setState(() => _currentStep++);
      _saveSignature();
    }
  }

  // Save encrypted Virtual Signature (form data + drawn signature)
  Future<void> _saveSignature() async {
    try {
      // Get signature image as Uint8List
      final Uint8List? signatureData = await _signatureController.toPngBytes();
      if (signatureData == null) return;

      // Convert signature image to Base64
      final String signatureBase64 = base64Encode(signatureData);

      // Create JSON object with user data and signature
      final Map<String, dynamic> signatureObject = {
        "name": _nameController.text.trim(),
        "lastName": _surnameController.text.trim(),
        "documentType": _documentType,
        "documentNumber": _documentNumberController.text.trim(),
        "academicProgram": _role,
        "signatureImage": signatureBase64,
      };

      // Convert JSON to string
      final String jsonData = jsonEncode(signatureObject);

      // Get or generate encryption key
      final key = await _getEncryptionKey();
      final encryptedData = _encryptData(jsonData, key);

      // Get local storage path
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/virtual_signature.enc';

      // Save encrypted data to file
      final file = File(filePath);
      await file.writeAsBytes(encryptedData);

      print("Virtual Signature saved successfully at: $filePath");
    } catch (e) {
      print("Error saving Virtual Signature: $e");
    }
  }

// Encrypt data with AES
  Uint8List _encryptData(String data, encrypt.Key key) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final iv = encrypt.IV.fromLength(16); // Random IV for security
    final encrypted = encrypter.encrypt(data, iv: iv);

    // Store IV + Encrypted data
    return Uint8List.fromList(iv.bytes + encrypted.bytes);
  }

// Get or generate encryption key
  Future<encrypt.Key> _getEncryptionKey() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedKey = prefs.getString('signature_key');

    if (storedKey == null) {
      final key = encrypt.Key.fromSecureRandom(32); // AES-256 key
      await prefs.setString('signature_key', key.base64);
      return key;
    }
    return encrypt.Key.fromBase64(storedKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                centerTitle: true,
                elevation: 4,
                shadowColor: Colors.grey[100]!,
                backgroundColor: Theme.of(context).colorScheme.surface,
                scrolledUnderElevation: 0.4,
                title: Text(
                  AppLocalizations.of(context)!.attendance,
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
                      if (_currentStep == 1) {
                        // Go back to Step 0 without clearing the fields
                        setState(() => _currentStep = 0);
                      } else {
                        // User is leaving the form, reset all fields
                        _nameController.clear();
                        _surnameController.clear();
                        _documentNumberController.clear();
                        _documentType = null;
                        _role = null;
                        _formKey.currentState?.reset();
                        Navigator.of(context).pop();
                      }
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
                            (_currentStep == 0) ? AppLocalizations.of(context)!.digitalSignature : AppLocalizations.of(context)!.drawSignature,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            (_currentStep == 0) ? AppLocalizations.of(context)!.digitalSignatureInfo : AppLocalizations.of(context)!.drawSignatureInfo,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _currentStep == 0
                      ? _buildUserInfoForm()
                      : _currentStep == 1
                          ? _buildSignaturePad()
                          : _buildSuccessScreen(),
                  VerticalSpacing(16.0)
                ]),
              ),
            ],
          ),
        ));
  }

  Widget _buildUserInfoForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: _buildDecoration("Nombre"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),
            VerticalSpacing(16.0),
            TextFormField(
              controller: _surnameController,
              decoration: _buildDecoration("Apellido"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),
            VerticalSpacing(16.0),
            DropdownButtonFormField<String>(
              value: _documentType,
              decoration: _buildDecoration("Tipo de Documento"),
              items: ["CC", "TI", "Pasaporte"]
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => _documentType = value),
              validator: (value) => value == null ? "Required" : null,
            ),
            VerticalSpacing(16.0),
            TextFormField(
              controller: _documentNumberController,
              decoration: _buildDecoration("Número de Documento"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),
            VerticalSpacing(16.0),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: _buildDecoration("Afiliación"),
              items: ["Estudiante", "Profesor"]
                  .map((role) =>
                      DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (value) => setState(() => _role = value),
              validator: (value) => value == null ? "Required" : null,
            ),
            VerticalSpacing(16.0),
            PrimaryButton(
              onButtonPressed: () {
                if (_formKey.currentState?.validate() == false) {
                  setState(() {});
                } else {
                  _nextStep();
                }
              },
              buttonText: "Continuar",
              isButtonEnabled: _nameController.text.isNotEmpty &&
                  _surnameController.text.isNotEmpty &&
                  _documentType != null &&
                  _documentNumberController.text.isNotEmpty &&
                  _role != null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignaturePad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Signature(
          controller: _signatureController,
          height: 200,
          backgroundColor: Colors.grey[200]!,
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _signatureController.clear();
                setState(() => _isSignatureDrawn = false); // Ensure UI updates
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: Text("Clear Signature", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isSignatureDrawn ? _nextStep : null,
              child: Text("Save & Continue"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.allDone,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            VerticalSpacing(8.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                AppLocalizations.of(context)!.allDoneInfo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            VerticalSpacing(16.0),
            PrimaryButton(
              onButtonPressed: () => Navigator.pop(context),
              buttonText: "Return to Dashboard",
              hasPadding: false,
              isButtonEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
