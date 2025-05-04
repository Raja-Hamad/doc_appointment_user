import 'dart:convert';

import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class ChatView extends StatefulWidget {
  final String adminId;
  final String adminName;
  final String adminDeviceToken;

  ChatView({required this.adminId, required this.adminName,required this.adminDeviceToken});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController _chatController = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();

  String ?currentUserId; // fetch from auth
  LocalStorage localStorage=LocalStorage();

  String ? currentUserName;

  returnName()async{
currentUserName= await localStorage.getValue("name");

  }
  

  @override
  void initState() {
    super.initState();
      currentUserId=FirebaseAuth.instance.currentUser!.uid;
returnName();
if(kDebugMode){
  print('Name of current user is $currentUserName');
}
    _chatController.startChatStream(currentUserId!, widget.adminId);
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.adminName}")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: _chatController.messages.length,
              itemBuilder: (context, index) {
                var message = _chatController.messages[index];
                bool isMe = message['senderId'] == currentUserId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message['message']),
                  ),
                );
              },
            )),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.trim().isNotEmpty) {
                      await _chatController.sendMessage(
                        currentUserId!,
                        widget.adminId,
                        _messageController.text.trim(),
                      );
                      _messageController.clear();
                      await submitNotification(widget.adminDeviceToken.toString(), "$currentUserName", "Message from $currentUserName");
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "doctor-appointment-app-f73f5",
      "private_key_id": "ff7c5feef5e6ce52c9af45e54e99b6ec76413b7a",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCydfO35Tsf+6i7\nVhJx6kDNxI3O6fq+eoLb/VuVfdCwvJYjjQvu4GfUkEzuS3vUeB0BlLbXJi+tE2Zt\nj9RU+rdNfo8w2YdB9PnIqgTNMuKoDfDR5uaL1CBDGii2GRaLITPDeKiCCIx3y/7X\nLMubAiz76bEfcPY/tq+LKayzVNimrktgq3jhE/C+eKJrWG4R9drLzS+ClIIaRfGa\nhNoA6v8l56HQ7AoIoC77HIcKSuiyOLsaz+VvK2NkVAqT5RtRZioawNtLrW1YYgNO\nLGWLAJDLjGvplqHe/gMgNsCw1CdVEXO+rKy4XBc1TaNe4KohmalYV8Fe9WqeiYtY\nIy9NKkv/AgMBAAECggEAIJNtYKUkbMsoWsH0bfzfxW/anumRDtIYLwYJgLlNreVO\n1sB5bCpkaaXJlToMKZWfXdmCorViwIopCVjW3ohBi5DNnJIooX6RVfLLG5XtT9Xz\nnq0yalXXachNpCfiOJVf+I9+2vWqhnejVi3kILB9+6IF5gJdwPWdB58c2kNjpNEf\nx1IffxEEWgcas28kfQTKVraMafluoTzv6Vxk7yV9627mGanvBvMyZpOPf9W3QQvY\n32RT468IzxIsKL5F6IxfFcLqKPVqnRWR8h3OOUhvQiNDqW4Lde54s+/F2ifXI8zJ\ntRL48xkQp/OfmKgnY7EdpxVxL+Ojlmk2U+TMtVwu+QKBgQDm305yqQyayg+xlFNW\nevVB8HW1o93B/G8uQYW4sp9w1vJ8y0lfLgE82hCAgLP/p08jTU++L/uPBnAumkPV\nsGr7pYDw/KjoIWwRI6q+wcO0fPuvtZ31CcpsbjKq338BgitREJXA84k+BiYdoXND\nebUTvVkP6f9TMGKsUdKAu23vdQKBgQDF4lNmBQBvrP2bjVhsOH87CAwa3gLP5Rji\nPeuAKE1fmGdn0ZH2Db0yauAczkFanSc5iJyms232bqVpQVRvO6DG99QLAnBGaxtf\nao9W/HQfmHIuZXPwAXpoJKRT64gtxUphYgsQs9qJNvAQqIaLUO/KTsS88PPgj7XS\n/vj0By1zIwKBgDg4UqsbPWWIJPAyVWTuxkCLZK6Zu8ucRBq4e+6xGKBqx1vaSQCz\nfDusQm54aNytiljnX67JknGOuMywZipoLnUfJVoJvLviP6Wg0Nho6NZPxR5RlKhx\n/OgQoaf4ir38S74O0tjMtTP0XV3DzgS1Y4HuDv0QF0vTsYOS3TbZ7XhtAoGAPsn4\nwodVwxm2AvSPmQ84N8fu51uIsuSzx530Kt8e5fVa4lNaKCPl46iL4jgD/rec6aGS\na0bF3orvS32iSAU4l8mta6zjaUS1E8qhHu3N/vSFTnl8lyww5fiyd7plpHhUiJ/u\neOdIsX9QH0kKIAyXea8SuA0QpTGUdRXYcr4QStcCgYBI2/5CpWlnvnF2fFogVb/k\nnaouw0Z6ZM1U5THvowM/HXTRfS0Wq5W64TdBkjz7uiuc8lxmouyi8FkUy8LdI4Fw\nVl2Z/h3G1i2uHDyXh8LgjLJeRcLaUP9NzJUecotHe3CI7X8nKAV199gPI9ky9P5G\nDMvs0DC1Zqrhk09zX+Gy8g==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@doctor-appointment-app-f73f5.iam.gserviceaccount.com",
      "client_id": "109067369366173919564",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40doctor-appointment-app-f73f5.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendNotificationToClients(
    String notificationBody,
    String notificationTitle,
    String devicesToken,
  
  ) async {
    final String serverKey = await getAccessToken();

    var notificationData = {
      'message': {
        'token': devicesToken,
        'notification': {
          'title': notificationTitle.toString(),
          'body': notificationBody.toString(),
        },
      },
    };

    var response = await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/doctor-appointment-app-f73f5/messages:send',
      ), // Update YOUR_PROJECT_ID
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $serverKey', // Replace with actual access token
      },
      body: jsonEncode(notificationData),
    );

    // Check response for errors
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print(
        'Error sending notification: ${response.statusCode} - ${response.reasonPhrase}',
      );
      print('Response body: ${response.body}');
    }
  }

  submitNotification(
    String userDeviceToken,
    String notificationTitle,
    String notificationBody,
    
  ) async {
    try {
      if (kDebugMode) {
        print("Device Token of the user is $userDeviceToken");
        print("Notification Title of the user is $notificationTitle");
        print("Notification Body of the user is $notificationBody");
      }
      if (notificationTitle.isNotEmpty && notificationBody.isNotEmpty) {
        await sendNotificationToClients(
          notificationBody,
          notificationTitle,
          userDeviceToken
        
        );
      } else {
        print("Please fill in all fields.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while generating the notification ${e.toString()}");
      }
    }
  }
}
