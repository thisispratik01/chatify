import 'dart:async';

import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/cloud_storage_service.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/media_service.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _authP;
  ScrollController _messageListViewController;

  String _chatID;

  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;

  String? _message;

  String get message {
    return message;
  }

  void set message(String _value) {
    _message = _value;
  }

  ChatPageProvider(this._chatID, this._authP, this._messageListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messagesStream.cancel();
    super.dispose();
  }

  void goBack() {
    _navigation.goBack();
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        type: MessageType.TEXT,
        content: _message!,
        sentTime: DateTime.now(),
        senderID: _authP.user.uid,
      );

      _db.addMessageToChat(_chatID, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL = await _storage.saveChatImageToStorage(
            _chatID, _authP.user.uid, _file);

        ChatMessage _messageToSend = ChatMessage(
          type: MessageType.IMAGE,
          content: _downloadURL!,
          sentTime: DateTime.now(),
          senderID: _authP.user.uid,
        );

        _db.addMessageToChat(_chatID, _messageToSend);
      }
    } catch (e) {
      print("Error sending image message");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatID);
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessageForChat(_chatID).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;

              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          //Add scroll to bottom call
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_messageListViewController.hasClients) {
              _messageListViewController
                  .jumpTo(_messageListViewController.position.maxScrollExtent);
            }
          });
        },
      );
    } catch (e) {
      print("Error getting messages.");
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream =
        _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(
        _chatID,
        {"is_activity": _event},
      );
    });
  }
}
