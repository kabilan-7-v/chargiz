import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HorizontalCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? finalDate;
  final double? boxWidth;
  final double? height;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? todayHighlightColor;
  final TextStyle? dateTextStyle;
  final TextStyle? monthTextStyle;
  final TextStyle? weekDayTextStyle;
  final List<BoxShadow>? boxShadows;
  final BorderRadius? borderRadius;
  final Function(DateTime)? onTap;
  final Function(DateTime)? onLongPress;
  final ImageProvider<Object>? backgroundImage;
  const HorizontalCalendar({
    super.key,
    this.initialDate,
    this.finalDate,
    this.boxWidth,
    this.backgroundColor,
    this.todayHighlightColor,
    this.boxShadows,
    this.borderRadius,
    this.backgroundImage,
    this.onTap,
    this.onLongPress,
    this.height,
    this.margin,
    this.dateTextStyle,
    this.monthTextStyle,
    this.weekDayTextStyle,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final ItemScrollController itemScrollController = ItemScrollController();

  DateTime initialDate = DateTime.now().subtract(const Duration(days: 5000));
  DateTime finalDate = DateTime.now().add(const Duration(days: 5000));
  int selectedIndex = 0;
  int? todayIndex;

  void getTodayIndex() {
    final DateTime today = DateTime.now();
    initialDate =
        DateTime(initialDate.year, initialDate.month, initialDate.day);
    finalDate = DateTime(finalDate.year, finalDate.month, finalDate.day);
    if (today.isAfter(initialDate.subtract(const Duration(days: 1))) &&
        today.isBefore(finalDate.add(const Duration(days: 1)))) {
      todayIndex = today.difference(initialDate).inDays;

      selectedIndex = todayIndex!;
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    initialDate = widget.initialDate ?? initialDate;
    finalDate = widget.finalDate ?? finalDate;
    getTodayIndex();
  }

  @override
  Widget build(BuildContext context) {
    final totalDays = finalDate.difference(initialDate).inDays + 1;

    return SizedBox(
      height: widget.height ?? 120,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: todayIndex ?? 0,
        scrollDirection: Axis.horizontal,
        itemCount: totalDays,
        itemBuilder: (context, index) => _calendarBox(index),
        itemScrollController: itemScrollController,
      ),
    );
  }

  Widget _calendarBox(int index) {
    final date = initialDate.add(Duration(days: index));
    bool isToday = (todayIndex != null && index == todayIndex);
    return GestureDetector(
      onTap: () {
        selectedIndex = index;
        setState(() {});
        widget.onTap?.call(date);
        itemScrollController.scrollTo(
            index: index - 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic);
      },
      onLongPress: () => widget.onLongPress?.call(date),
      child: Container(
          margin: widget.margin ??
              const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          decoration: BoxDecoration(
            image: widget.backgroundImage == null
                ? null
                : DecorationImage(
                    image: widget.backgroundImage!, fit: BoxFit.cover),
            gradient: index == selectedIndex
                ? const LinearGradient(colors: [
                    Color.fromRGBO(255, 252, 216, 1),
                    Color.fromRGBO(254, 236, 220, 1),
                  ])
                : null,
            border: Border.all(
              color: (isToday)
                  ? (widget.todayHighlightColor ?? Colors.blue.shade300)
                  : Colors.grey.shade400,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            boxShadow: widget.boxShadows,
          ),
          width: widget.boxWidth ?? 66,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getMonthByInd(date.month),
                style: widget.monthTextStyle ??
                    TextStyle(
                        fontSize: 12,
                        color: isToday
                            ? widget.todayHighlightColor ?? Colors.black
                            : null),
              ),
              Text(
                date.day.toString(),
                style: widget.dateTextStyle ??
                    TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? widget.todayHighlightColor ?? Colors.black
                            : null),
              ),
              Text(
                getDayByInd(date.weekday),
                style: widget.weekDayTextStyle ??
                    TextStyle(
                        fontSize: 12,
                        color: isToday
                            ? widget.todayHighlightColor ?? Colors.black
                            : null),
              ),
            ],
          )),
    );
  }

  String getMonthByInd(int m) {
    switch (m) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  String getDayByInd(int m) {
    switch (m) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }
}
