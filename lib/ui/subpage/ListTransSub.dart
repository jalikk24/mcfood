import 'package:flutter/material.dart';
import 'package:mcfood/model/ModelHistoryTrans.dart';
import 'package:mcfood/util/CustomColor.dart';
import 'package:mcfood/util/ScreenSize.dart';

class ListTransSub extends StatefulWidget {
  const ListTransSub({Key? key}) : super(key: key);

  @override
  State<ListTransSub> createState() => _ListTransSubState();
}

class _ListTransSubState extends State<ListTransSub> with ChangeNotifier {
  List<ModelHistoryTrans> listTrans = [];
  ValueNotifier<List<ModelHistoryTrans>> valListTrans = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.white,
      appBar: AppBar(
        title: Text(
          "History Transaksi",
          style: TextStyle(
              fontFamily: "inter600",
              fontSize: 15,
              color: CustomColor.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: CustomColor.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: valListTrans.value.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return listItemTrans(index);
                }),
          ),
        ],
      ),
    );
  }

  Widget listItemTrans(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: CustomColor.black, width: 2),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("ID Transaksi : "),
                    Text("${valListTrans.value[index].idTrans}"),
                  ],
                ),
                Text(valListTrans.value[index].date),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(valListTrans.value[index].status),
            ),
            Text("Rp. ${valListTrans.value[index].summary}")
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    setupDummy();
    super.initState();
  }

  void setupDummy() {
    listTrans.add(ModelHistoryTrans(1, "Berhasil", "25/Nov/2022", 20000));
    listTrans.add(ModelHistoryTrans(2, "Berhasil", "25/Nov/2022", 40000));
    listTrans.add(ModelHistoryTrans(3, "Berhasil", "26/Nov/2022", 15000));
    listTrans.add(ModelHistoryTrans(1, "Berhasil", "25/Nov/2022", 20000));
    listTrans.add(ModelHistoryTrans(2, "Berhasil", "25/Nov/2022", 40000));
    listTrans.add(ModelHistoryTrans(3, "Berhasil", "26/Nov/2022", 15000));
    listTrans.add(ModelHistoryTrans(1, "Berhasil", "25/Nov/2022", 20000));
    listTrans.add(ModelHistoryTrans(2, "Berhasil", "25/Nov/2022", 40000));
    listTrans.add(ModelHistoryTrans(3, "Berhasil", "26/Nov/2022", 15000));

    valListTrans.value = listTrans;
  }
}
