// import 'dart:convert';

// import 'package:flutter_socket_io/flutter_socket_io.dart';
// import 'package:flutter_socket_io/socket_io_manager.dart';
// import 'package:horang/api/utils/apiService.dart';
// import 'package:scoped_model/scoped_model.dart';

// import './user.dart';
// import './message.dart';

// class ChatModel extends Model {
//   List<User> users = [User('Fadil', '1')];

//   User currentUser;
//   List<User> friendList = List<User>();
//   List<Message> messages = List<Message>();
//   SocketIO socketIO;

//   void init() {
//     currentUser = users[0];
//     friendList =
//         users.where((user) => user.chatID != currentUser.chatID).toList();

//     socketIO = SocketIOManager().createSocketIO(
//         '<ENTER_YOUR_SERVER_URL_HERE>', '/',
//         query: 'chatID=${currentUser.chatID}');
//     socketIO.init();

//     socketIO.subscribe('receive_message', (jsonData) {
//       Map<String, dynamic> data = json.decode(jsonData);
//       messages.add(Message(
//           data['content'], data['senderChatID'], data['receiverChatID']));
//       notifyListeners();
//     });

//     socketIO.connect();
//   }

//   void sendMessage(String text, String receiverChatID) {
//     messages.add(Message(text, currentUser.chatID, receiverChatID));
//     socketIO.sendMessage(
//       'send_message',
//       json.encode({
//         'receiverChatID': receiverChatID,
//         'senderChatID': currentUser.chatID,
//         'content': text,
//       }),
//     );
//     notifyListeners();
//   }

//   List<Message> getMessagesForChatID(String chatID) {
//     return messages
//         .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
//         .toList();
//   }
// }
