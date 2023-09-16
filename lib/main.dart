import 'package:codelab_dart3_patterns/utils.dart';
import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //=========Records=========
    //* Accessing the record as using the record as a type
    final metadataRecord = document.metadata;

    //* $1 is the first data type of the record
    //* This is how you access positional fields
    metadataRecord.$1; // Gets the title

    //* In comparison from the above, the named parameter record "modified"
    //* uses its named parameter as the property name to access it below
    //* This is how you access named fields
    metadataRecord.modified; // Gets the DateTime modified

    //* Accessing a record by destructuring its data into variables
    final (title, :modified) = document
        .metadata; //* Shorthand method - works when field name and variable name are the same
    //* You can use _ to ignore title or modified, use modified: _ to ignore that

    // final (title, modified: modified) = document.metadata; //* Another way of accessing it

    //* In the example above, destructuring the variables from the record is an example of
    //* an irrefutable pattern. This means that the data type of the record's field must match
    //* the type you're trying to destructure
    //=========Records=========

    final blocks = document.getBlocks();

    final formattedModifiedDate = modified.timeAgoFromNowText;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            'Last modified $formattedModifiedDate',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: ((context, index) {
                return BlockWidget(block: blocks[index]);
              }),
            ),
          )
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    required this.block,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        HeaderBlock(:final text) => Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ParagraphBlock(:final text) => Text(text),
        CheckboxBlock(:final text, :final isChecked) => Row(
            children: [
              Checkbox(value: isChecked, onChanged: (_) {}),
              Text(text),
            ],
          ),
      },
    );
  }
}

//* Implementation of BlockWidget using switch statements based on type which is a String type
class OldBlockWidget extends StatelessWidget {
  final OldBlock block;

  const OldBlockWidget({
    required this.block,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = getTextStyleUsingSwitchExpression(context);
    return Container(
      margin: const EdgeInsets.all(0),
      child: Text(
        block.text,
        style: textStyle,
      ),
    );
  }

  ///Returns a [TextStyle] using a switch statement
  TextStyle? getTextStyleUsingSwitchStatement(BuildContext context) {
    TextStyle? textStyle;

    switch (block.type) {
      case 'h1':
        textStyle = Theme.of(context).textTheme.displayMedium;
      //* New with pattern matching, you can use || and && in a case
      case 'p' || 'checkbox':
        textStyle = Theme.of(context).textTheme.bodyMedium;
      //* Also new with pattern matching, which is the wildcard
      //* this is effectively the default case which is less verbose
      case _:
        textStyle = Theme.of(context).textTheme.bodySmall;
    }
    return textStyle;
  }

  ///Returns a [TextStyle] using the new switch expression
  TextStyle? getTextStyleUsingSwitchExpression(BuildContext context) {
    TextStyle? textStyle;
    textStyle = switch (block.type) {
      'h1' => Theme.of(context).textTheme.displayMedium,
      'p' || 'checkbox' => Theme.of(context).textTheme.bodyMedium,
      _ => Theme.of(context).textTheme.bodySmall
    };
    return textStyle;
  }
}
