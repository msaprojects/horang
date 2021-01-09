// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:horang/api/models/chat/chat_model.dart';
// import 'package:horang/api/models/chat/user.dart';
// import 'package:horang/component/chat/chat_page.dart';
// import 'package:scoped_model/scoped_model.dart';

// class ShowAllChat extends StatefulWidget {
//   @override
//   _ShowAllChatState createState() => _ShowAllChatState();
// }

// class _ShowAllChatState extends State<ShowAllChat> {
//   @override
//   void initState() {
//     super.initState();
//     ScopedModel.of<ChatModel>(context, rebuildOnChange: false).init();
//   }

//   void friendClicked(User friend) {
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (BuildContext context) {
//         return ChatPage(friend);
//       }),
//     );
//   }

//   Widget buildAllChatList(){
//     return ScopedModelDescendant<ChatModel>(
//       builder: (context, child, model){
//         return ListView.builder(
//           itemCount: model.friendList.length,
//           itemBuilder: (BuildContext context, int index){
//             User friend = model.friendList[index];
//             return ListTile(
//               title: Text(friend.name),
//               onTap: ()=>friendClicked(friend),
//             );
//           });
//       });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All Chats'),
//       ),
//       body: buildAllChatList(),
//     );
//   }
// }
