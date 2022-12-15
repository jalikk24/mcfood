import 'package:fluttertoast/fluttertoast.dart';
import 'package:mcfood/model/ModelLogin.dart';
import 'package:mcfood/model/ModelRegister.dart';
import 'package:mcfood/model/ModelUser.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';
import 'package:request_api_helper/session.dart';

class ControllerAuth {

  register(ModelRegister modelRegister, Function() success, Function() failed) {
    RequestApiHelper.sendRequest(
      type: Api.post,
      url: "register.php",
      runInBackground: true,
      config: RequestApiHelperData(
          bodyIsJson: true,
          body: ModelRegister.morph(modelRegister),
          // body: ModelVerifikasi.morp(modelVerifikasi),
          onSuccess: (value) {
            success();
          },
          onError: (_) {
            failed();
          }),
    );
  }

  login(ModelLogin modelLogin, Function() success, Function() failed) {
    RequestApiHelper.sendRequest(
      type: Api.post,
      url: "login.php",
      runInBackground: true,
      withLoading: true,
      config: RequestApiHelperData(
          bodyIsJson: true,
          body: {
            "username": modelLogin.username,
            "passwords": modelLogin.password
          },
          onSuccess: (value) async {
            dynamic result = value["result"];
            if(result != null) {
              ModelUser modelUser = ModelUser(idUser: result["id"], username: result["username"], alamat: result["alamat"]);
              await Session.save(header: "idUser", integerData: modelUser.idUser);
              await Session.save(header: "username", stringData: modelUser.username);
              await Session.save(header: "alamat", stringData: modelUser.alamat);
              success();
            } else {
              dynamic status = value["status"];
              String desc = status["description"];
              Fluttertoast.showToast(msg: desc);
            }
          },
          onError: (_) {
            Fluttertoast.showToast(msg: _.body);
            failed();
          }),
    );
  }

}