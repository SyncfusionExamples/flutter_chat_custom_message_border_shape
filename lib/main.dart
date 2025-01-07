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
    // Initialize the list of chat messages.
    _messages = <ChatMessage>[
      ChatMessage(
        text: 'Hi! How are you?', // Outgoing message.
        time: DateTime.now(),
        author: const ChatAuthor(
          id: '8ob3-b720-g9s6-25s8',
          name: 'Outgoing user name',
        ),
      ),
      ChatMessage(
        text: 'Fine, how about you?', // Incoming message.
        time: DateTime.now(),
        author: const ChatAuthor(
          id: 'a2c4-56h8-9x01-2a3d',
          name: 'Incoming user name',
          avatar: AssetImage('images/People_Circle2.png'),
        ),
      ),
      ChatMessage(
        text: 'I’ve been doing well. I’ve started working on a new project recently.',
        time: DateTime.now(),
        author: const ChatAuthor(
          id: '8ob3-b720-g9s6-25s8',
          name: 'Outgoing user name',
        ),
      ),
      ChatMessage(
        text: 'That sounds great! I’ve been exploring a few new frameworks myself.',
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
        messages: _messages, // Setting the messages list.
        outgoingUser: '8ob3-b720-g9s6-25s8', // Outgoing user ID.
        incomingBubbleSettings: ChatBubbleSettings(
          showTimestamp: false, 
          showUserName: false, 
          textStyle: TextStyle(color: Colors.white), 
          contentPadding: EdgeInsets.only(top: 15, bottom: 30, left: 30, right: 30), // Ensure sufficient space inside the bubble to accommodate the custom tail shape.
          contentBackgroundColor: Colors.green[600], 
          contentShape: CustomBorderShape(isOutgoing: false), // Custom shape for incoming message bubble.
        ),
        outgoingBubbleSettings: ChatBubbleSettings(
          showTimestamp: false, // Disabling the timestamp for a cleaner look.
          showUserName: false, // Disabling the username for a cleaner look.
          showUserAvatar: false, // Disabling the avatar for a cleaner look.
          textStyle: TextStyle(color: Colors.white), 
          contentPadding: EdgeInsets.only(top: 15, bottom: 30, left: 30, right: 30),
          contentBackgroundColor: Colors.deepPurple[600], 
          contentShape: CustomBorderShape(isOutgoing: true), // Custom shape for outgoing message bubble.
        ),
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
  final bool isOutgoing; // Flag to check if the message is outgoing or incoming.
  final double borderRadius; // Border radius for rounded corners.
  final double tailHeight; // Height of the message tail.

  const CustomBorderShape({
    required this.isOutgoing,
    this.borderRadius = 30.0, // Default value for border radius.
    this.tailHeight = 15.0, // Default value for tail height.
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Calculate the bottom of the bubble considering the tail height.
    final double bottom = rect.bottom - tailHeight;
    // Adjust the radius based on width/height for better aesthetics.
    final double adjustedRadius = borderRadius.clamp(0, (rect.width / 3).clamp(0, rect.height / 3));
    // Store left and right positions for reusability.
    final double left = rect.left;
    final double right = rect.right;
    final Path path = Path();

    // Create a rounded rectangle path for the bubble.
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

    // Calculate the start and end positions of the tail based on message type (outgoing/incoming).
    final double tailStartX =
        isOutgoing ? right - adjustedRadius : left + adjustedRadius;
    final double tailEndX = isOutgoing
        ? right - adjustedRadius * 1.4
        : left + adjustedRadius * 1.5;

    // Create the tail using a quadratic bezier curve.
    path.moveTo(tailStartX, bottom);
    path.quadraticBezierTo(
      isOutgoing
          ? right - adjustedRadius * 1.2
          : left + adjustedRadius * 1.2,
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
