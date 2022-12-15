import 'package:mcfood/model/ModelProvinsi.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';

class ControllerRegion {
  getProvinsi(Function(List<ModelProvinsi>) success) {
    RequestApiHelper.sendRequest(
        type: Api.get,
        url: "posts",
        runInBackground: true,
        withLoading: true,
        config: RequestApiHelperData(
            bodyIsJson: true,
            onSuccess: (resp) {
              // List result = resp["result"];
              // List<ModelProvinsi> listResult = [];
              // for (var x = 0; x < result.length; x++) {
              //   listResult.add(ModelProvinsi(
              //       provId: result[x]["provId"],
              //       provName: result[x]["provName"],
              //       locationId: result[x]["locationId"]));
              // }
              // success(listResult);
              print("SUKSES ${resp}");
            },
            onError: (fail) {
              print("ERROR ${fail.body}");
            }));
  }
}
