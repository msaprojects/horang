import 'package:flutter/material.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// My app class to display the date range picker
class SyfusionDate extends StatefulWidget {
  @override
  SyfusionDates createState() => SyfusionDates();
}

/// State for MyApp
class SyfusionDates extends State<SyfusionDate> {
  String _selectedDate;
  String _dateCount;
  String _range;
  String _rangeCount;
  String _tanggalAwal, _tanggalAkhir;

  @override
  void initState() {
    _selectedDate = '';
    _dateCount = '';
    _range = '';
    _rangeCount = '';
    _tanggalAwal = '';
    _tanggalAkhir = '';
    super.initState();
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('yyyy-MM-dd')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
        _tanggalAwal =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
        _tanggalAkhir = DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Container(
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 0)),
                    DateTime.now().add(const Duration(days: 0))),
              ),
            ),
            SizedBox(
              height: 15
            ),
            Container(
              child: Text('Note : Minimum Pesanan 5 Hari')
            ),
            SizedBox(
              height: 8
            ),
            Container(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return ProdukList(
                      tanggalAwal: _tanggalAwal,
                      tanggalAkhir: _tanggalAkhir
                    );
                  }));  
                  print("hmmm  :  " + _tanggalAwal + ' + ' + _tanggalAkhir);
                },
                child: Text('SET TANGGAL'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
