import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../users/model/balance_item.model.dart';
import '../model/transaction_report_gold.model.dart';

class GoldTransactionInvoiceGenerationService {
  Future<void> generateInvoice({
    required TransactionReportGoldModel transaction,
    required String accountName,
    required List<BalanceItemModel> balanceList,
  }) async {
    try {
      final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: ttf, fontFallback: [ttf]),
          build: (pw.Context context) {
            return [
              _buildHeader(transaction, accountName),
              pw.SizedBox(height: 16),
              _buildTransactionTable(transaction),
              if (balanceList.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                _buildBalanceSection(balanceList),
              ],
              pw.SizedBox(height: 24),
              _buildFooter(),
            ];
          },
          footer: (context) => _buildPageNumber(context.pageNumber, context.pagesCount),
        ),
      );

      final bytes = await pdf.save();
      final fileName = 'gold_transaction_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..download = fileName
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: fileName,
        );
      }
    } catch (e) {
      throw Exception('خطا در تولید فاکتور تراکنش طلا: $e');
    }
  }

  pw.Widget _buildHeader(TransactionReportGoldModel tx, String accountName) {
    final typeText = _typeText(tx.type ?? '');
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('فاکتور $typeText - $accountName', style: pw.TextStyle(fontSize: 13)),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('شماره تراکنش: ${(tx.id ?? '-').toString()}', style: pw.TextStyle(fontSize: 11)),
              pw.Text('تاریخ: ${tx.date?.toPersianDate(twoDigits: true) ?? '-'}', style: pw.TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTransactionTable(TransactionReportGoldModel tx) {
    final description = _transactionDescription(tx);
    final amountText = _amountText(tx);
    final price = tx.mesghalPrice != null && (tx.mesghalPrice ?? 0) < 0
        ? '-${tx.mesghalPrice?.abs().toStringAsFixed(0).seRagham()} ریال'
        : tx.mesghalPrice != null && (tx.mesghalPrice ?? 0) > 0
        ? '${tx.mesghalPrice?.toStringAsFixed(0).seRagham()} ریال'
        : '-';
    final total = tx.totalPrice != null && (tx.totalPrice ?? 0) < 0
        ? '-${tx.totalPrice?.abs().toStringAsFixed(0).seRagham()} ریال'
        : tx.totalPrice != null && (tx.totalPrice ?? 0) > 0
        ? '${tx.totalPrice?.toStringAsFixed(0).seRagham()} ریال'
        : '-';
    final showTradeColumns = (tx.type == 'sell' || tx.type == 'buy');

    final rows = <pw.TableRow>[];
    {
      final headerCells = <pw.Widget>[
        _cell('شرح', header: true),
        _cell('مقدار', header: true),
      ];
      if (showTradeColumns) {
        headerCells.addAll([
          _cell('به مظنه', header: true),
          _cell('مبلغ کل', header: true),
        ]);
      }
      headerCells.add(_cell('ردیف', header: true));
      rows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            border: pw.Border.all(color: PdfColors.grey500),
            borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(10)),
          ),
          children: headerCells,
        ),
      );
    }

    final List<pw.Widget> dataCells = [
      _cell(description),
      _cell(amountText, center: true),
    ];
    if (showTradeColumns) {
      dataCells.addAll([
        _cell(price, center: true),
        _cell(total, center: true),
      ]);
    }
    dataCells.add(_cell('1', center: true));
    rows.add(pw.TableRow(children: dataCells));

    if ((tx.description ?? '').trim().isNotEmpty) {
      final descCells = <pw.Widget>[
        _cell('توضیحات: ${tx.description}'),
        _cell(''),
      ];
      if (showTradeColumns) {
        descCells.addAll([
          _cell(''),
          _cell(''),
        ]);
      }
      descCells.add(_cell(''));
      rows.add(pw.TableRow(children: descCells));
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey500),
        borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(10)),
      ),
      child: pw.Table(
        border: pw.TableBorder.symmetric(inside: pw.BorderSide(width: 1, color: PdfColors.grey500)),
        columnWidths: showTradeColumns
            ? {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(1.8),
          2: pw.FlexColumnWidth(2),
          3: pw.FlexColumnWidth(2.3),
          4: pw.FlexColumnWidth(0.7),
        }
            : {
          0: pw.FlexColumnWidth(3.5),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(0.7),
        },
        children: rows,
      ),
    );
  }

  pw.Widget _buildBalanceSection(List<BalanceItemModel> balanceList) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('مانده فعلی', style: pw.TextStyle(fontSize: 12)),
        pw.SizedBox(height: 6),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(10)),
          ),
          child: pw.Table(
            border: pw.TableBorder.symmetric(inside: pw.BorderSide(width: 1, color: PdfColors.grey400)),
            columnWidths: {
              0: pw.FlexColumnWidth(2.5),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(10)),
                ),
                children: [
                  _cell('مقدار', header: true),
                  _cell('واحد', header: true),
                  _cell('نام محصول', header: true),
                ],
              ),
              ...balanceList.map((e) {
                final amount = (e.item?.itemUnit?.name == 'ریال'
                    ? (e.balance ?? 0).toStringAsFixed(0).seRagham(separator: ',')
                    : (e.balance ?? 0))
                    .toString();
                return pw.TableRow(
                  children: [
                    _cell(amount, center: true),
                    _cell(e.item?.itemUnit?.name ?? '', center: true),
                    _cell(e.item?.name ?? '', center: true),
                  ],
                );
              }),
            ],
          ),
        )
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 32),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Text('امضا مسئول', style: pw.TextStyle(fontSize: 10)),
            pw.Text('مهر و امضا مشتری', style: pw.TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPageNumber(int current, int total) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 16),
      child: pw.Text(
        'صفحه ${current.toString().toPersianDigit()} از ${total.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }

  pw.Widget _cell(String text, {bool header = false, bool center = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: header ? 8 : 9, fontWeight: pw.FontWeight.normal),
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.center,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  String _typeText(String type) {
    switch (type) {
      case 'issue':
        return 'حواله دریافتی';
      case 'receive':
        return 'دریافت';
      case 'payment':
        return 'پرداخت';
      case 'sell':
        return 'فروش';
      case 'buy':
        return 'خرید';
      case 'deposit':
        return 'واریز';
      case 'withdraw':
        return 'برداشت';
      case 'reciept':
        return 'حواله پرداختی';
      case 'initial':
        return 'اول دوره';
      default:
        return 'تراکنش';
    }
  }

  String _transactionDescription(TransactionReportGoldModel tx) {
    final unitId = tx.item?.itemUnit?.id;
    final amount = tx.amount ?? 0;
    final itemName = tx.item?.name ?? '';
    final route = _transferRouteText(tx);
    final detail = tx.detail;

    String baseDesc;
    if (detail != null) {
      final parts = <String>[];
      if (detail.itemName != null) parts.add(' ${detail.itemName}');
      if (detail.carat != null && detail.carat != 0) parts.add('عیار: ${detail.carat}');
      if (detail.weight != null) parts.add('وزن: ${detail.weight}');
      if (detail.quantity != null) parts.add('مقدار: ${detail.quantity}');
      if (detail.laboratoryId != null) parts.add('ش ق: ${detail.receiptNumber}');
      if ((detail.name ?? '').isNotEmpty) parts.add('نام آز: ${detail.name}');
      baseDesc = parts.join(' ~ ');
      if (baseDesc.isEmpty) {
        baseDesc = unitId == 1
            ? amount < 0 ? '${amount.abs().toStringAsFixed(0)}- عدد $itemName' : amount > 0 ? '${amount.toStringAsFixed(0)} عدد $itemName' : ""
            : unitId == 2
            ? amount < 0 ? '${amount.abs().toString()}- گرم $itemName' : amount > 0 ? '${amount.toString()} گرم $itemName' : ""
            : amount < 0 ? '${amount.abs().toStringAsFixed(0).seRagham()}- ریال $itemName' : amount > 0 ? '${amount.toStringAsFixed(0).seRagham()} ریال $itemName' : "" ;
      }
    } else {
      baseDesc = unitId == 1
          ? amount < 0 ? '${amount.abs().toStringAsFixed(0)}- عدد $itemName' : amount > 0 ? '${amount.toStringAsFixed(0)} عدد $itemName' : ""
          : unitId == 2
          ? amount < 0 ? '${amount.abs().toString()}- گرم $itemName' : amount > 0 ? '${amount.toString()} گرم $itemName' : ""
          : amount < 0 ? '${amount.abs().toStringAsFixed(0).seRagham()}- ریال $itemName': amount > 0 ? '${amount.toStringAsFixed(0).seRagham()} ریال $itemName' : "";
    }
    // Append tracking number for deposit/withdraw types
    String trackingInfo = '';
    final type = (tx.type ?? '').trim();
    final tracking = (tx.trackingNumber ?? '').trim();
    if ((type == 'deposit' || type == 'withdraw') && tracking.isNotEmpty) {
      trackingInfo = 'ش پ: $tracking';
    }
    String desc = route.isNotEmpty ? '$route ~ $baseDesc' : baseDesc;
    if (trackingInfo.isNotEmpty) {
      desc = '$desc ~ $trackingInfo';
    }
    return desc;
  }

  String _amountText(TransactionReportGoldModel tx) {
    final unitId = tx.item?.itemUnit?.id;
    final amt = tx.amount ?? 0;
    if (unitId == 1) return amt < 0 ? '-${amt.abs().toStringAsFixed(0)}' : amt.toStringAsFixed(0);
    if (unitId == 2) return amt < 0 ? '-${amt.abs().toString().seRagham()}' : amt.toString().seRagham();
    return amt < 0 ? '-${amt.abs().toStringAsFixed(0).seRagham()}' : amt.toStringAsFixed(0).seRagham();
  }

  String _transferRouteText(TransactionReportGoldModel tx) {
    final type = tx.type ?? '';
    if (type == 'reciept' || type == 'issue') {
      final fromName = type == 'reciept'
          ? (tx.account?.name ?? '')
          : (tx.toAccount.name ?? '');
      final toName = type == 'reciept'
          ? (tx.toAccount.name ?? '')
          : (tx.account?.name ?? '');
      if (fromName.isNotEmpty || toName.isNotEmpty) {
        return 'از: $fromName  به: $toName';
      }
    }
    return '';
  }
}