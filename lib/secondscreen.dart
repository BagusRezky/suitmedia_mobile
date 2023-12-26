import 'package:flutter/material.dart';
import 'package:suitmedia_mobile/thirdscreen.dart';

class SecondScreen extends StatefulWidget {
  final String userName;

  const SecondScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String selectedUserName = "Selected User Name";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Second Screen',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.blue)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('Welcome'),
            // const SizedBox(height: 10),
            Text(
              widget.userName,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black),
            ),
            const Spacer(),

            Center(
              child: Text(
                selectedUserName,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.black),
              ),
            ),
            const Spacer(),

            InkWell(
              onTap: () async {
                final selectedName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThirdScreen(
                      onUserSelected: (selectedUser) {
                        setState(() {
                          selectedUserName = selectedUser;
                        });
                      },
                    ),
                  ),
                );
                // Handle the selectedName if needed
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xff2B637B),
                ),
                child: const Center(
                  child: Text(
                    'Choose a User',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
