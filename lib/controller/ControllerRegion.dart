import 'package:mcfood/model/ModelKecamatan.dart';
import 'package:mcfood/model/ModelKelurahan.dart';
import 'package:mcfood/model/ModelKotaKabs.dart';
import 'package:mcfood/model/ModelProvinsi.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';

class ControllerRegion {
  getProvinsi(Function(List<ModelProvinsi>) success) {
    RequestApiHelper.sendRequest(
        type: Api.get,
        url: "getProvinsi.php",
        runInBackground: true,
        withLoading: true,
        config: RequestApiHelperData(
            bodyIsJson: true,
            onSuccess: (resp) {
              List result = resp["result"];
              List<ModelProvinsi> listResult = [];
              for (var x = 0; x < result.length; x++) {
                listResult.add(ModelProvinsi(
                    provId: result[x]["provId"],
                    provName: result[x]["provName"],
                    locationId: result[x]["locationId"]));
              }
              success(listResult);
            },
            onError: (fail) {
              print("ERROR ${fail.body}");
            }));
  }

  getKotaKabs(int idProv, Function(List<ModelKotaKabs>) success) {
    RequestApiHelper.sendRequest(
        type: Api.get,
        url: "getKota.php",
        runInBackground: true,
        withLoading: true,
        config: RequestApiHelperData(
            bodyIsJson: false,
            body: {"prov_id": idProv},
            onSuccess: (resp) {
              List result = resp["result"];
              List<ModelKotaKabs> listResult = [];
              for (var x = 0; x < result.length; x++) {
                listResult.add(ModelKotaKabs(
                    cityId: result[x]["idCity"],
                    cityName: result[x]["cityName"]));
              }
              success(listResult);
            },
            onError: (fail) {
              print("ERROR ${fail.body}");
            }));
  }

  getKecamatan(int idCity, Function(List<ModelKecamatan>) success) {
    RequestApiHelper.sendRequest(
        type: Api.get,
        url: "getKecamatan.php",
        runInBackground: true,
        withLoading: true,
        config: RequestApiHelperData(
            bodyIsJson: false,
            body: {"city_id": idCity},
            onSuccess: (resp) {
              List result = resp["result"];
              List<ModelKecamatan> listResult = [];
              for (var x = 0; x < result.length; x++) {
                listResult.add(ModelKecamatan(
                    kecId: result[x]["idKec"], kecName: result[x]["kecName"]));
              }
              success(listResult);
            },
            onError: (fail) {
              print("ERROR ${fail.body}");
            }));
  }

  getKelurahan(int idKec, Function(List<ModelKelurahan>) success) {
    RequestApiHelper.sendRequest(
        type: Api.get,
        url: "getKelurahan.php",
        runInBackground: true,
        withLoading: true,
        config: RequestApiHelperData(
            bodyIsJson: false,
            body: {"dis_id": idKec},
            onSuccess: (resp) {
              List result = resp["result"];
              List<ModelKelurahan> listResult = [];
              for (var x = 0; x < result.length; x++) {
                listResult.add(ModelKelurahan(
                    kelurId: result[x]["idKel"],
                    kelurName: result[x]["kelurName"]));
              }
              success(listResult);
            },
            onError: (fail) {
              print("ERROR ${fail.body}");
            }));
  }
}
