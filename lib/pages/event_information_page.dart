import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_study/main.dart';
import 'package:sqflite_study/models/event_model.dart';
import 'package:sqflite_study/pages/add_event_page.dart';
import 'package:sqflite_study/pages/home_page.dart';
import 'package:sqflite_study/sql/sqflite_helper.dart';

class EventInformationPage extends StatefulWidget {
  final int id;
  const EventInformationPage({
    super.key,
    required this.id,
  });

  @override
  State<EventInformationPage> createState() => _EventInformationPageState();
}

class _EventInformationPageState extends State<EventInformationPage> {
  EventModel? event;

  @override
  void initState() {
    super.initState();
    _loadEventInformation();
  }

  Future<void> _loadEventInformation() async {
    final data = await SqlHelper.getItem(widget.id);

    setState(() {
      event = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 320,
              child: Image.network(
                event!.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        AddEvent(event: event)),
                                  ),
                                )
                                .then(
                                  (value) => _loadEventInformation(),
                                );
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: const Text('Deletar evento'),
                                  content: const Text(
                                    'Deseja mesmo apagar este Evento?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Não'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        delete().then(
                                          (value) => Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: ((context) =>
                                                        HomePage()),
                                                  ),
                                                  (route) => false),
                                        );
                                      },
                                      child: const Text('Sim'),
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 35,
                              height: 5,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          event!.title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(event!.date),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            height: 4,
                          ),
                        ),
                        Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: 23),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          event!.description,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            height: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> delete() async {
    await SqlHelper.deleteEvent(event!.id);
  }
}
