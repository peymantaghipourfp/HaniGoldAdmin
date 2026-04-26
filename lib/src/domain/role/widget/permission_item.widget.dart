import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/role/model/element.model.dart';
import 'package:hanigold_admin/src/domain/role/model/element_action.model.dart';

class PermissionItemWidget extends StatelessWidget {
  final ElementModel element;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMainPermission;

  const PermissionItemWidget({
    Key? key,
    required this.element,
    required this.isSelected,
    required this.onTap,
    this.isMainPermission = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: Colors.green.withOpacity(0.3))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onTap(),
                  activeColor: Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        element.title ?? element.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: isMainPermission
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                      if (element.description != null && element.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            element.description!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isMainPermission)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubPermissionItemWidget extends StatelessWidget {
  final ElementActionModel subElement;
  final bool isSelected;
  final VoidCallback onTap;

  const SubPermissionItemWidget({
    Key? key,
    required this.subElement,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isSelected
            ? Border.all(color: Colors.green.withOpacity(0.2))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onTap(),
                  activeColor: Colors.green,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subElement.title ?? subElement.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subElement.attribute != null && subElement.attribute!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subElement.attribute!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
