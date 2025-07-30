import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/theme/app_colors.dart';
import '../../data/models/nav_items.dart';

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
  String? _currentlyExpandedParentId;

  @override
  void initState() {
    super.initState();
    _initializeExpandedParent();
  }

  @override
  void didUpdateWidget(covariant SideNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentScreenId != oldWidget.currentScreenId) {
      _initializeExpandedParent();
    }
  }

  void _initializeExpandedParent() {
    for (var item in widget.navItems) {
      if (item.hasChildren &&
          item.subItems!.any((sub) => sub.id == widget.currentScreenId)) {
        setState(() => _currentlyExpandedParentId = item.id);
        return;
      }
    }
    if (widget.currentScreenId != null) {
      final match = widget.navItems
          .any((item) => item.id == widget.currentScreenId && item.hasChildren);
      if (match) setState(() => _currentlyExpandedParentId = widget.currentScreenId);
    }
  }

  void _toggleExpand(String id) {
    setState(() {
      _currentlyExpandedParentId =
      _currentlyExpandedParentId == id ? null : id;
    });
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final drawerWidth = screenSize.width * 0.55;

    return Drawer(
      width: drawerWidth,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF212833), width: 0.5),
      ),
      backgroundColor: AppColors.primaryBackgroundColor.withAlpha(490),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: drawerWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.03),
              Image.asset(
                "assets/images/splashScreenLogo.png",
                width: drawerWidth * 0.5,
              ),
              SizedBox(height: screenSize.height * 0.03),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.navItems.length,
                  separatorBuilder: (_, index) {
                    final item = widget.navItems[index];
                    return item.isDivider
                        ? Divider(
                      height: screenSize.height * 0.015,
                      color: Colors.white10,
                    )
                        : SizedBox(height: screenSize.height * 0.008);
                  },
                  itemBuilder: (context, index) {
                    final item = widget.navItems[index];

                    if (item.isDivider) return const SizedBox();

                    final isExpanded = _currentlyExpandedParentId == item.id;
                    final isSelected = widget.currentScreenId == item.id ||
                        _currentlyExpandedParentId == item.id ||
                        (item.hasChildren && item.subItems!.any((sub) => sub.id == widget.currentScreenId));

                    return NavItemTile(
                      item: item,
                      drawerWidth: drawerWidth,
                      isExpanded: isExpanded,
                      isSelected: isSelected,
                      currentScreenId: widget.currentScreenId,
                      onExpandToggle: _toggleExpand,
                      onItemSelected: widget.onScreenSelected,
                      closeDrawer: () => Navigator.pop(context),
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

class NavItemTile extends StatelessWidget {
  final NavItem item;
  final double drawerWidth;
  final bool isExpanded;
  final bool isSelected;
  final String? currentScreenId;
  final Function(String id) onExpandToggle;
  final Function(String id) onItemSelected;
  final VoidCallback closeDrawer;

  const NavItemTile({
    super.key,
    required this.item,
    required this.drawerWidth,
    required this.isExpanded,
    required this.isSelected,
    required this.currentScreenId,
    required this.onExpandToggle,
    required this.onItemSelected,
    required this.closeDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? AppColors.primaryColor : const Color(0XFF9C9C9C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: drawerWidth * 0.05),
          leading: SvgPicture.asset(
            item.iconPath ?? '',
             height: drawerWidth * 0.11,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: Text(
            item.title ?? '',
            style: AppTextStyle.bodySmall2x(context, color: iconColor),
          ),
          trailing: item.hasChildren
              ? Icon(
            size: drawerWidth * 0.12,
            isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: iconColor,
          )
              : null,
          onTap: () {
            if (item.hasChildren) {
              onExpandToggle(item.id!);
            } else {
              closeDrawer();
              if (item.onTap != null) {
                item.onTap!(context);
              } else {
                onItemSelected(item.id ?? '');
              }


             }
          },
        ),
        if (item.hasChildren)
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Padding(
              padding: EdgeInsets.only(left: drawerWidth * 0.22),
              child: Column(
                children: item.subItems!.map((sub) {
                  final isSubSelected = currentScreenId == sub.id;
                  return SubNavItemTile(
                    subItem: sub,
                    isSelected: isSubSelected,
                    onSelected: (id) {
                      closeDrawer();
                      if (sub.onTap != null) {
                        sub.onTap!(context);
                      } else {
                        onItemSelected(id);
                      }

                    },
                  );
                }).toList(),
              ),
            ),
            crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
      ],
    );
  }
}

class SubNavItemTile extends StatelessWidget {
  final NavItem subItem;
  final bool isSelected;
  final Function(String id) onSelected;

  const SubNavItemTile({
    super.key,
    required this.subItem,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(
        subItem.title ?? '',
        style: AppTextStyle.bodySmall2x(
          context,
          color: isSelected ? Colors.white : AppColors.secondaryColor3,
        ),
      ),
      onTap: () => onSelected(subItem.id ?? ''),
    );
  }
}
