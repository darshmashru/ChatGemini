import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ApiIntegrationWidget extends StatefulWidget {
  const ApiIntegrationWidget({super.key});

  @override
  _ApiIntegrationWidgetState createState() => _ApiIntegrationWidgetState();
}

class _ApiIntegrationWidgetState extends State<ApiIntegrationWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _promptInputController = TextEditingController();
  final ScrollController _outputScrollController = ScrollController();
  String mdText = "";
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _errorMessage;
  bool _isLoading = false;
  late bool _isAsking;

  @override
  void initState() {
    super.initState();
    _isAsking = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                            maxWidth: MediaQuery.of(context).size.width - 16,
                            maxHeight: 300,
                          ),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        ),
                      ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    MarkdownBody(
                      data: _isLoading ? mdText : mdText,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed:
                        _isAsking ? _stopAsking : (_isLoading ? null : _ask),
                    tooltip: 'Stop/Ask',
                    child: _isLoading || _isAsking
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow),
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
                  onPressed: _isLoading || _isAsking ? null : _ask,
                  child: _isLoading || _isAsking
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
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

  Future<void> _ask() async {
    final text = _promptInputController.text;
    if (_imageBytes != null) {
      await _generateTextWithImage();
    } else {
      await _generateText();
    }
  }

  Future<void> _generateText() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
      mdText = '';
    });

    try {
      final gemini = Gemini.instance;
      final result = await gemini.text(_promptInputController.text);
      setState(() {
        mdText = result?.output ?? 'No output';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error generating text: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateTextWithImage() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
      mdText = '';
    });

    try {
      final gemini = Gemini.instance;
      final result = await gemini.textAndImage(
        text: _promptInputController.text,
        images: [_imageBytes!],
      );
      setState(() {
        mdText = result?.content?.parts?.last.text ?? 'No output';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error generating text with image: $e';
        _isLoading = false;
      });
    }
  }

  void _stopAsking() {
    setState(() {
      _isAsking = false;
    });
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

  Future<void> _copyText() async {
    await Clipboard.setData(ClipboardData(text: mdText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
