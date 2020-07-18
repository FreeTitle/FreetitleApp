import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionInvoker {
  static Future<HttpsCallableResult> CloudFunction(data, functionName) async {
    HttpsCallable likePressed = CloudFunctions.instance.getHttpsCallable(functionName: functionName);
    HttpsCallableResult resp = await likePressed.call(<String, dynamic>{
      /* TBD */
    });

    return resp;
  }
}