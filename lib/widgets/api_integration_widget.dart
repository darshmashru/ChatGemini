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

class _ApiIntegrationWidgetState extends ConsumerState<ApiIntegrationWidget> with AutomaticKeepAliveClientMixin {
  final TextEditingController _promptInputController = TextEditingController();
  final ScrollController _outputScrollController = ScrollController();
  String mdText = "";
  bool _isLoading = false; // Loading Variable
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes; // Use Uint8List for image bytes

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                if (_isLoading)
                  const Positioned.fill(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                SingleChildScrollView(
                  controller: _outputScrollController,
                  child: Column(
                    children: [
                      if (_imageBytes != null) 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 16, // Adjust the width as needed
                              maxHeight: 300, // Adjust the height as needed
                            ),
                            child: Image.memory(_imageBytes!, fit: BoxFit.cover),
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
                          p: TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: mdText));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to Clipboard')));
                    },
                    child: const Icon(Icons.copy_rounded),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _pickImage,
              tooltip: 'Pick Image',
              child: const Icon(Icons.add_a_photo),
            ),
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
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    controller: _promptInputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Input text or Ask with an image",
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  if (_imageBytes != null) {
                    _generateTextWithImage();
                  } else {
                    _generateText();
                  }
                },
                child: const Text('Ask'),
              ),
            ],
          )
        ],
      ),
    );
  }


  Future<void> _generateText() async {
    final text = _promptInputController.text;
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final gemini = Gemini.instance;
      final result = await gemini.text(text);
      setState(() {
        mdText = result?.output ?? 'No output';
      });
    } catch (e) {
      setState(() {
        mdText = 'Error generating text: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _generateTextWithImage() async {
    if (_imageBytes == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final gemini = Gemini.instance;
      final result = await gemini.textAndImage(
        text: _promptInputController.text,
        images: [_imageBytes!],
      );
      setState(() {
        mdText = result?.content?.parts?.last.text ?? 'No output';
      });
    } catch (e) {
      setState(() {
        mdText = 'Error generating text with image: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
