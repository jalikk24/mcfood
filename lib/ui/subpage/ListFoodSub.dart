import 'package:flutter/material.dart';
import 'package:mcfood/customStyle/CustomDecoration.dart';
import 'package:mcfood/helper/FormatCurrency.dart';
import 'package:mcfood/model/ModelFood.dart';
import 'package:mcfood/model/ModelCheckout.dart';
import 'package:mcfood/ui/DetailOrder.dart';
import 'package:mcfood/util/CustomColor.dart';
import 'package:mcfood/util/ScreenSize.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart'
    as bottomNav;

class ListFoodSub extends StatefulWidget {
  const ListFoodSub({Key? key}) : super(key: key);

  @override
  State<ListFoodSub> createState() => _ListFoodSubState();
}

class _ListFoodSubState extends State<ListFoodSub> with ChangeNotifier {
  ValueNotifier<List<ModelFood>> valListFood = ValueNotifier([]);
  ValueNotifier<List<int>> valListCountItem = ValueNotifier([]);
  ValueNotifier<bool> valIsScroll = ValueNotifier(false);
  ValueNotifier<int> valTot = ValueNotifier(0);
  List<ModelFood> listFood = [];
  List<ModelCheckout> listOrder = [];

  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenSize.getHeight(context) / 14,
                    left: 15,
                    right: 15,
                    bottom: 20),
                child: TextFormField(
                  onChanged: (text) {
                    query = text;
                    search();
                  },
                  style: TextStyle(
                      fontFamily: "inter500",
                      fontSize: 15,
                      color: CustomColor.black),
                  decoration: CustomDecoration()
                      .getFormBorderWithIcon(Icons.search_sharp, "Cari Makanan...", 30, CustomColor.black),
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      //hide
                      valIsScroll.value = false;
                      valIsScroll.notifyListeners();
                      return false;
                    } else {
                      //show
                      if (valTot.value != 0) {
                        valIsScroll.value = true;
                        valIsScroll.notifyListeners();
                        return true;
                      } else {
                        return false;
                      }
                    }
                  },
                  child: ValueListenableBuilder(
                    valueListenable: valListFood,
                    builder: (_, result, __) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: result.length + 1,
                          itemBuilder: (context, index) {
                            return listItemFood(index);
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            width: ScreenSize.getWidth(context),
            bottom: ScreenSize.getHeight(context) / 35,
            child: InkWell(
              onTap: () {
                goOrder();
              },
              child: ValueListenableBuilder(
                valueListenable: valIsScroll,
                builder: (_, isScroll, __) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: isScroll ? 1 : 0,
                    child: Visibility(
                      visible: isScroll,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CustomColor.primaryLight),
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      fontFamily: "inter600",
                                      fontSize: 15,
                                      color: CustomColor.white),
                                ),
                                Text(
                                  "Klik untuk checkout",
                                  style: TextStyle(
                                      fontFamily: "inter600",
                                      fontSize: 15,
                                      color: CustomColor.white),
                                ),
                              ],
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: valTot,
                              builder: (_, result, __) {
                                return Text(
                                  FormatCurrency.convertToIdr(result, 0),
                                  style: TextStyle(
                                      fontFamily: "inter600",
                                      fontSize: 15,
                                      color: CustomColor.white),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listItemFood(int index) {
    if (index == valListFood.value.length) {
      return Padding(
          padding: EdgeInsets.only(bottom: ScreenSize.getHeight(context) / 10));
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 70,
              color: CustomColor.primary,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valListFood.value[index].name,
                    style: TextStyle(
                        fontFamily: "inter600",
                        fontSize: 18,
                        color: CustomColor.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      FormatCurrency.convertToIdr(valListFood.value[index].price, 0),
                      style: TextStyle(
                          fontFamily: "inter500",
                          fontSize: 15,
                          color: CustomColor.primary),
                    ),
                  ),
                  Text(
                    "${valListFood.value[index].rating}",
                    style: TextStyle(
                        fontFamily: "inter500",
                        fontSize: 15,
                        color: CustomColor.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          int currVal = valListFood.value[index].sum;
                          if (currVal != 0) {
                            currVal--;
                            valListFood.value[index].sum = currVal;
                            valListCountItem.value[index] = currVal;
                            valListCountItem.notifyListeners();

                            sumAddMinTot(valListFood.value[index],
                                valListFood.value[index].price, currVal, false);
                          }
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        splashColor: CustomColor.greyBd,
                        child: Icon(Icons.remove_circle,
                            color: CustomColor.primary),
                      ),
                      SizedBox(
                        width: 40,
                        child: ValueListenableBuilder<List<int>>(
                          valueListenable: valListCountItem,
                          builder: (_, result, __) {
                            return Text(
                              "${result[index]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "inter500",
                                  fontSize: 15,
                                  color: CustomColor.black),
                            );
                          },
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            int currVal = valListFood.value[index].sum;
                            currVal++;
                            valListFood.value[index].sum = currVal;
                            valListCountItem.value[index] = currVal;
                            valListCountItem.notifyListeners();

                            if (!valIsScroll.value) {
                              valIsScroll.value = true;
                            }
                            sumAddMinTot(valListFood.value[index],
                                valListFood.value[index].price, currVal, true);
                          },
                          child: Icon(Icons.add_circle,
                              color: CustomColor.primary)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    setupDummy();
    super.initState();
  }

  Future<void> sumAddMinTot(
      ModelFood model, int price, int totItem, bool isAdd) async {
    int result = 0;
    if (isAdd) {
      result = valTot.value + price;
      if (listOrder.isEmpty) {
        listOrder.add(ModelCheckout(
            idOrder: model.idFood,
            name: model.name,
            price: model.price,
            sum: totItem));
      } else {
        bool alreadyAdd = await getAvailData(model.idFood);
        if (!alreadyAdd) {
          listOrder.add(ModelCheckout(
              idOrder: model.idFood,
              name: model.name,
              price: model.price,
              sum: totItem));
        } else {
          for (int x = 0; x < listOrder.length; x++) {
            if (listOrder[x].idOrder == model.idFood) {
              listOrder[x].sum = totItem;
              break;
            }
          }
        }
      }
    } else {
      result = valTot.value - price;
      for (int x = 0; x < listOrder.length; x++) {
        if (listOrder[x].idOrder == model.idFood) {
          if(result == 0) {
            listOrder.removeAt(x);
          } else {
            listOrder[x].sum = totItem;
          }
          break;
        }
      }
    }

    valTot.value = result;
    if (valTot.value == 0) {
      valIsScroll.value = false;
      valIsScroll.notifyListeners();
    }
    valTot.notifyListeners();
  }

  Future<bool> getAvailData(int id) async {
    bool result = false;
    for (int x = 0; x < listOrder.length; x++) {
      if (listOrder[x].idOrder == id) {
        result = true;
        break;
      }
    }
    return result;
  }

  void search() {
    if (query.isNotEmpty) {
      List<ModelFood> newList = [];
      for (int x = 0; x < listFood.length; x++) {
        if (listFood[x].name.toLowerCase() == query.toLowerCase() ||
            listFood[x].name.toLowerCase().contains(query.toLowerCase())) {
          ModelFood model = listFood[x];
          newList.add(ModelFood(
              idFood: model.idFood,
              name: model.name,
              price: model.price,
              rating: model.rating,
              sum: model.sum));
          valListFood.value = newList;
          valListFood.notifyListeners();
        }
      }
    } else {
      valListFood.value = listFood;
      valListFood.notifyListeners();
    }
  }

  void goOrder() {
    for (int x = 0; x < valListFood.value.length; x++) {
      if (valListFood.value[x].sum > 0) {}
    }
    bottomNav.pushNewScreen(context,
        withNavBar: false,
        screen: DetailOrder(
          listOrder: listOrder,
        ));
  }

  void setupDummy() {
    listFood.add(ModelFood(
        idFood: 1, name: "Ayam Goreng", price: 20000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[0].sum);
    listFood.add(ModelFood(
        idFood: 2, name: "Mi Ayam", price: 10000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[1].sum);
    listFood.add(ModelFood(
        idFood: 3, name: "Ketoprak", price: 15000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[2].sum);
    listFood.add(ModelFood(
        idFood: 4, name: "Ayam Geprek", price: 35000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[3].sum);
    listFood.add(
        ModelFood(idFood: 5, name: "Jus Jeruk", price: 5000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[4].sum);
    listFood.add(
        ModelFood(idFood: 6, name: "Jus Alpukat", price: 7000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[5].sum);
    listFood.add(ModelFood(
        idFood: 7, name: "Sate Kulit", price: 30000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[6].sum);
    listFood.add(
        ModelFood(idFood: 8, name: "Kopikap", price: 1000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[7].sum);
    listFood.add(ModelFood(
        idFood: 9, name: "Nasi Goreng", price: 50000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[8].sum);
    listFood.add(ModelFood(
        idFood: 10, name: "Mie Goreng", price: 45000, rating: 4.3, sum: 0));
    valListCountItem.value.add(listFood[9].sum);

    valListFood.value = listFood;
  }
}
