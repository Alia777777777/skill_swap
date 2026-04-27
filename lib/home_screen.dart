import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/api_model.dart';

class HomeScreen extends StatefulWidget {
  final String userType;
  HomeScreen({required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  String query = "";

  List<ApiModel> users = [];
  bool isLoading = true;

  List<Map<String, dynamic>> posts = [];
  final TextEditingController postController = TextEditingController();

  final Color primary = Color(0xFF44ACFF);
  final Color secondary = Color(0xFF647FBC);

  final Map<String, dynamic> myProfile = {
    "name": "Alia Tariq",
    "type": "Student",
    "rating": 4,
    "skills": ["Flutter", "UI Design", "Data Analyst"],
  };

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    try {
      var result = await ApiService.getUsers();
      setState(() {
        users = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = users
        .where((u) =>
            u.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final pages = [homePage(filtered), postsPage(), myProfilePage()];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              "Skill Swap",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "assets/logo.png",
                    width: 22,
                    height: 22,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: primary,
        unselectedItemColor: secondary.withOpacity(0.6),
        onTap: (i) => setState(() => index = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "Posts"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget homePage(List<ApiModel> users) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        TextField(
          onChanged: (val) => setState(() => query = val),
          decoration: InputDecoration(
            hintText: "Search to Swapppp...",
            prefixIcon: Icon(Icons.search, color: primary),
            filled: true,
            fillColor: primary.withOpacity(0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Suggested Peoples",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        SizedBox(height: 10),
        ...users.map((u) => userCard(u)).toList(),
      ],
    );
  }

  Widget userCard(ApiModel user) {
    return Card(
      child: ListTile(
        title: Text(user.name, style: TextStyle(color: primary)),
        subtitle: Text(user.username, style: TextStyle(color: secondary)),
        trailing: Icon(Icons.arrow_forward_ios, color: primary),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
          );
        },
      ),
    );
  }

  Widget postsPage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: postController,
                  decoration: InputDecoration(
                    hintText: "Write a post...",
                    filled: true,
                    fillColor: primary.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: primary),
                onPressed: () {
                  if (postController.text.isNotEmpty) {
                    setState(() {
                      posts.insert(0, {
                        "name": myProfile["name"],
                        "text": postController.text,
                        "likes": 0,
                      });
                      postController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  title: Text(posts[i]["name"],
                      style: TextStyle(color: primary)),
                  subtitle: Text(posts[i]["text"]),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite_border, color: secondary),
                    onPressed: () {
                      setState(() {
                        posts[i]["likes"] =
                            (posts[i]["likes"] ?? 0) + 1;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget myProfilePage() {
    final int rating = myProfile["rating"] as int;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: primary.withOpacity(0.1),
            child: Icon(Icons.person, size: 55, color: primary),
          ),
          SizedBox(height: 10),
          Text(
            myProfile["name"],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          Text(myProfile["type"], style: TextStyle(color: secondary)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Icon(
                i < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: (myProfile["skills"] as List)
                .map(
                  (s) => Chip(
                    label: Text(s.toString()),
                    backgroundColor: primary.withOpacity(0.1),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final ApiModel user;

  ProfileScreen({required this.user});

  final Color primary = Color(0xFF44ACFF);
  final Color secondary = Color(0xFF647FBC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name), backgroundColor: primary),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primary.withOpacity(0.1),
              child: Icon(Icons.person, color: primary),
            ),
            SizedBox(height: 10),
            Text(user.username, style: TextStyle(color: secondary)),
            SizedBox(height: 15),

            ListTile(
              leading: Icon(Icons.phone, color: primary),
              title: Text(user.phone),
            ),

            SizedBox(height: 25),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: Size(double.infinity, 45),
              ),
              icon: Icon(Icons.chat),
              label: Text("Send Message"),
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Opening chat")));
              },
            ),

            SizedBox(height: 10),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondary,
                minimumSize: Size(double.infinity, 45),
              ),
              icon: Icon(Icons.video_call),
              label: Text("Video Call"),
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Starting video call")));
              },
            ),

            SizedBox(height: 10),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: Size(double.infinity, 45),
              ),
              icon: Icon(Icons.swap_horiz),
              label: Text("Send Swap Request"),
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Swap Request Sent")));
              },
            ),
          ],
        ),
      ),
    );
  }
}