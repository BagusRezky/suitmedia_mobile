import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThirdScreen extends StatefulWidget {
  final Function(String) onUserSelected;

  const ThirdScreen({Key? key, required this.onUserSelected}) : super(key: key);

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  late List<User> userList;
  int currentPage = 1;
  int perPage = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userList = [];
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await http.get(Uri.parse(
        'https://reqres.in/api/users?page=$currentPage&per_page=$perPage'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> users = data['data'];
      setState(() {
        userList.addAll(users.map((user) => User.fromJson(user)).toList());
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> _refreshUsers() async {
    setState(() {
      userList.clear();
      currentPage = 1;
    });
    await _fetchUsers();
  }

  Future<void> _loadMoreUsers() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });
      await _fetchUsers();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Third Screen',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: ListView.builder(
          itemCount: userList.length + 1,
          itemBuilder: (context, index) {
            if (index == userList.length) {
              return _buildLoadMoreIndicator();
            } else {
              return _buildUserItem(userList[index]);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserItem(User user) {
    return GestureDetector(
      onTap: () {
        widget.onUserSelected('${user.firstName} ${user.lastName}');
        Navigator.pop(context, '${user.firstName} ${user.lastName}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(user.avatar),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }
}

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}
