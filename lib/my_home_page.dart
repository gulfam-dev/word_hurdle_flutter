import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle_flutter/helper_functions.dart';
import 'package:word_hurdle_flutter/hurdle_provider.dart';
import 'package:word_hurdle_flutter/keyboard_view.dart';
import 'package:word_hurdle_flutter/wordle_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Hurdle'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemCount: provider.hurdleBoard.length,
                  itemBuilder: (context, index) {
                    final wordle = provider.hurdleBoard[index];
                    return WordleView(wordle: wordle);
                  },
                ),
              ),
            ),
          ),
          Consumer<HurdleProvider>(
            builder: (context, provider, child) => KeyboardView(
              onPressed: (value) {
                provider.inputLetter(value);
              },
              excludedLetters: provider.excludedLetters,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Consumer<HurdleProvider>(
              builder: (context, provider, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      provider.deleteLetter();
                    },
                    child: Text('Delete'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _handleInput(provider);
                    },
                    child: Text('SUBMIT'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _handleInput(HurdleProvider provider) {
    if (!provider.isAValidWord) {
      showMsg(context, "Word is not in my Dictionary");
      return;
    }
    if (provider.shouldCheckedForAnswer) {
      provider.checkAnswer();
    }
    if (provider.wins) {
      showResult(
        context: context,
        title: 'You Win!!!',
        body: "The word was ${provider.targetWord}",
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    } else if (provider.noAttemptsLeft) {
      showResult(
        context: context,
        title: 'You Lost!!',
        body: 'The word was ${provider.targetWord}',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    }
  }
}
