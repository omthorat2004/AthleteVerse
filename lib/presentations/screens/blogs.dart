import 'package:flutter/material.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  final List<Blog> blogs = const [
    Blog(
        title: "The Impact of Doping in Sports",
        description:
            "Doping has significantly affected the credibility of various sports. Learn about its impact and regulations.",
        category: "Doping",
        icon: Icons.sports),
    Blog(
        title: "Understanding Personal Finance",
        description:
            "Managing personal finances is crucial for financial stability. Get tips on budgeting, saving, and investing.",
        category: "Finance",
        icon: Icons.attach_money),
    Blog(
        title: "Latest Government Schemes You Should Know",
        description:
            "Stay updated with the latest government schemes that benefit citizens across various sectors.",
        category: "Government Schemes",
        icon: Icons.account_balance),
    Blog(
        title: "Key Rules in Modern-Day Cricket",
        description:
            "Cricket rules have evolved over time. Understand the latest updates and how they impact the game.",
        category: "Sports Rules",
        icon: Icons.sports_cricket),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs"),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          return BlogCard(blog: blogs[index]);
        },
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(
          blog.icon,
          color: Colors.blue,
          size: 40,
        ),
        title: Text(
          blog.title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          blog.description,
          style: const TextStyle(fontSize: 15.0, color: Colors.black54),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            blog.category,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

class Blog {
  final String title;
  final String description;
  final String category;
  final IconData icon;

  const Blog({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
  });
}