import 'package:mcfood/model/ModelMakanan.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';

class ControllerMakanan {
  getListMakanan(Function(List<ModelMakanan>) success) {
    RequestApiHelper.sendRequest(
        type: Api.get,
        url: "getListMakanan.php",
        runInBackground: true,
        withLoading: true,
        config: RequestApiHelperData(onSuccess: (resp) {
          List result = resp["result"];
          List<ModelMakanan> listResult = [];
          for (var x = 0; x < result.length; x++) {
            listResult.add(ModelMakanan(
                idMakanan: result[x]["idMakanan"],
                nama: result[x]["nama"],
                price: result[x]["price"],
                rating: result[x]["rating"],
                image: result[x]["image"],
                sum: 0));
          }
          success(listResult);
        }, onError: (fail) {
          print("ERROR ${fail.body}");
        }));
  }
}
