import 'package:flutter/material.dart';
import 'package:word_hurdle_flutter/wordle.dart';

class WordleView extends StatelessWidget {
  final Wordle wordle;
  const WordleView({super.key, required this.wordle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: wordle.existsInTarget
              ? Colors.white60
              : wordle.doesNotExistsInTarget
                  ? Colors.blueGrey.shade700
                  : null,
          border: Border.all(color: Colors.amber, width: 1.5)),
      child: Text(
        wordle.letter,
        style: TextStyle(
          fontSize: 15,
          color: wordle.existsInTarget
              ? Colors.black
              : wordle.doesNotExistsInTarget
                  ? Colors.white54
                  : Colors.white,
        ),
      ),
    );
  }
}
