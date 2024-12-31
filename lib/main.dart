import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_chat/chat.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ChatSample(),
        ),
      )));
}

class ChatSample extends StatefulWidget {
  const ChatSample({super.key});

  @override
  State<ChatSample> createState() => ChatSampleState();
}

class ChatSampleState extends State<ChatSample> {
  late List<ChatMessage> _messages;

  @override
  void initState() {
    _messages = <ChatMessage>[
      ChatMessage(
        text: 'Hi! How are you?',
        time: DateTime.now(),
        author: const ChatAuthor(
          id: '8ob3-b720-g9s6-25s8',
          name: 'Outgoing user name',
        ),
      ),
      ChatMessage(
        text: 'Fine, how about you?',
        time: DateTime.now(),
        author: const ChatAuthor(
          id: 'a2c4-56h8-9x01-2a3d',
          name: 'Incoming user name',
          avatar: AssetImage('images/People_Circle2.png'),
        ),
      ),
      ChatMessage(
        text:
            'I’ve been doing well. I’ve started working on a new project recently.',
        time: DateTime.now(),
        author: const ChatAuthor(
          id: '8ob3-b720-g9s6-25s8',
          name: 'Outgoing user name',
        ),
      ),
      ChatMessage(
        text:
            'That sounds great! I’ve been exploring a few new frameworks myself.',
        time: DateTime.now(),
        author: const ChatAuthor(
          id: 'a2c4-56h8-9x01-2a3d',
          name: 'Incoming user name',
          avatar: AssetImage('images/People_Circle2.png'),
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80, right: 80, bottom: 20),
      child: SfChat(
        messages: _messages,
        outgoingUser: '8ob3-b720-g9s6-25s8',
        incomingBubbleSettings: ChatBubbleSettings(
          showTimestamp: false,
          showUserName: false,
          textStyle: TextStyle(color: Colors.white),
          contentPadding:
              EdgeInsets.only(top: 15, bottom: 30, left: 30, right: 30),
          contentBackgroundColor: Colors.green[600],
          contentShape: CustomBorderShape(isOutgoing: false),
        ),
        outgoingBubbleSettings: ChatBubbleSettings(
            showTimestamp: false,
            showUserName: false,
            showUserAvatar: false,
            textStyle: TextStyle(color: Colors.white),
            contentPadding:
                EdgeInsets.only(top: 15, bottom: 30, left: 30, right: 30),
            contentBackgroundColor: Colors.deepPurple[600],
            contentShape: CustomBorderShape(isOutgoing: true)),
        composer: const ChatComposer(
          decoration: InputDecoration(
            hintText: 'Type a message',
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}

class CustomBorderShape extends ShapeBorder {
  final bool isOutgoing;
  final double borderRadius;
  final double tailHeight;

  const CustomBorderShape({
    required this.isOutgoing,
    this.borderRadius = 30.0,
    this.tailHeight = 15.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double bottom = rect.bottom - tailHeight;
    final double adjustedRadius =
        borderRadius.clamp(0, (rect.width / 3).clamp(0, rect.height / 3));
    final path = Path();

    path.addRRect(
      RRect.fromLTRBAndCorners(
        rect.left,
        rect.top,
        rect.right,
        bottom,
        topLeft: Radius.circular(adjustedRadius),
        bottomLeft: Radius.circular(adjustedRadius),
        topRight: Radius.circular(adjustedRadius),
        bottomRight: Radius.circular(adjustedRadius),
      ),
    );

    final tailStartX =
        isOutgoing ? rect.right - adjustedRadius : rect.left + adjustedRadius;
    final tailEndX = isOutgoing
        ? rect.right - adjustedRadius * 1.4
        : rect.left + adjustedRadius * 1.5;

    path.moveTo(tailStartX, bottom);
    path.quadraticBezierTo(
      isOutgoing
          ? rect.right - adjustedRadius * 1.2
          : rect.left + adjustedRadius * 1.2,
      bottom + tailHeight * 0.5,
      tailStartX,
      bottom + tailHeight,
    );
    path.lineTo(tailEndX, bottom);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }
}
