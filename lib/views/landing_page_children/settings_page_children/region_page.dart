import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/region_raw_data.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/services/dashboard_services/region_service.dart';

class RegionPage extends StatefulWidget {
  RegionPage({Key? key}) : super(key: key);
  static final RegionRawData regionRaw = RegionRawData.instance;
  static final RegionService _service = RegionService.loneInstance;

  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  late final TextEditingController _name;
  bool _isLoading = false;
  // Map? _body;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _name = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          children: [
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Régions",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    IconButton(
                      tooltip: "Ajouter un nouveau région",
                      onPressed: () {
                        GeneralTemplate.showDialog(
                          context,
                          child: Column(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(
                                      primaryColor: Palette.gradientColor[0]),
                                  child: TextField(
                                    controller: _name,
                                    cursorColor: Palette.gradientColor[0],
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.drive_file_rename_outline),
                                        labelText: "Nom",
                                        hintText: "Nouveau région nom",
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _name.clear();
                                            });
                                          },
                                          icon: Icon(Icons.clear_all),
                                        )),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        color: Colors.grey.shade200,
                                        child: Center(
                                          child: Text(
                                            "ANNULER",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_name.text.isNotEmpty) {
                                            Navigator.of(context).pop(null);
                                            setState(() => _isLoading = true);
                                            await RegionPage._service.create(
                                              context,
                                              {
                                                "name": _name.text,
                                              },
                                            ).whenComplete(() => setState(
                                                () => _isLoading = false));
                                          }
                                        },
                                        color: Palette.gradientColor[0],
                                        child: Center(
                                          child: Text(
                                            "SOUMETTRE",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                letterSpacing: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          width: size.width,
                          height: 180,
                          title: ListTile(
                            leading: Icon(
                              Icons.add,
                              color: Palette.gradientColor[0],
                            ),
                            title: Text(
                                "Ajouter un nouveau région".toUpperCase(),
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        );
                      },
                      icon: Icon(Icons.add),
                    )
                  ],
                )),
            Expanded(
              child: StreamBuilder<List<RegionModel>>(
                stream: RegionPage.regionRaw.stream$,
                builder: (_, snapshot) => snapshot.hasData && !snapshot.hasError
                    ? ListView.builder(
                        itemBuilder: (_, index) => ListTile(
                          leading: Icon(Icons.account_balance),
                          title: Text("${snapshot.data![index].name}"),
                          trailing: IconButton(
                            onPressed: () async {
                              setState(() => _isLoading = true);
                              await RegionPage._service
                                  .delete(snapshot.data![index].id)
                                  .whenComplete(
                                      () => setState(() => _isLoading = false));
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        itemCount: snapshot.data!.length,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            )
          ],
        ),
        _isLoading ? GeneralTemplate.loader(size) : Container()
      ],
    );
  }
}
