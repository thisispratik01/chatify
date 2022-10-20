import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/providers/chat_page_provider.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:chatify_app/widgets/custom_input_fields.dart';
import 'package:chatify_app/widgets/custom_list_view_tile.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authP;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  late ChatPageProvider _pageProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _authP = Provider.of<AuthenticationProvider>(context);
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
              this.widget.chat.uid, _authP, _messagesListViewController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight,
              width: _deviceWidth * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    this.widget.chat.title(),
                    fontSize: 20,
                    primaryAction: IconButton(
                      onPressed: () {
                        _pageProvider.deleteChat();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {
                        _pageProvider.goBack();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.length != 0) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messagesListViewController,
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              ChatMessage _message = _pageProvider.messages![_index];

              bool _isOwnMessage = _message.senderID == _authP.user.uid;

              return Container(
                child: CustomChatListViewTile(
                    width: _deviceWidth * 0.80,
                    deviceHeight: _deviceHeight,
                    isOwnMessage: _isOwnMessage,
                    message: _message,
                    sender: this
                        .widget
                        .chat
                        .members
                        .where((_m) => _m.uid == _message.senderID)
                        .first),
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "Be first to say hi !",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.04, vertical: _deviceHeight * 0.03),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.55,
      child: CustomTextFormField(
          onSaved: (_value) {
            _pageProvider.message = _value;
          },
          regEx: r"^(?!\s*$).+",
          hintText: "Type a message",
          contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
          maxLines: 2,
          obscureText: false,
          textInputAction: TextInputAction.next),
    );
  }

  Widget _sendMessageButton() {
    double size = _deviceHeight * 0.05;
    return GestureDetector(
      onTap: () {
        if (_messageFormState.currentState!.validate()) {
          _messageFormState.currentState!.save();
          _pageProvider.sendTextMessage();
          _messageFormState.currentState!.reset();
        }
        // print("tapped");
      },
      child: Container(
        height: size,
        width: size,
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.05;

    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        onPressed: () {
          // print("gggffddd hello");

          _pageProvider.sendImageMessage();
        },
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        child: Icon(
          Icons.camera_enhance,
          color: Colors.white,
        ),
      ),
    );
  }
}
