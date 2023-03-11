import 'package:flutter/material.dart';

class Filter {
  ///
  /// Displayed label
  ///
  final String label;
  final Function action;

  ///
  /// The displayed icon when selected
  ///

  const Filter({
    required this.label,
    required this.action,
  });
}

// =============================================================================

///
/// The filter widget
///
class ChipsFilter extends StatefulWidget {
  ///
  /// The list of the filters
  ///
  final List<Filter> filters;

  ///
  /// The default selected index starting with 0
  ///
  final int selected;

  ChipsFilter({
    Key? key,
    required this.filters,
    required this.selected,
  }) : super(key: key);

  @override
  _ChipsFilterState createState() => _ChipsFilterState();
}

class _ChipsFilterState extends State<ChipsFilter> {
  ///
  /// Currently selected index
  ///
  late int selectedIndex;

  @override
  void initState() {
    // When [widget.selected] is defined, check the value and set it as
    // [selectedIndex]
    if (widget.selected >= 0 && widget.selected < widget.filters.length) {
      this.selectedIndex = widget.selected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: this.chipBuilder,
        itemCount: widget.filters.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }

  ///
  /// Build a single chip
  ///
  Widget chipBuilder(context, currentIndex) {
    Filter filter = widget.filters[currentIndex];
    bool isActive = this.selectedIndex == currentIndex;

    return GestureDetector(
      onTap: () {
        filter.action.call();
        setState(() {
          selectedIndex = currentIndex;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent : Colors.black38,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              filter.label,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
