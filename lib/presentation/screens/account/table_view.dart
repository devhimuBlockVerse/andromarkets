import 'dart:math';

import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/enums/button_type.dart';
import '../../components/buttonComponent.dart';


class OpenPositionsWidget extends StatefulWidget {
  const OpenPositionsWidget({super.key});

  @override
  State<OpenPositionsWidget> createState() => _OpenPositionsWidgetState();
}

 class _OpenPositionsWidgetState extends State<OpenPositionsWidget> {
  String _selectedView = 'Open Positions';

  final List<String> _dropdownOptions = ['Open Positions', 'Pending Order'];

  List<Map<String, dynamic>> get _mockData {
    final random = Random();
    final symbols = ['XAUUSD', 'BTCUSD', 'EURUSD', 'USDJPY', 'GBPUSD'];
    final statuses = ['Buy', 'Sell'];

    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 50; i++) {
      final status = statuses[random.nextInt(statuses.length)];
      final profitValue = (random.nextDouble() * 2000 - 1000);
      final profit = (profitValue >= 0 ? '+' : '') + profitValue.toStringAsFixed(2);
      final volume = (random.nextDouble() * 5).toStringAsFixed(2);
      final symbol = symbols[random.nextInt(symbols.length)];
      final openPrice = (random.nextDouble() * 5000 + 1000).toStringAsFixed(2);
      final positionId = (69455 + i).toString();
      final openTime = '${random.nextInt(28) + 1}.${random.nextInt(12) + 1}';
      final durationDays = random.nextInt(15);
      final durationHours = random.nextInt(24);
      final durationMinutes = random.nextInt(60);
      final duration = '${durationDays}d ${durationHours}h ${durationMinutes}m';

      data.add({
        'positionId': positionId,
        'symbol': symbol,
        'status': status,
        'volume': volume,
        'openTime': openTime,
        'openPrice': openPrice,
        'duration': duration,
        'commission': '0',
        'swap': '0',
        'profit': profit,
      });
    }

    return data;
  }



  List<Map<String, dynamic>> get _mockPendingData {
    final random = Random();
    final symbols = ['BTCUSD', 'ETHUSD', 'LTCUSD', 'XRPUSD', 'DOGEUSD'];
    final statuses = ['Buy', 'Sell'];

    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 10; i++) {
      final status = statuses[random.nextInt(statuses.length)];
      final profitValue = (random.nextDouble() * 100 - 50);
      final profit = (profitValue >= 0 ? '+' : '') + profitValue.toStringAsFixed(2);
      final volume = (random.nextDouble() * 3).toStringAsFixed(2);
      final symbol = symbols[random.nextInt(symbols.length)];
      final openPrice = (random.nextDouble() * 10000 + 1000).toStringAsFixed(2);
      final positionId = (80000 + i).toString();
      final openTime = '${random.nextInt(28) + 1}.${random.nextInt(12) + 1}';
      final durationDays = random.nextInt(10);
      final durationHours = random.nextInt(24);
      final durationMinutes = random.nextInt(60);
      final duration = '${durationDays}d ${durationHours}h ${durationMinutes}m';

      data.add({
        'positionId': positionId,
        'symbol': symbol,
        'status': status,
        'volume': volume,
        'openTime': openTime,
        'openPrice': openPrice,
        'duration': duration,
        'commission': '0',
        'swap': '0',
        'profit': profit,
      });
    }

    return data;
  }

  Stream<List<Map<String,dynamic>>> get _dataStream async*{
    await Future.delayed(const Duration(milliseconds: 500));
    yield _selectedView == 'Open Positions' ? _mockData : _mockPendingData;
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isPending = _selectedView == 'Pending Order';
    final int columnCount = isPending ? 5 : 4;
    final headerTitles = isPending ? ['Symbol', 'Status', 'Volume', 'Profit', 'Pending'] : ['Symbol', 'Status', 'Volume', 'Profit'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: _selectedView,
          iconSize: size.height * 0.05,
          iconEnabledColor: Colors.white,
          dropdownColor: AppColors.primaryBackgroundColor,
          items: _dropdownOptions
              .map((val) => DropdownMenuItem(
              value: val,
              child: Text(val, style: AppTextStyle.bodySmall(context, color: AppColors.primaryText))))
              .toList(),
          onChanged: (val) => setState(() => _selectedView = val!),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          columnWidths:  {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(2),
            if(isPending) 4: const FlexColumnWidth(1.5),
           },
           children: [
            _tableRow(context, headerTitles, isHeader: true),
          ],
        ),
        StreamBuilder<List<Map<String,dynamic>>>(
          stream: _dataStream,
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(child: const CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return Center(
                child: SizedBox(
                  width: double.infinity,
                  height: size.height * 0.35,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Table(
                      // border: TableBorder.all(color: AppColors.stroke),
                      columnWidths: {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(2),
                        if(isPending) 4: const FlexColumnWidth(1.5),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                      children: List.generate(
                            data.length * 2 - 1,
                            (i) => i.isOdd ? _dividerRow(columnCount) : _buildRow(context, data[i ~/ 2],isPending )),

                    ),
                  ),
                ),
              );

          }),

      ],
    );
  }

  TableRow _tableRow(BuildContext ctx, List<String> cells, {bool isHeader = false}) => TableRow(
    children: cells
        .map((text) => Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(ctx).size.height * 0.002),
      child: Center(child: Text(text, style: AppTextStyle.bodySmall2x(ctx, color: isHeader ? AppColors.secondaryColor3 : AppColors.primaryText))),
    )).toList(),
  );

  TableRow _buildRow(BuildContext ctx, Map<String, dynamic> row, bool isPending) {
    final isBuy = row['status'] == 'Buy';
    final isPositive = row['profit'].toString().contains('+');


    final cells = [
      _buildGestureCell(ctx, row, row['symbol']),
      _buildGestureCell(ctx, row, row['status'], color: isBuy ? AppColors.green : AppColors.redErrorCall, dotColor: true),
      _buildGestureCell(ctx, row, row['volume']),
      _buildGestureCell(ctx, row, row['profit'], color: isPositive ? AppColors.green : AppColors.redErrorCall),
    ];

    if (isPending) {
      cells.add(_buildGestureCell(ctx, row, 'Pending', color: AppColors.secondaryColor3));
    }

    return TableRow(children: cells);

  }

  Widget _buildGestureCell(BuildContext ctx, Map<String, dynamic> row, String? text, {Color? color, bool dotColor = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _showRowDetailsBottomSheet(ctx, row),
      child: _buildCell(text, color: color, dotColor: dotColor),
    );
  }


  //Inside data View
  Widget _buildCell(String? text, {Color? color, bool dotColor = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: dotColor
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text ?? '',
          style: AppTextStyle.bodySmall2x(context, color: color ?? AppColors.primaryText),
        ),
      ],
    )
        : Center(
      child: Text(
        text ?? '',
        style: AppTextStyle.bodySmall2x(context, color: color ?? AppColors.primaryText),
      ),
    ),
  );


  TableRow _dividerRow(int columnCount) => TableRow(children: List.generate(columnCount, (_) => const Divider(height: 1, color: AppColors.stroke)));

  void _showRowDetailsBottomSheet(BuildContext ctx, Map<String, dynamic> row) {
    final size = MediaQuery.of(ctx).size;
    final List<String> details = row.entries.map((e) {
      final key = "${e.key[0].toUpperCase()}${e.key.substring(1)}";
      return "$key: ${e.value}";
    }).toList();

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        minChildSize: 0.4,

        builder: (_, controller) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.62, 0.79),
              end: Alignment(-0.62, -0.79),
              colors: [Color(0xFF0D1117), Color(0xFF1D242D)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: size.width * 0.3,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
               Expanded(child: _buildDetailsList(ctx, controller, details)),
              //
              // PrimaryButton(
              //   buttonText: 'Trade',
              //   buttonType: ButtonType.primary,
              //   onPressed: (){},
              //   textStyle: AppTextStyle.bodySmall(context),
              //   leftIcon: 'assets/icons/trade.svg',
              //   iconSize: size.height * 0.02,
              //   buttonHeight: size.height * 0.045,
              // ),
              // SizedBox(height: size.height * 0.02),
              PrimaryButton(
                  buttonText:'Close Position',
                  buttonType: ButtonType.tertiary,
                  onPressed: (){},
                  textStyle: AppTextStyle.label(context),
                  leftIcon:  'assets/icons/crossIcon.svg',
                  iconColor: AppColors.gray,
                  iconSize: size.width * 0.05,
                  buttonHeight: size.height * 0.05
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context, ScrollController controller, List<String> details) {
    final size = MediaQuery.of(context).size ;
    return ListView.separated(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      itemCount: details.length,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.04,
      ),
      separatorBuilder: (_, __) => Divider(height: 25,color: AppColors.stroke),
      itemBuilder: (_, index) {
        final text = details[index];
        final parts = text.split(':');
        final key = parts.first.trim();
        final value = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';
         return Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(key, style:AppTextStyle.bodySmall(context).copyWith(color: AppColors.secondaryColor3),),
             Text(value, style:AppTextStyle.bodySmall2x(context).copyWith(color: AppColors.primaryText),),
           ],
         );
      },
    );
  }


}

