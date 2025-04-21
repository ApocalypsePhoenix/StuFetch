import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<FetchScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final user = await UserService.fetchRandomUser();
      setState(() {
        userData = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stu-Fetch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF1A446D),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 131, 197, 255),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Card(
                color: const Color(0xFFF5F7F8),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              "Getting New User...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )
                      : error != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Error: $error',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: fetchUser,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5390BE),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    textStyle: const TextStyle(fontSize: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                ),
                              ],
                            )
                          : UserCard(userData: userData!),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: fetchUser,
          backgroundColor: const Color(0xFF5390BE),
          foregroundColor: Colors.white,
          tooltip: 'Fetch New User',
          child: const Icon(Icons.refresh, size: 30),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final name = userData['name'];
    final picture = userData['picture'];
    final location = userData['location'];
    final dob = userData['dob'];
    final login = userData['login'];

    return Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(picture['large']),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${name['title']} ${name['first']} ${name['last']}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5390BE),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 1),
        Divider(thickness: 1.5, color: Colors.grey[800]),

        _buildListTile('Username', login['username']),
        _buildListTile('Email', userData['email']),
        _buildListTile('Phone', userData['phone']),
        _buildListTile('Gender', userData['gender']),
        _buildListTile(
          'Date of Birth',
          '${DateTime.parse(dob['date']).toLocal().toString().split(' ')[0]} (${dob['age']} years)',
        ),
        _buildListTile(
          'Address',
          '${location['street']['number']} ${location['street']['name']}, ${location['city']}, ${location['state']}, ${location['country']}',
        ),
        _buildListTile('Nationality', userData['nat']),
      ],
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            height: 1.4,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class UserService {
  static Future<Map<String, dynamic>> fetchRandomUser() async {
    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));

      if (response.statusCode == 200) {
        return json.decode(response.body)['results'][0];
      } else {
        throw Exception('Failed to fetch user data');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Something went wrong. Please try again.');
    }
  }
}

// ISAC RUSSELL PAULBERT
// 297454
