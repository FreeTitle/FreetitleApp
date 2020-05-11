import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARiOSView extends StatefulWidget {
  _ARiOSViewState createState() => _ARiOSViewState();
}

//class _ARiOSViewState extends State<ARiOSView> {
//  ARKitController arkitController;
//
//  @override
//  void dispose() {
//    arkitController?.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("AR Flutter"),
//      ),
//      body: ARKitSceneView(
////        trackingImages: const [
////          ARKitReferenceImage(
////            name: "assets/logo.png",
////            physicalWidth: 0.2
////          )
////        ],
//        onARKitViewCreated: onARKitViewCreated,
////        worldAlignment: ARWorldAlignment.camera,
////        configuration: ARKitConfiguration.imageTracking,
//      ),
//    );
//  }
//
//  void onARKitViewCreated(ARKitController arkitController) {
//    this.arkitController = arkitController;
//
//    final material = ARKitMaterial(
//      lightingModelName: ARKitLightingModel.lambert,
//      diffuse: ARKitMaterialProperty(image: 'assets/logo.png'),
//    );
//
//    final node = ARKitNode(geometry: ARKitSphere(radius: 0.1, materials: [material]), position: Vector3(0, 0, -0.5));
//    this.arkitController.add(node);
//  }
//}

class _ARiOSViewState extends State<ARiOSView> {
  ARKitController arkitController;
  ARKitReferenceNode node;
  String anchorId;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Custom object on plane Sample')),
    body: Container(
      child: ARKitSceneView(
        showFeaturePoints: true,
        planeDetection: ARPlaneDetection.horizontal,
        onARKitViewCreated: onARKitViewCreated,
      ),
    ),
  );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    if (node != null) {
      controller.remove(node.name);
    }
    node = ARKitReferenceNode(
      url: 'models.scnassets/model.dae',
      position: vector.Vector3(0, 0, 0),
      scale: vector.Vector3(0.002, 0.002, 0.002),
    );
    controller.add(node, parentNodeName: anchor.nodeName);
  }
}