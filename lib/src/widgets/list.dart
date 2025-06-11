import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class CustomVerticalList extends StatelessWidget {
  const CustomVerticalList({
    super.key,
    this.gap,
    this.paddingAtStart,
    this.customEmptyListText,
    this.maxHeight,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.verticalDirection,
    this.customEmptyTextColor,
    required this.children,
  });

  final double? gap;
  final double? paddingAtStart;
  final String? customEmptyListText;
  final double? maxHeight;
  final Color? customEmptyTextColor;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final VerticalDirection? verticalDirection;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> modifiedList = children
        .expand((item) => [
              item,
              SizedBox(
                height: gap,
                width: gap,
              )
            ])
        .toList();

    return maxHeight != null
        ? Container(
            constraints: BoxConstraints(maxHeight: maxHeight!),
            child: SingleChildScrollView(
              child: modifiedList.isEmpty
                  ? CustomText(
                      text: customEmptyListText ?? 'Empty list',
                      color: customEmptyTextColor ?? grey2,
                    )
                  : Column(
                      mainAxisAlignment:
                          mainAxisAlignment ?? MainAxisAlignment.start,
                      crossAxisAlignment:
                          crossAxisAlignment ?? CrossAxisAlignment.center,
                      verticalDirection:
                          verticalDirection ?? VerticalDirection.down,
                      children: [
                        paddingAtStart != null
                            ? SizedBox(
                                width: paddingAtStart,
                                height: paddingAtStart,
                              )
                            : const SizedBox(),
                        ...modifiedList
                      ],
                    ),
            ),
          )
        : SingleChildScrollView(
            child: modifiedList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: CustomText(
                        text: customEmptyListText ?? 'Empty list',
                        color: customEmptyTextColor ?? grey2,
                        align: TextAlign.center,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment:
                        mainAxisAlignment ?? MainAxisAlignment.start,
                    crossAxisAlignment:
                        crossAxisAlignment ?? CrossAxisAlignment.center,
                    verticalDirection:
                        verticalDirection ?? VerticalDirection.down,
                    children: [
                      paddingAtStart != null
                          ? SizedBox(
                              width: paddingAtStart,
                              height: paddingAtStart,
                            )
                          : const SizedBox(),
                      ...modifiedList
                    ],
                  ),
          );
  }
}

class CustomHorizontalList extends StatelessWidget {
  const CustomHorizontalList({
    super.key,
    this.gap,
    this.paddingAtStart,
    this.customEmptyListText,
    this.maxWidth,
    this.maxHeight,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.verticalDirection,
    required this.children,
  });

  final double? gap;
  final double? paddingAtStart;
  final String? customEmptyListText;
  final double? maxWidth;
  final double? maxHeight;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final VerticalDirection? verticalDirection;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> modifiedList = children
        .expand((item) => [
              item,
              SizedBox(
                height: gap,
                width: gap,
              )
            ])
        .toList();

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: modifiedList.isEmpty
            ? CustomText(text: customEmptyListText ?? 'Empty list')
            : Row(
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                crossAxisAlignment:
                    crossAxisAlignment ?? CrossAxisAlignment.center,
                verticalDirection: verticalDirection ?? VerticalDirection.down,
                children: [
                  paddingAtStart != null
                      ? SizedBox(
                          width: paddingAtStart,
                          height: paddingAtStart,
                        )
                      : const SizedBox(),
                  ...modifiedList
                ],
              ),
      ),
    );
  }
}
