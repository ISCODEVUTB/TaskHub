import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StatusBadge extends StatefulWidget {
  final String status;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final bool animate;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
    this.animate = true,
  });

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.95,
      upperBound: 1.08,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant StatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      _controller.forward(from: 0.95).then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;
    String semanticsLabel;
    switch (widget.status) {
      case 'Completado':
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        label = 'Completado';
        semanticsLabel = 'Tarea completada';
        break;
      case 'En progreso':
        color = AppColors.info;
        icon = Icons.autorenew_rounded;
        label = 'En progreso';
        semanticsLabel = 'Tarea en progreso';
        break;
      case 'Pendiente':
      default:
        color = AppColors.warning;
        icon = Icons.schedule_rounded;
        label = 'Pendiente';
        semanticsLabel = 'Tarea pendiente';
        break;
    }
    final badge = Semantics(
      label: semanticsLabel,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(31),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(128)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: semanticsLabel,
              child: Icon(icon, color: color, size: widget.fontSize != null ? widget.fontSize! + 2 : 18),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: widget.fontSize ?? 14,
              ),
            ),
          ],
        ),
      ),
    );
    if (widget.animate) {
      return AnimatedScale(
        scale: _scaleAnim.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: badge,
        ),
      );
    } else {
      return badge;
    }
  }
}
