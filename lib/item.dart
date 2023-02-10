import 'package:flutter/material.dart';

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String heading;
  final String body;

  MessageItem(this.heading, this.body);

  // @override
  // Widget buildTitle(BuildContext context) => Text(sender);

  // @override
  // Widget buildSubtitle(BuildContext context) => Text(body);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}