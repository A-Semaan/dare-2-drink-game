import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/data/dare-card-model.dart';
import 'package:daretodrink/db-ops/db-manager.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPersonalizedDare extends StatefulWidget {
  DareCardModel? card;
  AddPersonalizedDare({Key? key, this.card}) : super(key: key);

  @override
  State<AddPersonalizedDare> createState() => _AddPersonalizedDareState();
}

class _AddPersonalizedDareState extends State<AddPersonalizedDare> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _subText = "";
  int? _amount;
  CardType? _cardType;
  Level? _level;
  @override
  void initState() {
    if (widget.card != null) {
      loadCardData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Add Personalized Dare",
          style: TextStyle(color: MyTheme.secondaryColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.save),
          label: const Text("Save"),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              int result = await save();
              if (result > 0) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Something went wrong while inserting'),
                  ),
                );
              }
            }
          }),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the Title',
                      ),
                      initialValue: _title,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                  ),
                ),
                Material(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the Subtitle',
                      ),
                      initialValue: _subText,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _subText = value!;
                      },
                    ),
                  ),
                ),
                Material(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the Amount of Shots',
                      ),
                      initialValue: (_amount ?? 0).toString(),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the amount of shots';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _amount = int.parse(value!);
                      },
                    ),
                  ),
                ),
                Material(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<Level>(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Select Level',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a Level';
                            }
                            return null;
                          },
                          value: _level,
                          onSaved: (value) {
                            _level = value;
                          },
                          items: Level.values
                              .map<DropdownMenuItem<Level>>(
                                  (e) => DropdownMenuItem<Level>(
                                        child: Text(
                                          e.asString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        value: e,
                                      ))
                              .toList(),
                          onChanged: (onChanged) {
                            _level = onChanged!;
                          })),
                ),
                Material(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<CardType>(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Select Type',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: _cardType,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a Type';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _cardType = value;
                          },
                          items: CardType.values
                              .map<DropdownMenuItem<CardType>>(
                                  (e) => DropdownMenuItem<CardType>(
                                        child: Text(
                                          e.asString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        value: e,
                                      ))
                              .toList(),
                          onChanged: (onChanged) {
                            _cardType = onChanged!;
                          })),
                ),
              ],
            ),
          )),
    );
  }

  Future<int> save() async {
    DareCardModel cardModel = DareCardModel(_title, _cardType!,
        subText: _subText, level: _level, amount: _amount);
    if (widget.card != null) {
      cardModel.id = widget.card!.id;
      return await DBManager.instance.updateSideDare(cardModel);
    } else {
      return await DBManager.instance.insertCardIntoSideDares(cardModel);
    }
  }

  loadCardData() {
    _title = widget.card!.text;
    _subText = widget.card!.subText!;
    _amount = widget.card!.amount;
    _cardType = widget.card!.type;
    _level = widget.card!.level;
  }
}
