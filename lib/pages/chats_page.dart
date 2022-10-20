import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/pages/chat_page.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/providers/chats_page_provider.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:chatify_app/widgets/custom_list_view_tile.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authP;
  late ChatsPageProvider _pageProvider;
  late NavigationService _navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _authP = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_authP),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatsPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.02,
          vertical: _deviceHeight * 0.03,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              "Chats",
              primaryAction: IconButton(
                onPressed: () {
                  _authP.logout();
                },
                icon: Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
              ),
            ),
            _chatsList(),
          ],
        ),
      );
    });
  }

  Widget _chatsList() {
    List<Chat>? _chats = _pageProvider.chats;

    return (() {
      if (_chats != null) {
        if (_chats.length != 0) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _chats.length,
            itemBuilder: (BuildContext _context, int _index) {
              return _chatTile(_chats[_index]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
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
    })();
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser>? _recepients = _chat.recepients();
    bool isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subtitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      title: _chat.title(),
      subtitle: _subtitleText,
      imagePath: _chat.imageURL(),
      isActive: isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigateToPage(
          ChatPage(chat: _chat),
        );
      },
    );
  }
}
