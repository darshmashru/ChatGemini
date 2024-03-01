import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ApiIntegrationWidget extends ConsumerStatefulWidget {
  const ApiIntegrationWidget({Key? key}) : super(key: key);

  @override
  _ApiIntegrationWidgetState createState() => _ApiIntegrationWidgetState();
}

class _ApiIntegrationWidgetState extends ConsumerState<ApiIntegrationWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _promptInputController = TextEditingController();
  final ScrollController _outputScrollController = ScrollController();
  String mdText = "";
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes; // Use Uint8List for image bytes
  String? _errorMessage;
  bool _isLoading = false; // Add this variable to track loading state

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adjust padding as needed
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                controller: _outputScrollController,
                child: Column(
                  children: [
                    if (_imageBytes != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width -
                                16, // Adjust the width as needed
                            maxHeight: 300, // Adjust the height as needed
                          ),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        ),
                      ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    MarkdownBody(
                      data: mdText,
                      selectable: true,
                      onTapLink: (text, href, title) {
                        if (href != null) {
                          launchUrl(Uri.parse(href));
                        }
                      },
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: _pickImage,
                    tooltip: 'Pick Image',
                    child: const Icon(Icons.add_a_photo),
                  ),
                ),
                if (_imageBytes != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: _removeImage,
                      tooltip: 'Remove Image',
                      child: const Icon(Icons.remove),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: _isLoading ? null : _copyText,
                    tooltip: 'Copy Text',
                    child: const Icon(Icons.copy),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 290.0,
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      controller: _promptInputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Input text or Ask with an image",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.background,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _isLoading ? null : () {
                    if (_imageBytes != null) {
                      _generateTextWithImage();
                    } else {
                      _generateText();
                    }
                  },
                  child: _isLoading
                      ? SizedBox(
                          width: 20.0, // Adjust the width as needed
                          height: 20.0, // Adjust the height as needed
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0, // Decrease the stroke width
                          ),
                        )
                      : const Text('Ask'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _generateText() async {
    final text = _promptInputController.text;
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true; // Set loading state to true
    });

    try {
      final gemini = Gemini.instance;
      final result = await gemini.text(text);
      setState(() {
        mdText = result?.output ?? 'No output';
        _isLoading = false; // Set loading state to false after completion
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error generating text: $e';
        _isLoading = false; // Set loading state to false on error
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _errorMessage = null;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
    });
  }

  Future<void> _generateTextWithImage() async {
    if (_imageBytes == null) {
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true; // Set loading state to true
    });

    try {
      final gemini = Gemini.instance;
      final result = await gemini.textAndImage(
        text: _promptInputController.text,
        images: [_imageBytes!],
      );
      setState(() {
        mdText = result?.content?.parts?.last.text ?? 'No output';
        _isLoading = false; // Set loading state to false after completion
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error generating text with image: $e';
        _isLoading = false; // Set loading state to false on error
      });
    }
  }

  Future<void> _copyText() async {
    await Clipboard.setData(ClipboardData(text: mdText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
