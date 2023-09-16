extension DateTimeStringX on DateTime {
  ///Formats the given [DateTime] into a String based on its difference from now
  String get timeAgoFromNowText {
    final today = DateTime.now();
    final diff = difference(today);

    return switch (diff) {
      //* Checks if diff (which is a type of Duration) has the same `inDays` value
      Duration(inDays: 0) => 'today',
      Duration(inDays: 1) => 'tomorrow',
      Duration(inDays: -1) => 'yesterday',

      //* Uses a guard clause with the `when` keyword
      //* Checks the condition only if the pattern matches the case
      //* In this case, diff has a value of `inDays` so it matches.
      //* Since it matches, if the value is greater or less than 7
      //* Then use weeks ago instead of days ago
      Duration(inDays: final days) when days > 7 =>
        '${days ~/ 7} weeks from now', // Add from here
      Duration(inDays: final days) when days < -7 =>
        '${days.abs() ~/ 7} weeks ago',

      //* Checks if diff has `isNegative` to true and uses the value of `inDays` as output
      Duration(inDays: final days, isNegative: true) =>
        '${days.abs()} days ago',
      //* Last case to use by just matching with if `inDays` has value
      Duration(inDays: final days) => '$days from now',
    };
  }
}
