import 'package:company_portal/screens/support/ecommerce_support_case/controllers/ecommerce_form_controller.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AttachmentWidget extends StatefulWidget {
  final Future<void> Function() pickFile;



  const AttachmentWidget(
      {super.key, required this.pickFile,});

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Column(
      children: [
        InkWell(
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            await widget.pickFile();
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
        Consumer<EcommerceFormController>(
          builder: (context, provider, _) {
            final allFiles = provider.allFilesAttached;
            return SizedBox(
              height: 80,
              child: ListView.builder(
                  itemCount: allFiles.length,
                  itemBuilder: (context, index) {
                    final file = allFiles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              file.fileName,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: theme.colorScheme.secondary),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              provider.deleteFiles(index);
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 15,
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          },
        ),
      ],
    );
  }
}
