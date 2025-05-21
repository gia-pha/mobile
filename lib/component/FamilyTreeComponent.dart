import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/utils/genogram_utils.dart';
import 'package:gia_pha_mobile/widgets/genogram_node.dart';
import 'package:org_chart/org_chart.dart';
import 'package:gia_pha_mobile/model/FamilyMember.dart';
import 'package:gia_pha_mobile/model/NBModel.dart';

class FamilyTreeComponent extends StatefulWidget {
  static String tag = '/NBNewsComponent';
  final List<NBNewsDetailsModel>? list;

  const FamilyTreeComponent({super.key, this.list});

  @override
  FamilyTreeComponentState createState() => FamilyTreeComponentState();
}

class FamilyTreeComponentState extends State<FamilyTreeComponent> {
  late final GenogramController<FamilyMember> controller;
  final CustomInteractiveViewerController _interactiveController =
      CustomInteractiveViewerController();
  final FocusNode focusNode = FocusNode();

  // Sample family members and relationships
  late List<FamilyMember> _familyMembers;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });

    // Initialize sample data
    _familyMembers = GenogramUtils.getSampleFamilyData();

    // Initialize controller
    controller = GenogramController<FamilyMember>(
      items: _familyMembers,
      idProvider: (item) => item.id,
      fatherProvider: (data) => data.fatherId,
      motherProvider: (data) => data.motherId,
      genderProvider: (data) => data.gender,
      spousesProvider: (data) => data.spouses,
      boxSize: const Size(150, 150),
      spacing: 30,
      runSpacing: 80,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGenogram();
  }

  Widget _buildGenogram() {
    return Genogram<FamilyMember>(
      controller: controller,
      viewerController: _interactiveController,
      builder: (details) => GenogramNode(
        details: details,
        onToggleNodes: (hide) {
          if (hide != null) {
            // Logic to hide/show nodes
            controller.calculatePosition();
          }
        },
      ),
      edgeConfig: GenogramEdgeConfig(
          childStrokeWidth: 3,
          childSingleParentColor: Colors.grey,
          childSingleParentStrokeWidth: 5.0,
          marriageColors: [
            Colors.greenAccent,
            Colors.lightGreen,
            Colors.lightGreenAccent,
          ],
          defaultMarriageStyle: MarriageStyle(
            lineStyle: MarriageLineStyle(
              color: Colors.black,
              strokeWidth: 5.0,
            ),
            decorator: const DivorceDecorator(),
          )),
      isDraggable: true,
      enableZoom: true,
      minScale: 0.4,
      maxScale: 2.0,
      focusNode: focusNode,
      enableRotation: false,
      constrainBounds: true,
      enableDoubleTapZoom: true,
      doubleTapZoomFactor: 0.8,
    );
  }
}