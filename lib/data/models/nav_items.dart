import 'package:flutter/material.dart';
class NavItem {
  final String? id;
  final String? title;
  final String? iconPath;
  final Widget Function(BuildContext)? screenBuilder;
  final void Function(BuildContext)? onTap;
  final bool isDivider;
  final List<NavItem>? subItems;


  NavItem({
    this.id,
    this.title,
    this.iconPath,
    this.screenBuilder,
    this.onTap,
    this.isDivider = false,
    this.subItems,
  });

  bool get hasChildren => subItems != null && subItems!.isNotEmpty;
  factory NavItem.divider(){
    return NavItem(isDivider: true);
  }
}
