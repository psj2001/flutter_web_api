import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_web_api/Model.dart';
import 'package:flutter_web_api/add%20user%20data.dart';
import 'package:flutter_web_api/api_handler.dart';
import 'package:flutter_web_api/find%20user.dart';
import 'edit page.dart';

// Override to handle self-signed certificates
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Apply the override
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(), // Ensure MainApp is wrapped in MaterialApp
    );
  }
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ApiHandler apiHandler = ApiHandler();
  late List<User> data = [];
  bool isLoading = true; // Loading state

  // Fetch data from the API
  void getdata() async {
    setState(() {
      isLoading = true; // Show loader during refresh
      data.clear(); // Clear existing data during refresh
    });
    try {
      data = await apiHandler.getUserData();
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false; // Hide loader after refresh
      });
    }
  }

  void deleteUser(int userId) async {
    await apiHandler.deleteUser(userId: userId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getdata(); // Fetch data initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 1,
            backgroundColor: Colors.grey,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUser(), // Navigate to AddUser screen
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 2,
            backgroundColor: Colors.grey,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FindUser(), // Navigate to AddUser screen
                ),
              );
            },
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text(
          'Note',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : data.isEmpty
              ? const Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Edit_page(
                                user: data[index],
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 2), // Border color and width
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          child: ListTile(
                            tileColor: Colors.black26,
                            leading: Text(
                              "${data[index].userId}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              data[index].name,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              data[index].address,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  deleteUser(data[index].userId);
                                },
                                icon: Icon(Icons.delete)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          color: Colors.grey,
          textColor: Colors.white,
          onPressed: () {
            getdata(); // Refresh data on button click
          },
          child: const Text("Refresh"),
        ),
      ),
    );
  }
}
