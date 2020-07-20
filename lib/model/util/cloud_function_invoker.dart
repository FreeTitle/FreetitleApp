import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionInvoker {
  static Future<HttpsCallableResult> cloudFunction(data, functionName) async {
    HttpsCallable likePressed = CloudFunctions.instance.getHttpsCallable(functionName: functionName);
    HttpsCallableResult resp = await likePressed.call(data);
    return resp;
  }
}