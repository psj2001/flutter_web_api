import 'package:flutter/material.dart';
import 'package:flutter_web_api/Model.dart';
import 'package:flutter_web_api/api_handler.dart';

class FindUser extends StatefulWidget {
  const FindUser({super.key});

  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  void findUser(int userId) async {
    user = await apiHandler.getUserById(userId: userId);
    setState(() {});
  }

  TextEditingController textEditingController = TextEditingController();
  ApiHandler apiHandler = ApiHandler();
  User user = User.empty();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          color: Colors.grey,
          textColor: Colors.white,
          onPressed: () {
            findUser(int.parse(textEditingController.text));
          },
          child: const Text("Find"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  label: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
              controller: textEditingController,
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, width: 2), // Border color and width
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: ListTile(
                leading: Text(
                  "${user.userId}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  '${user.name}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  '${user.address}',
                  style: TextStyle(
                    color: Colors.white,
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
