import 'package:ChatGemini/env/env.dart';
// import 'package:ChatGemini/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_language_api/google_generative_language_api.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ChatGemini/providers/parameter_provider.dart';

class ApiIntegrationWidget extends ConsumerStatefulWidget {
  const ApiIntegrationWidget({Key? key}) : super(key: key);

  @override
  _ApiIntegrationWidgetState createState() => _ApiIntegrationWidgetState();
}

class _ApiIntegrationWidgetState extends ConsumerState<ApiIntegrationWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _promptInputController = TextEditingController();
  final TextEditingController _promptOutputController = TextEditingController();
  String mdText = "";

  void updateText(String newText) {
    setState(() {
      mdText = newText;
    });
  }

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
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: MarkdownBody(
                      data: mdText,
                      selectable: true,
                      onTapLink: (text, href, title) {
                        if (href != null) {
                          launchUrl(Uri.parse(href));
                        }
                      },
                      styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(color: Colors.red, fontSize: 24),
                        h2: const TextStyle(color: Colors.orange, fontSize: 20),
                        p: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      final text = _promptOutputController.text;
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to Clipboard')));
                    },
                    child: const Icon(Icons.copy_rounded),
                  ),
                ),
              ],
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
                    maxLines: 50,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
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
                      hintText: "Input text",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 75.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.background,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    generateTextWithPrompt(
                        promptString: _promptInputController.text);
                  },
                  child: const Text('Ask'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<String> generateTextWithPrompt({
    required String promptString,
  }) async {
    final gemini = Gemini.instance;
    try {
      final value = await gemini.text(promptString);
      print(value?.output); // or value?.content?.parts?.last.text
      _promptOutputController.text = value?.output ?? '';
      updateText(_promptOutputController.text);
      return _promptOutputController.text;
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
