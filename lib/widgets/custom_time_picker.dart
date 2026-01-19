import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTimePicker extends StatefulWidget {
  final DateTime initialTime;
  final ValueChanged<DateTime> onTimeChanged;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _amPmController;

  @override
  void initState() {
    super.initState();
    final time = widget.initialTime;

    int hour12 = time.hour % 12;
    if (hour12 == 0) hour12 = 12;

    int amPm = time.hour >= 12 ? 1 : 0;

    _hourController = FixedExtentScrollController(initialItem: hour12 - 1);
    _minuteController = FixedExtentScrollController(initialItem: time.minute);
    _amPmController = FixedExtentScrollController(initialItem: amPm);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _amPmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          // Highlight Bar
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.05)),
                  bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hour Column
              _buildPickerColumn(
                width: 70,
                child: CupertinoPicker(
                  scrollController: _hourController,
                  itemExtent: 50,
                  looping: true,
                  onSelectedItemChanged: (index) => _notifyChange(),
                  selectionOverlay: null,
                  children: List.generate(12, (index) {
                    return Center(
                      child: Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: AppTheme.textHighlight,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Minute Column
              _buildPickerColumn(
                width: 70,
                child: CupertinoPicker(
                  scrollController: _minuteController,
                  itemExtent: 50,
                  looping: true,
                  onSelectedItemChanged: (index) => _notifyChange(),
                  selectionOverlay: null,
                  children: List.generate(60, (index) {
                    return Center(
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: AppTheme.textHighlight,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // AM/PM Column
              _buildPickerColumn(
                width: 70,
                child: CupertinoPicker(
                  scrollController: _amPmController,
                  itemExtent: 50,
                  // Looping AM/PM is usually not done in iOS but requested "Continuous scrolling" might imply it.
                  // However, strict iOS behavior doesn't loop AM/PM usually.
                  // But "Three independent vertical columns... Continuous scrolling" usually applies to numbers.
                  // I'll leave AM/PM non-looping as it's binary, or loop it if desired.
                  // Given "Continuous scrolling" requirement, I'll set it true for consistency.
                  looping: true,
                  onSelectedItemChanged: (index) => _notifyChange(),
                  selectionOverlay: null,
                  children: [
                    const Center(
                      child: Text(
                        'AM',
                        style: TextStyle(
                          color: AppTheme.textHighlight,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'PM',
                        style: TextStyle(
                          color: AppTheme.textHighlight,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Gradients
           Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.backgroundDark,
                      AppTheme.backgroundDark.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppTheme.backgroundDark,
                      AppTheme.backgroundDark.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerColumn({required double width, required Widget child}) {
    return Container(
      width: width,
      child: child,
    );
  }

  void _notifyChange() {
    // When looping is true, selectedItem returns the absolute index, which can be large.
    // We need to modulo it by the child count to get the actual value.

    int hour12Index = _hourController.selectedItem % 12;
    int hour12 = hour12Index + 1;

    int minute = _minuteController.selectedItem % 60;

    int amPmIndex = _amPmController.selectedItem % 2; // 0 or 1

    int hour24 = hour12;
    if (amPmIndex == 0) { // AM
      if (hour24 == 12) hour24 = 0;
    } else { // PM
      if (hour24 != 12) hour24 += 12;
    }

    final now = DateTime.now();
    final newTime = DateTime(now.year, now.month, now.day, hour24, minute);
    widget.onTimeChanged(newTime);
  }
}
