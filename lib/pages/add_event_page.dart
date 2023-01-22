import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_study/models/event_model.dart';
import 'package:sqflite_study/sql/sqflite_helper.dart';

class AddEvent extends StatefulWidget {
  EventModel? event;
  AddEvent({super.key, this.event});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      DateFormat formater = DateFormat('dd/MM/yyyy');

      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _imageUrlController.text = widget.event!.image;
      selectedDate = formater.parse(widget.event!.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: (() => Navigator.of(context).pop()),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event == null ? 'Add Event' : "Update Event",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Title',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      hintText: 'Enter event title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Description',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter your description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Image',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'image url',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Date',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: DateFormat('dd/MM/yyyy').format(selectedDate),
                    suffixIcon: IconButton(
                      onPressed: () => _showDatePicker(),
                      icon: const Icon(Icons.date_range),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.event == null) {
                            add();
                          } else {
                            update();
                          }
                          Navigator.of(context).pop(true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.event == null
                                    ? "Added event"
                                    : "updated event",
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        widget.event == null ? 'Add' : 'Update',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    ) as DateTime;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> add() async {
    await SqlHelper.createEvent(
      _titleController.text,
      _descriptionController.text,
      _imageUrlController.text,
      DateFormat("dd/MM/yyyy").format(selectedDate),
    );
  }

  Future<void> update() async {
    await SqlHelper.updateEvent(
      widget.event!.id,
      _titleController.text,
      _descriptionController.text,
      _imageUrlController.text,
      DateFormat('dd/MM/yyyy').format(selectedDate),
    );
  }
}
