import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/screens/profile/member_detail.dart';
import 'package:apple_todo/cloud_functions/analytics_manager.dart';

class Member extends StatefulWidget {
  const Member({super.key});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  final List _members = [
    {
      'name': 'Frederic Davidsen',
      'nim': '211110462',
      'avatar': 'frederic-avatar.jpeg',
      'picture': 'frederic.jpeg',
      'quote': '"The computer was born to solve problems that did not exist before." - Bill Gates'
    },
    {
      'name': 'Novita Adelin Br Lumbantobing',
      'nim': '211111810',
      'avatar': 'novita-avatar.jpeg',
      'picture': 'novita.jpeg',
      'quote': '"Technology empowers people to do what they want to do. It lets people be creative." - Steve Jobs'
    },
    {
      'name': 'Mila Rachma Fika Limbong',
      'nim': '211111750',
      'avatar': 'mila-avatar.jpeg',
      'picture': 'mila.jpeg',
      'quote':
          '"The good news about computers is that they do what you tell them to do. The bad news is that they do what you tell them to do." - Ted Nelson'
    },
  ];

  final AnalyticsManager _analytics = AnalyticsManager();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text('Our Members',
                style: TextStyle(
                  fontSize: 18,
                  color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                )),
          ),
          Divider(
            color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
            indent: 12,
            endIndent: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _members.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: AssetImage('assets/about/${_members[index]['avatar']}')),
                    title: Text(_members[index]['name'], style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                    trailing: Icon(Icons.more_horiz, color: context.watch<TodoProvider>().isDark ? Colors.grey : Colors.black),
                    onTap: () {
                      _analytics.testEventLog('visit_${_members[index]['name'].split(' ')[0]}');

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberDetail(member: _members[index]),
                          ));
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
