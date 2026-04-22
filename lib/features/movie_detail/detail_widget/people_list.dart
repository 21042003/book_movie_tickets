import 'package:flutter/material.dart';

class PeopleList extends StatelessWidget {
  const PeopleList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          width: 150,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey, radius: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text('Robert Downey Jr.', style: TextStyle(color: Colors.white, fontSize: 12), maxLines: 2),
              )
            ],
          ),
        ),
      ),
    );
  }
}