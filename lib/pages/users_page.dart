import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/providers/users_page_provider.dart';
import 'package:chatify_app/widgets/custom_input_fields.dart';
import 'package:chatify_app/widgets/custom_list_view_tile.dart';
import 'package:chatify_app/widgets/rounded_button.dart';
import 'package:chatify_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authP;
  late UsersPageProvider _usersPageProvider;
  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _authP = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_authP),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _usersPageProvider = _context.watch<UsersPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.02,
          vertical: _deviceHeight * 0.03,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              "Users",
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
            CustomTextField(
              onEditingComplete: (_value) {
                _usersPageProvider.getUsers(name: _value);
                FocusScope.of(context).unfocus();
              },
              hintText: "Search...",
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _usersList(),
            _createChatButton(),
          ],
        ),
      );
    });
  }

  Widget _usersList() {
    List<ChatUser>? _users = _usersPageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              return CustomListViewTile(
                  title: _users[_index].name,
                  subtitle: "Last Active: ${_users[_index].lastDayActive()}",
                  imagePath: _users[_index].imageURL,
                  isActive: _users[_index].wasRecentlyActive(),
                  isSelected:
                      _usersPageProvider.selectedUsers.contains(_users[_index]),
                  height: _deviceHeight * 0.10,
                  onTap: () {
                    _usersPageProvider.updateSelectedUsers(_users[_index]);
                  });
            },
          );
        } else {
          return Center(
            child: Text(
              "No Users Found",
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
    }());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _usersPageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _usersPageProvider.selectedUsers.length == 1
            ? "Chat With ${_usersPageProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _usersPageProvider.createChat();
        },
      ),
    );
  }
}
