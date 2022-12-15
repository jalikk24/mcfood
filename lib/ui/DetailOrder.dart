import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mcfood/helper/FormatCurrency.dart';
import 'package:mcfood/model/ModelCheckout.dart';
import 'package:mcfood/util/CustomColor.dart';
import 'package:mcfood/util/ScreenSize.dart';
import 'package:request_api_helper/session.dart';

class DetailOrder extends StatefulWidget {
  List<ModelCheckout> listOrder = [];
  String alamat;
  String username;

  DetailOrder(
      {Key? key,
      required this.listOrder,
      required this.alamat,
      required this.username})
      : super(key: key);

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> with ChangeNotifier {
  List<ModelCheckout> listOrders = [];
  ValueNotifier<int> valTotPrice = ValueNotifier(0);

  @override
  void initState() {
    listOrders = widget.listOrder;
    countTotPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(
              fontFamily: "inter600", fontSize: 18, color: CustomColor.black),
        ),
        backgroundColor: CustomColor.white,
        leading: BackButton(
          color: CustomColor.black,
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  top: 25,
                  bottom: ScreenSize.getHeight(context) / 10,
                  right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daftar Belanja",
                    style: TextStyle(
                        fontFamily: "inter500",
                        fontSize: 17,
                        color: CustomColor.black),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: listOrders.length,
                      itemBuilder: (context, index) {
                        return listItem(index);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Penerima",
                      style: TextStyle(
                          fontFamily: "inter600",
                          fontSize: 20,
                          color: CustomColor.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.username,
                      style: TextStyle(
                          fontFamily: "inter500",
                          fontSize: 15,
                          color: CustomColor.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Alamat",
                      style: TextStyle(
                          fontFamily: "inter600",
                          fontSize: 20,
                          color: CustomColor.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.alamat,
                      style: TextStyle(
                          fontFamily: "inter500",
                          fontSize: 15,
                          color: CustomColor.black),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            width: ScreenSize.getWidth(context),
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.primary,
                      minimumSize: Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lanjutkan",
                              style: TextStyle(
                                  fontFamily: "inter600",
                                  fontSize: 18,
                                  color: CustomColor.white),
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: valTotPrice,
                              builder: (_, result, __) {
                                return Text(
                                  "Total ${FormatCurrency.convertToIdr(result, 0)}",
                                  style: TextStyle(
                                      fontFamily: "inter600",
                                      fontSize: 12,
                                      color: CustomColor.white),
                                );
                              },
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_sharp)
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget listItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 70,
            color: CustomColor.white,
            child: CachedNetworkImage(imageUrl: listOrders[index].gambar),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(listOrders[index].name,
                          style: TextStyle(
                              fontFamily: "inter600",
                              fontSize: 18,
                              color: CustomColor.black)),
                      Row(
                        children: [
                          Text("Total : ",
                              style: TextStyle(
                                  fontFamily: "inter500",
                                  fontSize: 15,
                                  color: CustomColor.black)),
                          Text(
                            FormatCurrency.convertToIdr(
                                listOrders[index].sum * listOrders[index].price,
                                0),
                            style: TextStyle(
                                fontFamily: "inter600",
                                fontSize: 16,
                                color: CustomColor.black),
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Rp. ${listOrders[index].price}",
                      style: TextStyle(
                          fontFamily: "inter500",
                          fontSize: 15,
                          color: CustomColor.primary),
                    ),
                  ),
                  Text("${listOrders[index].sum} pcs")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void countTotPrice() {
    int result = 0;
    for (int x = 0; x < listOrders.length; x++) {
      result += listOrders[x].price;
    }
    valTotPrice.value = result;
    valTotPrice.notifyListeners();
  }
}
