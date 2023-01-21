import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_study/main.dart';
import 'package:sqflite_study/models/event_model.dart';
import 'package:sqflite_study/pages/add_event_page.dart';
import 'package:sqflite_study/pages/event_information_page.dart';
import 'package:sqflite_study/sql/sqflite_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventModel> _eventsList = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eventos',
        ),
      ),
      body: _eventsList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.event_note_outlined,
                    size: 200,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ainda não existe eventos",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _eventsList.length,
              itemBuilder: (context, index) {
                final event = _eventsList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => EventInformationPage(
                              id: event.id,
                            )),
                      ),
                    ).then(
                      (value) => loadEvents(),
                    );
                  },
                  child: EventItemStyle(event: event),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEvent()),
          ).then(
            (value) => loadEvents(),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<void> loadEvents() async {
    final data = await SqlHelper.getItems();

    setState(() {
      _eventsList = data.map((e) => EventModel.fromJson(e)).toList();
    });
  }
}

class EventItemStyle extends StatelessWidget {
  const EventItemStyle({
    Key? key,
    required this.event,
  }) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Varela,'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(event.date),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
              width: 120,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.network(
                  event.image,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
