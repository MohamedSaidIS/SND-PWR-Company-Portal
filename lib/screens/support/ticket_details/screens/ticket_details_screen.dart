import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String modifiedDate, createdDate, commentCall;
  final String? itemId;
  final String? type;
  final String? title;
  final String? description;
  final String? status;
  final String? priority;
  final String? area;
  final String? purpose;
  final List<String>? app;
  final Uint8List? userImage;
  final dynamic userInfo;

  const TicketDetailsScreen({
    required this.itemId,
    required this.title,
    required this.description,
    required this.modifiedDate,
    required this.createdDate,
    required this.status,
    required this.priority,
    required this.commentCall,
    this.app,
    this.type,
    required this.purpose,
    required this.area,
    required this.userInfo,
    required this.userImage,
    super.key,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final ScrollController _attachmentsController = ScrollController();
  late ThemeData theme;
  late AppLocalizations local;
  late CommentProvider commentProvider;
  late List<ItemComments> comments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var commentProvider = context.read<CommentProvider>();
      await commentProvider.getComments(widget.itemId!, widget.commentCall);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = context.theme;
    local = context.local;
    commentProvider = context.watch<CommentProvider>();
    comments = commentProvider.comments;
  }

  @override
  void dispose() {
    _attachmentsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.ticketDetails,
          backBtn: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TicketHeader(
                          headerTitle: widget.title ?? "-",
                          status: widget.status ?? "-",
                        ),
                        const SizedBox(height: 24),

                        TicketDescription(
                          description: widget.description ?? "-",
                          priority: widget.priority ?? "-",
                        ),
                        const SizedBox(height: 24),

                        AttachmentsWidget(
                          itemId: widget.itemId!,
                          commentCall: widget.commentCall,
                        ),
                        const SizedBox(height: 24),

                        TicketDates(
                          createdDate: widget.createdDate,
                          modifiedDate: widget.modifiedDate.toString(),
                        ),
                        const SizedBox(height: 10),

                        TicketComments(
                          comments: comments,
                          userImage: widget.userImage,
                          userInfo: widget.userInfo,
                          commentProvider: commentProvider,
                        ),
                        const SizedBox(height: 24),

                        SendComment(
                          itemId: widget.itemId!,
                          commentCall: widget.commentCall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Portal(
  //     child: Scaffold(
  //       resizeToAvoidBottomInset: true,
  //       backgroundColor: theme.colorScheme.surface,
  //       appBar: CustomAppBar(
  //         title: local.ticketDetails,
  //         backBtn: true,
  //       ),
  //       body: SafeArea(
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //           child: Container(
  //             padding: const EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //               color: theme.colorScheme.primary.withValues(alpha: 0.1),
  //               borderRadius: BorderRadius.circular(18),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TicketHeader(
  //                     headerTitle: widget.title ?? "-",
  //                     status: widget.status ?? "-"),
  //                 const SizedBox(height: 24),
  //                 TicketDescription(
  //                     description: widget.description ?? "-",
  //                     priority: widget.priority ?? "-"),
  //                 const SizedBox(height: 24),
  //                 AttachmentsWidget(itemId: widget.itemId!, commentCall: widget.commentCall),
  //                 const SizedBox(height: 24),
  //                 TicketDates(
  //                     createdDate: widget.createdDate,
  //                     modifiedDate: widget.modifiedDate.toString()),
  //                 const SizedBox(height: 10),
  //                 TicketComments(
  //                   comments: comments,
  //                   userImage: widget.userImage,
  //                   userInfo: widget.userInfo,
  //                   commentProvider: commentProvider,
  //                 ),
  //                 const SizedBox(height: 24),
  //                 SendComment(itemId: widget.itemId!, commentCall: widget.commentCall),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
