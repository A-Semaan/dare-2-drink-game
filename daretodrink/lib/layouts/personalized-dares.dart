import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/data/dare-card-model.dart';
import 'package:daretodrink/db-ops/db-manager.dart';
import 'package:daretodrink/layouts/add-personalized-dare.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonalizedDares extends StatefulWidget {
  const PersonalizedDares({Key? key}) : super(key: key);

  @override
  State<PersonalizedDares> createState() => _PersonalizedDaresState();
}

class _PersonalizedDaresState extends State<PersonalizedDares> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Personalized Dares",
          style: TextStyle(color: MyTheme.secondaryColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("Add"),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => AddPersonalizedDare()))
                .then((value) {
              setState(() {});
            });
          }),
      body: FutureBuilder<List<DareCardModel>>(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              List<DareCardModel> dares = snapshot.data!;

              if (dares.isEmpty) {
                return const Center(
                  child: Text(
                    "There are no side dares yet.\nHook yourself up!",
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              AlertDialog alertDialog = AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: ApplicationProperties
                                        .instance.borderRadius),
                                title: Text(
                                  "Delete Item",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!,
                                ),
                                content: Text(
                                  "Are you sure you want to delete this item",
                                  style:
                                      Theme.of(context).textTheme.displaySmall!,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        await DBManager.instance
                                            .deleteSideDare(dares[index]);
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text(
                                        "Yes",
                                      )),
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text(
                                        "No",
                                      ))
                                ],
                              );
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return alertDialog;
                                  }).then((value) {
                                if (value) {
                                  setState(() {});
                                }
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dares[index].text,
                                style: MyTheme.listTileTitleTheme.copyWith(
                                    color: dares[index].type == CardType.generic
                                        ? MyTheme.secondaryColor
                                        : Theme.of(context).primaryColor),
                              ),
                            ),
                            Text(
                                dares[index].amount != null
                                    ? "Amount: " +
                                        dares[index].amount!.toString()
                                    : "",
                                style: MyTheme.listTileTitleTheme),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  dares[index].subText ?? "",
                                  style: MyTheme.listTileSubtitleTheme,
                                ),
                              ),
                              Text(
                                dares[index].level != null
                                    ? dares[index].level!.asString()
                                    : "",
                                style: MyTheme.listTileSubtitleTheme,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      AddPersonalizedDare(card: dares[index])))
                              .then((value) {
                            setState(() {});
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: dares.length);
              }
            } else {
              return const Center(
                child: Text(
                  "Something went wrong",
                  textAlign: TextAlign.center,
                ),
              );
            }
          }),
    );
  }

  Future<List<DareCardModel>> getData() async {
    return await DBManager.instance.getAllSideDaresAndGenerics();
  }
}
