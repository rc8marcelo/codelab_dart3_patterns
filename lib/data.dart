export 'block.dart';
import 'dart:convert';

import 'package:codelab_dart3_patterns/block.dart';

class Document {
  final Map<String, Object?> _json;
  Document() : _json = jsonDecode(documentJson);

  //* This return type is a record.
  //* The String is a positional field while
  //* modified is a named field
  /// Returns contents of the JSON below using refutable pattern matching
  (String, {DateTime modified}) get metadata {
    //* This is an if-case statement which only executes when
    //* the case pattern matches the data of _json.
    if (_json
        case {
          'metadata': {
            'title': String title,
            'modified': String localModified,
          },
        }) {
      return (title, modified: DateTime.parse(localModified));
    } else {
      throw const FormatException('Unexpected JSON');
    }
  }

  (String, int, {DateTime modified}) get a =>
      ('a', 2, modified: DateTime.now());

  ///Returns a list of [Block] from the json
  List<Block> getBlocks() {
    //* if-case is checkinf if the json contains a key of "blocks" with a List type
    if (_json case {'blocks': List blocksJson}) {
      //* return a list literal by looping through blocksJson and converting them to a
      //* Block instance
      return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
    } else {
      throw const FormatException('Unexpected JSON format');
    }
  }

  /// Returns contents of the JSON below using the old way of parsing JSON (no patterns used)
  (String, {DateTime modified}) get metadataOld {
    if (_json.containsKey('metadata')) {
      final metadataJson = _json['metadata'];
      if (metadataJson is Map) {
        final title = metadataJson['title'] as String;
        final localModified = DateTime.parse(
          metadataJson['modified'] as String,
        );
        return (title, modified: localModified);
      }
    }
    throw const FormatException('Unexpected JSON');
  }
}

//Replacement for backend data (stubbed)
const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": false,
      "text": "Learn Dart 3"
    }
  ]
}
''';
