import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/analyticalReports.repository.dart';
import 'package:hanigold_admin/src/config/repository/item.repository.dart';
import 'package:hanigold_admin/src/domain/analyticalReports/model/candle_price_chart.model.dart';
import 'package:hanigold_admin/src/domain/base/base_controller.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/product/model/socket_item.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

enum ChartPageState { loading, error, empty, loaded }

/// Timeframe options for candlestick chart
enum ChartTimeFrame {
  fiveMinutes(5, '۵m'),
  fifteenMinutes(15, '۱۵m'),
  thirtyMinutes(30, '۳۰m'),
  oneHour(60, '1h'),
  fourHours(240, '4h'),
  oneDay(720, '1d');

  final int value;
  final String label;

  const ChartTimeFrame(this.value, this.label);
}

class CandlePriceChartController extends BaseController {
  // Repositories
  final AnalyticalReportsRepository _analyticalReportsRepository = AnalyticalReportsRepository();
  final ItemRepository _itemRepository = ItemRepository();

  // State
  final Rx<ChartPageState> chartState = Rx<ChartPageState>(ChartPageState.loading);
  final Rx<ChartPageState> itemsState = Rx<ChartPageState>(ChartPageState.loading);

  // Data
  final RxList<CandlePriceChartModel> candleData = <CandlePriceChartModel>[].obs;
  final RxList<ItemModel> itemsList = <ItemModel>[].obs;

  // Selected values
  final Rxn<ItemModel> selectedItem = Rxn<ItemModel>();
  final Rx<ChartTimeFrame> selectedTimeFrame = Rx<ChartTimeFrame>(ChartTimeFrame.oneHour);

  // Date/Time controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  // Reactive date for UI updates
  final RxString selectedDate = ''.obs;
  // Reactive times for UI updates
  final RxString selectedStartTime = ''.obs;
  final RxString selectedEndTime = ''.obs;
  // Error message
  final RxString errorMessage = ''.obs;

  // Auto-refresh timer
  Timer? _refreshTimer;
  final RxBool isAutoRefreshEnabled = true.obs;
  final int refreshIntervalSeconds = 30;

  // Socket subscription
  StreamSubscription? _socketSubscription;
  final RxBool isRefreshing = false.obs;

  // Chart tooling
  final RxBool isTrendMode = false.obs;
  final RxList<CandlePriceChartModel> trendPoints = <CandlePriceChartModel>[].obs;
  final RxBool showVolume = true.obs;
  final RxBool showGrid = true.obs;
  final RxBool showToolbar = true.obs;
  final RxDouble toolbarLeft = 8.0.obs;
  final RxDouble toolbarTop = 100.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultValues();
    _loadItems();
    _listenToSocket();
    _setupSocketReconnectionHandler();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _socketSubscription?.cancel();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.onClose();
  }

  /// Setup handler to re-subscribe when socket reconnects
  void _setupSocketReconnectionHandler() {
    ever(isSocketConnected, (bool connected) {
      if (connected) {
        _listenToSocket();
      }
    });
  }

  /// Listen to socket messages for real-time price updates
  void _listenToSocket() {
    _socketSubscription?.cancel();
    _socketSubscription = socketService.messageStream.listen((message) {
      try {
        Map<String, dynamic>? data;
        if (message is String) {
          data = json.decode(message);
        } else if (message is Map) {
          data = Map<String, dynamic>.from(message);
        }

        if (data != null && data['channel'] == 'itemPrice') {
          final socketItem = SocketItemModel.fromJson(data);

          // Update the specific item in itemsList without full refresh
          _updateItemPrice(socketItem);

          // If the updated item is the currently selected item, silently refresh chart data
          if (selectedItem.value?.id == socketItem.id) {
            _refreshCandleDataSilently();
          }
        }
      } catch (e) {
        print('Error processing socket message in CandlePriceChartController: $e');
      }
    }, onError: (error) {
      print('Socket stream error in CandlePriceChartController: $error');
      Future.delayed(const Duration(seconds: 2), () {
        if (socketService.isConnected) {
          _listenToSocket();
        }
      });
    });
  }

  /// Update specific item price in itemsList reactively (no full reload)
  void _updateItemPrice(SocketItemModel socketItem) {
    final index = itemsList.indexWhere((item) => item.id == socketItem.id);
    if (index != -1) {
      // Update only the changed price fields
      itemsList[index].price = socketItem.price;
      itemsList[index].differentPrice = socketItem.differentPrice;
      itemsList[index].mesghalPrice = socketItem.mesghalPrice;
      itemsList[index].mesghalDifferentPrice = socketItem.mesghalDifferentPrice;

      // Trigger reactive update
      itemsList.refresh();

    }
  }

  /// Silently refresh candle data without changing loading state
  Future<void> _refreshCandleDataSilently() async {
    if (selectedItem.value == null || isRefreshing.value) return;

    isRefreshing.value = true;
    try {
      final itemId = selectedItem.value!.id ?? 0;
      final timeFrame = selectedTimeFrame.value.value;
      final date = _convertJalaliToGregorian(dateController.text);
      final startTime = startTimeController.text;
      final endTime = endTimeController.text;

      final data = await _analyticalReportsRepository.getCandlePriceChartList(
        itemId,
        timeFrame,
        date,
        startTime,
        endTime,
      );

      if (data.isNotEmpty) {
        candleData.assignAll(data);
      }
    } catch (e) {
      print('Error in silent candle data refresh: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Initialize default date and time values
  void _initializeDefaultValues() {
    final now = Jalali.now();
    final defaultDate = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
    dateController.text = defaultDate;
    selectedDate.value = defaultDate;
    const defaultStartTime = "11:00";
    const defaultEndTime = "21:00";
    startTimeController.text = defaultStartTime;
    selectedStartTime.value = defaultStartTime;
    endTimeController.text = defaultEndTime;
    selectedEndTime.value = defaultEndTime;
  }

  /// Load items list
  Future<void> _loadItems() async {
    try {
      itemsState.value = ChartPageState.loading;
      final items = await _itemRepository.getItemList(showChart: '1');


      if (items.isEmpty) {
        itemsState.value = ChartPageState.empty;
        return;
      }

      itemsList.assignAll(items);
      itemsState.value = ChartPageState.loaded;

      // Auto-select first item if available
      if (items.isNotEmpty && selectedItem.value == null) {
        selectItem(items.first);
      }
    } catch (e) {
      print("Error loading items: $e");
      itemsState.value = ChartPageState.error;
      errorMessage.value = 'خطا در دریافت لیست محصولات';
    }
  }

  /// Select an item and load its chart data
  void selectItem(ItemModel item) {
    selectedItem.value = item;
    loadCandleData();
    //_startAutoRefresh();
  }

  /// Change timeframe and reload data
  void changeTimeFrame(ChartTimeFrame timeFrame) {
    selectedTimeFrame.value = timeFrame;
    loadCandleData();
  }

  /// Convert Jalali date string to Gregorian for API
  String _convertJalaliToGregorian(String jalaliDateString) {
    try {
      List<String> dateComponents = jalaliDateString.split('/');
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);

      Jalali jalaliDate = Jalali(year, month, day);
      DateTime gregorianDate = jalaliDate.toDateTime();

      return "${gregorianDate.year}-${gregorianDate.month.toString().padLeft(2, '0')}-${gregorianDate.day.toString().padLeft(2, '0')}";
    } catch (e) {
      print("Error converting date: $e");
      DateTime now = DateTime.now();
      return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }
  }

  /// Load candle chart data
  Future<void> loadCandleData() async {
    if (selectedItem.value == null) {
      chartState.value = ChartPageState.empty;
      errorMessage.value = 'لطفاً یک محصول انتخاب کنید';
      return;
    }

    try {
      chartState.value = ChartPageState.loading;

      final itemId = selectedItem.value!.id ?? 0;
      final timeFrame = selectedTimeFrame.value.value;
      final date = _convertJalaliToGregorian(dateController.text);
      final startTime = startTimeController.text;
      final endTime = endTimeController.text;


      final data = await _analyticalReportsRepository.getCandlePriceChartList(
        itemId,
        timeFrame,
        date,
        startTime,
        endTime,
      );

      if (data.isEmpty) {
        candleData.clear();
        chartState.value = ChartPageState.empty;
        errorMessage.value = 'داده‌ای برای نمایش وجود ندارد';
        return;
      }

      candleData.assignAll(data);
      chartState.value = ChartPageState.loaded;
      errorMessage.value = '';
    } catch (e) {
      print("Error loading candle data: $e");
      chartState.value = ChartPageState.error;
      errorMessage.value = 'خطا در دریافت اطلاعات نمودار';
    }
  }

  /// Start auto-refresh timer
  /*void _startAutoRefresh() {
    _refreshTimer?.cancel();
    if (isAutoRefreshEnabled.value) {
      _refreshTimer = Timer.periodic(
        Duration(seconds: refreshIntervalSeconds),
            (_) => loadCandleData(),
      );
    }
  }*/

  /// Toggle auto-refresh
  /*void toggleAutoRefresh() {
    isAutoRefreshEnabled.value = !isAutoRefreshEnabled.value;
    if (isAutoRefreshEnabled.value) {
      _startAutoRefresh();
    } else {
      _refreshTimer?.cancel();
    }
  }*/

  /// Manual refresh
  Future<void> refresh() async {
    await loadCandleData();
  }

  /// Update date and reload
  void updateDate(String date) {
    dateController.text = date;
    selectedDate.value = date;
    loadCandleData();
  }

  /// Update start time and reload
  void updateStartTime(String time) {
    startTimeController.text = time;
    selectedStartTime.value = time;
    loadCandleData();
  }

  /// Update end time and reload
  void updateEndTime(String time) {
    endTimeController.text = time;
    selectedEndTime.value = time;
    loadCandleData();
  }

  /// Get price change percentage between first and last candle
  double getPriceChangePercent() {
    if (candleData.isEmpty || candleData.length < 2) return 0;

    final firstPrice = candleData.first.openPrice ?? 0;
    final lastPrice = candleData.last.closePrice ?? 0;

    if (firstPrice == 0) return 0;

    return ((lastPrice - firstPrice) / firstPrice) * 100;
  }

  /// Get highest price from candle data
  int getHighestPrice() {
    if (candleData.isEmpty) return 0;
    return candleData.map((c) => c.highPrice ?? 0).reduce((a, b) => a > b ? a : b);
  }

  /// Get lowest price from candle data
  int getLowestPrice() {
    if (candleData.isEmpty) return 0;
    return candleData.map((c) => c.lowPrice ?? 0).reduce((a, b) => a < b ? a : b);
  }

  /// Get total volume
  double getTotalVolume() {
    if (candleData.isEmpty) return 0;
    return candleData.map((c) => c.volume ?? 0).fold(0, (a, b) => a + b);
  }

  /// Toggle trend drawing mode
  void toggleTrendMode() {
    isTrendMode.value = !isTrendMode.value;
    if (!isTrendMode.value) {
      trendPoints.clear();
    }
  }

  /// Add a point to the current trend line (max 2 points)
  void addTrendPoint(CandlePriceChartModel point) {
    if (!isTrendMode.value) return;
    if (trendPoints.length >= 2) {
      trendPoints.clear();
    }
    trendPoints.add(point);
    trendPoints.refresh();
  }

  bool get hasTrendLine => trendPoints.length == 2;

  void clearTrendLine() {
    trendPoints.clear();
  }

  void toggleVolumeVisibility() {
    showVolume.value = !showVolume.value;
  }

  void toggleGridVisibility() {
    showGrid.value = !showGrid.value;
  }

  void toggleToolbarVisibility() {
    showToolbar.value = !showToolbar.value;
  }

  /// Update toolbar position with clamping to screen bounds
  void updateToolbarPosition(Offset delta, Size screenSize, Size toolbarSize) {
    final newLeft = (toolbarLeft.value + delta.dx).clamp(0.0, screenSize.width - toolbarSize.width);
    final newTop = (toolbarTop.value + delta.dy).clamp(0.0, screenSize.height - toolbarSize.height);
    toolbarLeft.value = newLeft;
    toolbarTop.value = newTop;
  }

}



