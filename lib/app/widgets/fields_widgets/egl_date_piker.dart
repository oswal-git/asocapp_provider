import 'package:asocapp/app/controllers/article/article_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EglDatePiker extends StatefulWidget {
  const EglDatePiker({
    super.key,
    required this.onDateChanged,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    this.labelText = '',
    this.readOnly = false,
    this.languageCode = 'es',
    this.countryCode = 'ES',
    this.paddingLeft = 20,
    this.paddingRight = 20,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.icon,
    this.iconLabel,
    this.ronudIconBorder = false,
    this.contentPaddingLeft = 6,
    this.contentPaddingRight = 6,
    this.contentPaddingTop = 12,
    this.contentPaddingBottom = 12,
    this.borderRadius = 30,
    this.borderColor = Colors.redAccent,
    this.enabledBorderWidth = 1,
    this.borderWidth = 1,
    this.borderFocusColor = Colors.redAccent,
    this.focusedBorderWidth = 2,
    this.prefixIconPaddingLeft = 30,
    this.prefixIconPaddingRight = 10,
    this.prefixIconPaddingTop = 0,
    this.prefixIconPaddingBottom = 0,
    this.canReset = true,
  });

  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String labelText;
  final bool readOnly;
  final bool canReset;
  final String languageCode;
  final String countryCode;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final IconData? icon;
  final IconData? iconLabel;
  final bool ronudIconBorder;
  final double borderRadius;
  final Color borderColor;
  final double enabledBorderWidth;
  final double borderWidth;
  final Color borderFocusColor;
  final double focusedBorderWidth;
  final double contentPaddingLeft;
  final double contentPaddingRight;
  final double contentPaddingTop;
  final double contentPaddingBottom;
  final double prefixIconPaddingLeft;
  final double prefixIconPaddingRight;
  final double prefixIconPaddingTop;
  final double prefixIconPaddingBottom;

  final ValueChanged<DateTime> onDateChanged;

  @override
  State<EglDatePiker> createState() => _EglDatePikerState();
}

class _EglDatePikerState extends State<EglDatePiker> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArticleEditController>(
      create: (context) => ArticleEditController(context),
      child: Consumer<ArticleEditController>(
        builder: (context, controller, child) => InputDecorator(
          decoration: InputDecoration(
            label: Row(mainAxisSize: MainAxisSize.min, children: [
              if (widget.iconLabel != null)
                Container(
                  decoration: widget.ronudIconBorder
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        )
                      : null,
                  child: Icon(
                    widget.iconLabel,
                    size: widget.ronudIconBorder ? 16.0 : 22.0,
                    color: Colors.black,
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(
                  left: widget.iconLabel == null ? 0.0 : 8.0,
                ),
                child: Text(
                  widget.labelText,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ]),
            contentPadding: EdgeInsets.only(
              left: widget.contentPaddingLeft,
              right: widget.contentPaddingRight,
              top: widget.contentPaddingTop,
              bottom: widget.contentPaddingBottom,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor,
                width: widget.enabledBorderWidth,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor,
                width: widget.borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.borderFocusColor,
                width: widget.focusedBorderWidth,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            helperText: '',
            helperMaxLines: 2,
            prefixIcon: widget.icon == null
                ? null
                : IconButton(
                    onPressed: () {},
                    icon: Icon(
                      widget.icon,
                      color: Colors.blue,
                    )), // adjust size as needed
            errorMaxLines: 2,
            errorStyle: const TextStyle(
              height: 1,
              fontSize: 11,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, controller),
                  // child: Text(DateFormat('dd/MM/yyyy').format(selectedDate))),
                  child: buildDateTimePicker(
                      widget.selectedDate.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(widget.selectedDate)),
                ),
              ),
              if (widget.canReset && widget.selectedDate != DateTime(4000))
                InkWell(
                  onTap: () async {
                    widget.onDateChanged(DateTime(4000));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Color.fromRGBO(224, 57, 6, 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, ArticleEditController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        helpText: 'Select date',
        initialDate: widget.selectedDate.isAtSameMomentAs(DateTime(4000)) ? widget.firstDate : widget.selectedDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        locale: Locale(widget.languageCode),
        currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        fieldLabelText: 'Fechita',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blueGrey,
              accentColor: const Color.fromRGBO(58, 46, 46, 1),
              backgroundColor: Colors.lightBlue,
              cardColor: Colors.white,
            )),
            child: child!,
          );
        });

    if (pickedDate != null && pickedDate != widget.selectedDate) {
      widget.onDateChanged(pickedDate);
      // onChanged(dateController.value);
    }
  }

  Widget buildDateTimePicker(String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10.0),
      //   side: const BorderSide(color: Color.fromRGBO(92, 67, 83, 1), width: 0.5),
      // ),
      children: [
        Text(
          data,
          style: const TextStyle(fontSize: 14),
        ),
        const Icon(
          Icons.calendar_today,
          color: Color.fromRGBO(92, 67, 83, 1),
        ),
      ],
    );
  }
}
