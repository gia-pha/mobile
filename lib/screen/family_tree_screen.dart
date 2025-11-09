import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/utils/genogram_utils.dart';
import 'package:gia_pha_mobile/widgets/genogram_node.dart';
import 'package:org_chart/org_chart.dart';
import 'package:gia_pha_mobile/model/family_member.dart';
import 'dart:typed_data';

class FamilyTreeScreen extends StatefulWidget {
  const FamilyTreeScreen({super.key});

  @override
  State<FamilyTreeScreen> createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  late GenogramController<FamilyMember> controller;
  final CustomInteractiveViewerController _interactiveController =
      CustomInteractiveViewerController();
  final FocusNode focusNode = FocusNode();

  // Sample family members and relationships
  late List<FamilyMember> _familyMembers;

  // Configuration flags exposed in header/footer
  bool _isDraggable = false;
  bool _enableZoom = true;
  GraphOrientation _orientation = GraphOrientation.topToBottom;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });

    // Initialize sample data
    _familyMembers = GenogramUtils.getSampleFamilyData();

    // Initialize controller
    _createController();
  }

  void _createController() {
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
      orientation: _orientation,
    );

    // Ensure layout is calculated after creating controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.calculatePosition();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Theme.of(context).canvasColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Draggable'),
                Switch(
                  value: _isDraggable,
                  onChanged: (v) => setState(() => _isDraggable = v),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Zoom'),
                Switch(
                  value: _enableZoom,
                  onChanged: (v) => setState(() => _enableZoom = v),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Orientation'),
                const SizedBox(width: 8),
                DropdownButton<GraphOrientation>(
                  value: _orientation,
                  items: const [
                    DropdownMenuItem(
                      value: GraphOrientation.topToBottom,
                      child: Text('Top → Bottom'),
                    ),
                    DropdownMenuItem(
                      value: GraphOrientation.leftToRight,
                      child: Text('Left → Right'),
                    ),
                  ],
                  onChanged: (GraphOrientation? newVal) {
                    if (newVal == null) return;
                    setState(() {
                      _orientation = newVal;
                      _createController();
                    });
                  },
                ),
              ],
            ),
            IconButton(
              tooltip: 'Recalculate positions',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.calculatePosition();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.rotate_90_degrees_ccw),
              onPressed: () => controller.switchOrientation(),
            ),
            IconButton(
              icon: Icon(Icons.download),
              onPressed: exportFamilyTree,
            ),
          ],
        ),
      ),
      body: _buildGenogram(),
    );
  }

  Widget _buildGenogram() {
    return Genogram<FamilyMember>(
      key: ValueKey('${_orientation.index}_${controller.hashCode}'),
      controller: controller,
      viewerController: _interactiveController,
      builder: (details) => GenogramNode(
        details: details,
        onToggleNodes: (hide) {
          if (hide != null) {
            // Logic to hide/show nodes
            controller.calculatePosition();
            setState(() {}); // ensure widget rebuild
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
      isDraggable: _isDraggable,
      interactionConfig: const InteractionConfig(
        enableRotation: false,
        constrainBounds: true,
        // enablePan: true,
        // scrollMode: ScrollMode.drag,
      ),
      zoomConfig: ZoomConfig(
        enableZoom: _enableZoom,
        minScale: 0.4,
        maxScale: 2.0,
        enableDoubleTapZoom: true,
        doubleTapZoomFactor: 0.8,
      ),
      focusNode: focusNode,
    );
  }

  Future<void> _saveBytesToStorage(Uint8List bytes, String ext, MimeType mimeType) async {
    final filename = 'family_tree_${DateTime.now().millisecondsSinceEpoch}';
    final path = await FileSaver.instance.saveFile(
      name: filename,
      bytes: bytes,
      fileExtension: ext,
      mimeType: mimeType,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to: $path')));
  }

  // Export family tree
  void exportFamilyTree() async {
    final action = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Export Family Tree'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'image'),
            child: Text('Export as Image'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'pdf'),
            child: Text('Export as PDF'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (action == null) return;

    try {
      if (action == 'image') {
        final Uint8List? bytes = await controller.exportAsImage();
        if (bytes == null || bytes.isEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No image data to export')));
          return;
        }

        await _saveBytesToStorage(bytes, 'png', MimeType.png);
      } else if (action == 'pdf') {
        final Uint8List? pdfBytes = await controller.exportAsPdf().then((doc) => doc?.save());
        if (pdfBytes == null || pdfBytes.isEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No PDF data to export')));
          return;
        }

        await _saveBytesToStorage(pdfBytes, 'pdf', MimeType.pdf);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }
}
