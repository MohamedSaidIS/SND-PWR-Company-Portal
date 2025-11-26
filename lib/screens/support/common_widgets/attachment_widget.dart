import 'package:company_portal/screens/support/ecommerce_support_case/controllers/file_controller.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AttachmentWidget extends StatefulWidget {
  const AttachmentWidget({
    super.key,
  });

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Consumer<FileController>(builder: (context, provider, _) {
      final allFiles = provider.attachedFiles;
      return Column(
        children: [
          InkWell(
            splashColor: Colors.black12,
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              await provider.pickFiles();
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.paperclip_solid,
                    color: theme.colorScheme.secondary,
                  ),
                  Text(local.attachFile)
                ],
              ),
            ),
          ),
          allFiles.isEmpty ? const SizedBox.shrink()
              : SizedBox(
            height: (25 * (allFiles.length)).toDouble(),
            child: Scrollbar(
              thumbVisibility: allFiles.length >= 2? true : false,
              child: ListView.builder(
                  physics: allFiles.length >= 2
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemCount: allFiles.length,
                  itemBuilder: (context, index) {
                    final file = allFiles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              file.fileName,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: theme.colorScheme.secondary, fontSize: 13),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              provider.deleteFiles(index);
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(6),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      );
    });
  }
}
