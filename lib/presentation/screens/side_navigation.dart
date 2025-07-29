
import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/theme/app_colors.dart';

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

class SideNavBar extends StatefulWidget {
  final String? currentScreenId;
  final Function(String screenId) onScreenSelected;
  final List<NavItem> navItems;
  final VoidCallback? onLogoutTapped;

  const SideNavBar({
    Key? key,
    this.currentScreenId,
    required this.onScreenSelected,
    required this.navItems,
    this.onLogoutTapped,
  }) : super(key: key);

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  final Set<String> _expandedItems = {};

  void _toggleExpand(String id) {
    setState(() {
      if (_expandedItems.contains(id)) {
        _expandedItems.remove(id);
      } else {
        _expandedItems.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final drawerWidth = size.width * 0.55;

    return Drawer(
      width: drawerWidth,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF212833), width: 0.5),
      ),
      backgroundColor: AppColors.primaryBackgroundColor.withAlpha(490),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.02,
            vertical: size.height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              Image.asset(
                "assets/images/splashScreenLogo.png",
                fit: BoxFit.contain,
                width: drawerWidth * 0.5,
              ),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.navItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.navItems[index];

                    if (item.isDivider) {
                      return Container(
                        height: 0.4,
                        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFDD27E).withOpacity(0.2),
                              const Color(0xFFFDD27E).withOpacity(0.2),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: drawerWidth * 0.05,
                          ),
                          leading: SvgPicture.asset(
                            item.iconPath ?? '',
                            width: drawerWidth * 0.07,
                            height: drawerWidth * 0.07,
                            fit: BoxFit.scaleDown,
                          ),
                          title: Text(
                            item.title ?? '',
                            style: AppTextStyle.bodySmall2x(
                              context,
                              color: AppColors.secondaryColor3,
                            ),
                          ),
                          trailing: item.hasChildren
                              ? Icon(
                            _expandedItems.contains(item.id)
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.secondaryColor3,
                          )
                              : null,
                          onTap: () {
                            if (item.hasChildren) {
                              _toggleExpand(item.id!);
                            } else {
                              Navigator.pop(context);
                              if (item.onTap != null) {
                                item.onTap!(context);
                              } else if (item.screenBuilder != null) {
                                widget.onScreenSelected(item.id ?? '');
                              }
                            }
                          },
                        ),
                        if (item.hasChildren && _expandedItems.contains(item.id))
                          Padding(
                            padding: EdgeInsets.only(left: drawerWidth * 0.22),
                            child: Column(
                              children: item.subItems!.map((subItem) {
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    subItem.title ?? '',
                                    style: AppTextStyle.bodySmall2x(
                                      context,
                                      color: AppColors.secondaryColor3,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (subItem.onTap != null) {
                                      subItem.onTap!(context);
                                    } else if (subItem.screenBuilder != null) {
                                      widget.onScreenSelected(subItem.id ?? '');
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

