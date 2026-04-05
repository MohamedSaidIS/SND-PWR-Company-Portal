import 'dart:typed_data';

import 'package:company_portal/screens/support/repo/support_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:company_portal/utils/export_import.dart';
class SupportScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const SupportScreen({required this.userInfo, required this.userImage, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final colorScheme = theme.colorScheme;
    final items = SupportItem.getSupportItems(local);
    final directReportList = context.watch<DirectReportsProvider>().directReportList;
    final repo = SupportRepo(client: SharePointDioClient(), myClient: MySharePointDioClient());



    return BlocProvider(
      create: (context) => SupportBloc(repo)..add(GetSupportDataEvent("${userInfo!.mail}")),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: CustomAppBar(
            title: local.support,
            backBtn: true,
          ),
          body: BlocBuilder<SupportBloc, SupportState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SideFadeSlideAnimation(
                  delay: 0,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isAnimated = state.animatedCards[index] ?? false;
                      return (item.name == "Users New \nRequests" &&
                            directReportList != null &&
                            directReportList.isEmpty)
                        ? const SizedBox.shrink()
                        : InkWell(
                          splashColor: Colors.transparent,
                          onTap: () async {
                            final bloc = context.read<SupportBloc>();
                            bloc.add(AnimatedCardEvent(index, true));
                            await Future.delayed(const Duration(milliseconds: 70));
                            bloc.add(AnimatedCardEvent(index, false));
                            if(!context.mounted) return;
                            navigatedScreen(context, item.name, userInfo, userImage);
                          },
                          child: SupportCard(
                            title: item.translatedName,
                            image: item.image,
                            isAnimated: isAnimated,
                          )
                       );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
   );
  }
}
