import 'dart:io';
import 'package:nyxx/nyxx.dart';

void main() async {
  String token = Platform.environment['TOKEN'] ?? '';

  final client = await Nyxx.connectGateway(
    token,
    GatewayIntents.allUnprivileged | GatewayIntents.guilds,
  );

  final bot = await client.users.fetchCurrentUser();
  print("✅ Bot is online");

  // Respond when bot is mentioned
  client.onMessageCreate.listen((event) async {
    if (event.mentions.contains(bot)) {
      await event.message.channel.sendMessage(MessageBuilder(
        content: 'aaok ${event.message.author.username}, How may I help you today',
        replyId: event.message.id,
      ));
    }
  });


client.onChannelCreate.listen((event) async {
  if (event.channel is TextChannel) {
    final textChannel = event.channel as TextChannel;
    try {
      await textChannel.sendMessage(MessageBuilder(content: 
        "## Welcome to DonutShop. Please say what you want and wait for a response. "
        "The current average response time is 1–10 minutes."
      ));
      print("👋 Sent Hi in a new text channel with ID: ${textChannel.id}");
    } catch (e) {
      print("❌ Failed to send message in new channel with ID: ${textChannel.id} - $e");
    }
  }
});


  // Fake Web Server to Keep Render Alive
  var port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  var server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print("🌍 Fake server running on port $port");
  await for (var request in server) {
    request.response
      ..write("Bot is running!")
      ..close();
  }
}
