import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../users/model/balance_item.model.dart';
import '../model/transaction_info_item.model.dart';

class TransactionInvoiceGenerationWithoutBalanceService {
  /// Generate a single-transaction invoice PDF
  Future<void> generateInvoice({
    required TransactionInfoItemModel transaction,
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
              pw.SizedBox(height: 24),
              _buildFooter(),
            ];
          },
          footer: (context) => _buildPageNumber(context.pageNumber, context.pagesCount),
        ),
      );

      final bytes = await pdf.save();
      final fileName = 'transaction_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

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
      throw Exception('خطا در تولید فاکتور تراکنش: $e');
    }
  }

  pw.Widget _buildHeader(TransactionInfoItemModel tx, String accountName) {
    final typeText = _typeText(tx.type ?? '');
    return pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(color: PdfColors.grey200,borderRadius: pw.BorderRadius.circular(10),border: pw.Border.all(color: PdfColors.grey400,)
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Text('فاکتور $typeText - $accountName', style: pw.TextStyle(fontSize: 13)),
            ]),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('شماره تراکنش: ${(tx.id ?? '-').toString()}', style: pw.TextStyle(fontSize: 11)),
                pw.Text('تاریخ: ${tx.date?.toPersianDate(twoDigits: true) ?? '-'}', style: pw.TextStyle(fontSize: 11)),
              ],
            ),
            //pw.Divider(thickness: 1,color: PdfColors.grey500 ),
          ],
        )
    );
  }

  pw.Widget _buildTransactionTable(TransactionInfoItemModel tx) {
    final description = _transactionDescription(tx);
    final amountText = _amountText(tx);
    final price = tx.mesghalPrice != null && (tx.mesghalPrice ?? 0) < 0 ? '-${tx.mesghalPrice?.abs().toStringAsFixed(0).seRagham()} ریال' :
    tx.mesghalPrice != null && (tx.mesghalPrice ?? 0 ) > 0 ? '${tx.mesghalPrice?.toStringAsFixed(0).seRagham()} ریال' : '-';
    final total = tx.totalPrice != null && (tx.totalPrice ?? 0) < 0 ? '-${tx.totalPrice?.abs().toStringAsFixed(0).seRagham()} ریال' :
    tx.totalPrice != null && (tx.totalPrice ?? 0) > 0 ? '${tx.totalPrice?.toStringAsFixed(0).seRagham()} ریال' : '-';
    final showTradeColumns = (tx.type == 'sell' || tx.type == 'buy');
    final transferRoute = _transferRouteText(tx);

    final List<pw.TableRow> rows = [];
    // Header
        {
      final List<pw.Widget> headerCells = [
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
          decoration: pw.BoxDecoration(color: PdfColors.grey300,
            border: pw.Border.all(color: PdfColors.grey500,),
            borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(10), bottom: pw.Radius.circular(0)),
          ),
          children: headerCells,
        ),
      );
    }

    // Data rows (row number based on invoice's own rows)
    final details = tx.details ?? [];
    if (details.isNotEmpty) {
      for (var i = 0; i < details.length; i++) {
        final d = details[i];
        final detailDesc =
            'عیار: ${d.carat ?? 0} | وزن: ${d.weight ?? 0} | مقدار: ${d.quantity ?? 0} | ش آز: ${d.laboratoryId ?? 0} | نام آز: ${d.laboratoryName ?? ""}';
        final isLast = i == details.length - 1;
        final combinedDesc = transferRoute.isNotEmpty ? '$transferRoute | $detailDesc' : detailDesc;
        final List<pw.Widget> dataCells = [
          _cell(combinedDesc),
          _cell(isLast ? amountText : '', center: true),
        ];
        if (showTradeColumns) {
          dataCells.addAll([
            _cell(price, center: true),
            _cell(total, center: true),
          ]);
        }
        dataCells.add(_cell((i + 1).toString(), center: true));
        rows.add(pw.TableRow(children: dataCells));
      }
    } else {
      {
        final List<pw.Widget> dataCells = [
          _cell(transferRoute.isNotEmpty ? transferRoute : description),
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
      }
      if (tx.description != null && tx.description!.trim().isNotEmpty) {
        final List<pw.Widget> descCells = [
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
    }

    return pw.Container(
        decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey500),
            borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(10), bottom: pw.Radius.circular(0),)
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
        )
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

  pw.Widget _cell(String text, {bool header = false, bool center = false, int colspan = 1}) {
    final content = pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: header ? 8 : 9, fontWeight: header ? pw.FontWeight.normal : pw.FontWeight.normal),
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.center,
        textDirection: pw.TextDirection.rtl,
      ),
    );
    if (colspan > 1) {
      return pw.Container(
        alignment: center ? pw.Alignment.center : pw.Alignment.centerRight,
        padding: const pw.EdgeInsets.all(0),
        child: content,
        // Table cell spanning is not directly supported; emulate with full-width container
      );
    }
    return content;
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
      default:
        return 'تراکنش';
    }
  }

  String _transactionDescription(TransactionInfoItemModel tx) {
    if (tx.details != null && tx.details!.isNotEmpty) {
      return tx.details!
          .map((e) =>
      'عیار: ${e.carat ?? 0} | وزن: ${e.weight ?? 0} | مقدار: ${e.quantity ?? 0} | ش آز: ${e.laboratoryId ?? 0} | نام آز: ${e.laboratoryName ?? ""}')
          .join('  •  ');
    }
    final unitId = tx.item?.itemUnit?.id;
    final amount = tx.amount ?? 0;
    final itemName = tx.item?.name ?? '';
    if (unitId == 1) return amount < 0 ? '${amount.abs()}- عدد $itemName' : '$amount عدد $itemName';
    if (unitId == 2) return amount < 0 ? '${amount.abs()}- گرم $itemName' : '$amount گرم $itemName';
    return amount < 0 ? '${amount.abs().toString().seRagham()}- ریال $itemName' : '${amount.toString().seRagham()} ریال $itemName';
  }

  String _amountText(TransactionInfoItemModel tx) {
    final unitId = tx.item?.itemUnit?.id;
    final amt = tx.amount ?? 0;
    if (unitId == 1) return amt < 0 ? '-${amt.abs().toString()}' : amt.toString();
    if (unitId == 2) return amt < 0 ? '-${amt.abs().toString().seRagham()}' : amt.toString().seRagham();
    return amt.toString().seRagham();
  }

  String _transferRouteText(TransactionInfoItemModel tx) {
    final type = tx.type ?? '';
    if (type == 'reciept' || type == 'issue') {
      final fromName = type == 'reciept'
          ? (tx.toWallet?.account?.name ?? '')
          : (tx.wallet?.account?.name ?? '');
      final toName = type == 'reciept'
          ? (tx.wallet?.account?.name ?? '')
          : (tx.toWallet?.account?.name ?? '');
      if (fromName.isNotEmpty || toName.isNotEmpty) {
        return 'از: $fromName  به: $toName';
      }
    }
    return '';
  }
}