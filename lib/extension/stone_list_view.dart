import 'package:flutter/material.dart';

extension StoneListView on ListView {
  /// 构建一个分组的 ListView
  static ListView grouped({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    Widget headerBuilder(BuildContext context, int section),
    Widget footerBuilder(BuildContext context, int section),
    @required Widget itemBuilder(BuildContext context, int section, int index),
    int sectionCount = 1,
    @required int itemCount(int section),
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double itemExtent,
    double cacheExtent,
  }) {
    assert(itemBuilder != null);
    assert(sectionCount != null && sectionCount >= 0);
    assert(itemCount != null);

    // 记录每一个 Item 在 section 中的信息
    // indexes[i][0]：此 Item 所属的 section
    // indexes[i][1]：此 Item 在 section 中的位置，header、footer 为 -1
    // indexes[i][2]：此 Item 是否为 header
    // indexes[i][3]：此 Item 是否为 footer
    final itemInfos = <List<int>>[];
    for (var sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
      final hasHeader = headerBuilder != null;
      if (hasHeader) {
        itemInfos.add(<int>[sectionIndex, -1, 1, 0]);
      }

      final cellCount = itemCount(sectionIndex);
      for (var cellIndex = 0; cellIndex < cellCount; cellIndex++) {
        itemInfos.add(<int>[sectionIndex, cellIndex, 0, 0]);
      }

      final hasFooter = footerBuilder != null;
      if (hasFooter) {
        itemInfos.add(<int>[sectionIndex, -1, 0, 1]);
      }
    }

    return ListView.custom(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      childrenDelegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final itemInfo = itemInfos[index];
        final sectionIndex = itemInfo[0];
        final itemIndex = itemInfo[1];
        final isHeader = itemInfo[2] == 1;
        final isFooter = itemInfo[3] == 1;

        if (isHeader) {
          return headerBuilder(context, sectionIndex);
        }

        if (isFooter) {
          return footerBuilder(context, sectionIndex);
        }

        return itemBuilder(context, sectionIndex, itemIndex);
      },
        childCount: itemInfos.length,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      ),
    );
  }
}