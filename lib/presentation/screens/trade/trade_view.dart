import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/theme/responsive_ui.dart';
import 'package:http/http.dart'as http;
class TradeView extends StatefulWidget {
  const TradeView({super.key});

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {

  Map<String, dynamic>? quoteData;
  Map<String, dynamic>? accountData;
  String symbol = "EURUSD";
  String statusMessage = "";
  bool isLoading = true;
  String errorMessage = "";
  List<Map<String, dynamic>> chartData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _fetchData();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      fetchQuotes();
      fetchChartData();
    });
  }


  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try{
      await Future.wait([
        fetchQuotes(),
        fetchAccountInfo(),
        fetchChartData(),
      ]);
    }catch(e){
      setState(() {
        errorMessage = "failed to load data: $e";
      });
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void>fetchQuotes()async{

    try{
      final response = await http
          .get(Uri.parse('http://192.168.68.66:8000/quotes/$symbol'))
          .timeout(Duration(seconds: 3));

      if(response.statusCode == 200){
        setState(() {
          quoteData = json.decode(response.body);
        });
      }else{
        setState(() {
          errorMessage = "Failed to load quotes: ${response.statusCode}";
        });
      }
    }catch(e){
      setState(() {
        errorMessage = "Quotes error: $e";
      });
    }
  }
  Future<void>fetchAccountInfo()async{
    try{
      final response = await http
          .get(Uri.parse('http://192.168.68.66:8000/account'))
          .timeout(Duration(seconds: 3));
      if(response.statusCode == 200){
        setState(() {
          accountData = json.decode(response.body);
        });
      }else{
        setState(() {
          errorMessage = "Failed to load account info: ${response.statusCode}";
        });
      }
    }catch(e){
      setState(() {
        errorMessage = "Account error: $e";
      });
    }

  }
  Future<void> fetchChartData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.68.66:8000/history/$symbol/20'))
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          chartData = data.cast<Map<String, dynamic>>();
          errorMessage = '';

        });
      }else{
        setState(() {
          errorMessage = "Failed to load chart data: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Chart error: $e";
      });
    }
  }
  Future<void>placeOrder(String orderType, double volume)async{
    setState(() {
      statusMessage = "Placing order...";
      print(statusMessage);

    });
    try{
      final response = await http
          .post(Uri.parse('http://192.168.68.66:8000/order/$symbol/$orderType/$volume'))
          .timeout(Duration(seconds: 3));
      setState(() {
        statusMessage = json.decode(response.body)['error'] ?? 'Order placed successfully';
        print(statusMessage);
      });

    }catch(e){
      setState(() {
        statusMessage = "Order error: $e";
        print(statusMessage);

      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.primaryBackgroundColor,
            appBar: AppBar(
              title: Text('Trade',style: AppTextStyle.h3(context,color: AppColors.primaryText),),
              centerTitle: true,
              backgroundColor: AppColors.primaryBackgroundColor),
            body: ResponsiveViewState(
              mobile: body(),
              tablet: body(),
            )
        )
    );
  }

  Widget body() {
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;

    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Configure MetaApi Account',
                  style: AppTextStyle.h3(context,color: AppColors.descriptions),
                ),
                SizedBox(height: screenHeight * 0.04),

                if(isLoading)
                  Center(child: CircularProgressIndicator())
                else if(errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: AppTextStyle.bodySmall(context,color: AppColors.redErrorCall),
                  )
                else ...[
                    Text(
                      'Account Balance: ${accountData?['balance']?.toStringAsFixed(2) ?? 'Loading...'}',
                      style: AppTextStyle.label(context,color: AppColors.descriptions),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Equity: ${accountData?['equity']?.toStringAsFixed(2) ?? 'Loading...'}',
                      style: AppTextStyle.bodySmall(context,color: AppColors.descriptions),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Symbol: $symbol',
                      style: AppTextStyle.bodySmall(context,color: AppColors.descriptions),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Bid: ${quoteData?['bid']?.toStringAsFixed(5) ?? 'Loading...'}',
                      style: AppTextStyle.bodySmall(context,color: AppColors.descriptions),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Ask: ${quoteData?['ask']?.toStringAsFixed(5) ?? 'Loading...'}',
                      style: AppTextStyle.bodySmall(context,color: AppColors.descriptions),
                    ),
                  ],

                SizedBox(height: screenHeight * 0.02),

                ///  Chart
                SizedBox(
                  height: screenHeight * 0.45,
                  child: chartData.isNotEmpty
                      ? SfCartesianChart(
                    // Enable zoom and pan
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true, // Pinch-to-zoom
                      enablePanning: true, // Drag to pan
                      zoomMode: ZoomMode.xy, // Zoom both axes
                      enableDoubleTapZooming: true, // Double-tap to zoom
                      enableMouseWheelZooming: true, // Disable for mobile
                    ),
                    // for detailed tooltip
                    trackballBehavior: TrackballBehavior(
                      enable: true,

                      lineType: TrackballLineType.vertical,
                        lineColor: AppColors.descriptions.withOpacity(0.5),
                        lineWidth: 1,
                      activationMode: ActivationMode.singleTap,
                      tooltipSettings: InteractiveTooltip(
                        enable: true,
                        color: AppColors.primaryBackgroundColor.withOpacity(0.8),
                        textStyle: AppTextStyle.bodySmall(context, color: AppColors.descriptions),
                        format: 'Time: point.x\nOpen: point.open\nHigh: point.high\nLow: point.low\nClose: point.y',
                        decimalPlaces: 5,
                      ),
                      tooltipAlignment: ChartAlignment.near,
                      tooltipDisplayMode: TrackballDisplayMode.floatAllPoints
                    ),

                    crosshairBehavior: CrosshairBehavior(
                      enable: true,
                      lineType: CrosshairLineType.both,
                      lineColor: AppColors.descriptions.withOpacity(0.5),
                      lineWidth: 1,
                      shouldAlwaysShow: true,
                    ),

                    // Background and border
                    backgroundColor: AppColors.primaryBackgroundColor,
                    plotAreaBorderWidth: 0,
                    // X-axis (time)
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat('HH:mm'),
                      interval: 1, // Show every minute
                      majorGridLines: MajorGridLines(width: 0), // No vertical grid lines
                      minorTicksPerInterval: 0,
                      labelStyle: AppTextStyle.bodySmall(context, color: AppColors.descriptions),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      majorTickLines: MajorTickLines(size: 4, color: AppColors.descriptions),
                      axisLine: AxisLine(color: AppColors.descriptions.withOpacity(0.5)),
                    ),
                    // Y-axis (price)
                    primaryYAxis: NumericAxis(
                      decimalPlaces: 5, // EURUSD precision
                      interval: 0.0002, // Tighter intervals for readability
                      majorGridLines: MajorGridLines(
                        width: 1,
                        color: AppColors.descriptions.withOpacity(0.3),
                      ),
                      minorGridLines: MinorGridLines(
                        width: 0.5,
                        color: AppColors.descriptions.withOpacity(0.2),
                      ),
                      labelStyle: AppTextStyle.bodySmall(context, color: AppColors.descriptions),
                      majorTickLines: MajorTickLines(size: 4, color: AppColors.descriptions),
                      axisLine: AxisLine(color: AppColors.descriptions.withOpacity(0.5)),
                      minimum: chartData
                          .map((e) => e['low'].toDouble())
                          .reduce((a, b) => a < b ? a : b) -
                          0.0003, // Slightly below min low
                      maximum: chartData
                          .map((e) => e['high'].toDouble())
                          .reduce((a, b) => a > b ? a : b) +
                          0.0003, // Slightly above max high
                    ),
                    // Candlestick series
                    series: <CandleSeries>[
                      CandleSeries<Map<String, dynamic>, DateTime>(
                        dataSource: chartData,
                        xValueMapper: (Map<String, dynamic> data, _) =>
                            DateTime.fromMillisecondsSinceEpoch(data['time'] * 1000),
                        openValueMapper: (Map<String, dynamic> data, _) => data['open'].toDouble(),
                        highValueMapper: (Map<String, dynamic> data, _) => data['high'].toDouble(),
                        lowValueMapper: (Map<String, dynamic> data, _) => data['low'].toDouble(),
                        closeValueMapper: (Map<String, dynamic> data, _) => data['close'].toDouble(),
                        bullColor: AppColors.green, // Green for up candles
                        bearColor: AppColors.redErrorCall, // Red for down candles
                        borderWidth: 1, // Thicker candles for XM-like look
                        enableSolidCandles: true, // Filled candles
                      ),
                    ],
                  )
                      : SfCartesianChart( // Fallback to simple candlestick chart
                    primaryXAxis: NumericAxis(
                      interval: 1,
                      labelRotation: 45,
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: AppTextStyle.bodySmall(context, color: AppColors.descriptions),
                    ),
                    primaryYAxis: NumericAxis(
                      decimalPlaces: 5,
                      interval: 0.0002,
                      majorGridLines: MajorGridLines(
                        width: 1,
                        color: AppColors.descriptions.withOpacity(0.3),
                      ),
                      labelStyle: AppTextStyle.bodySmall(context, color: AppColors.descriptions),
                      minimum: 1.12300,
                      maximum: 1.12400,
                    ),
                    series: <CandleSeries>[
                      CandleSeries<Map<String, dynamic>, double>(
                        dataSource: [
                          {'x': 0, 'open': 1.12345, 'high': 1.12350, 'low': 1.12340, 'close': 1.12345},
                          {'x': 1, 'open': 1.12345, 'high': 1.12355, 'low': 1.12340, 'close': 1.12350},
                          {'x': 2, 'open': 1.12350, 'high': 1.12350, 'low': 1.12335, 'close': 1.12340},
                          {'x': 3, 'open': 1.12340, 'high': 1.12365, 'low': 1.12340, 'close': 1.12360},
                          {'x': 4, 'open': 1.12360, 'high': 1.12365, 'low': 1.12350, 'close': 1.12355},
                        ],
                        xValueMapper: (Map<String, dynamic> data, _) => data['x'].toDouble(),
                        openValueMapper: (Map<String, dynamic> data, _) => data['open'].toDouble(),
                        highValueMapper: (Map<String, dynamic> data, _) => data['high'].toDouble(),
                        lowValueMapper: (Map<String, dynamic> data, _) => data['low'].toDouble(),
                        closeValueMapper: (Map<String, dynamic> data, _) => data['close'].toDouble(),
                        bullColor: AppColors.green,
                        bearColor: AppColors.redErrorCall,
                        borderWidth: 1,
                        enableSolidCandles: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                SizedBox(width: screenWidth * 0.02),
                Text(
                  statusMessage,
                  style: AppTextStyle.bodySmall(context,color: AppColors.descriptions),
                ),
                SizedBox(width: screenWidth * 0.05),

              ]
          ),
        )
    );
  }

}


