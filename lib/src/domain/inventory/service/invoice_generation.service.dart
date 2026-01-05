import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/repository/user_info_transaction.repository.dart';
import '../../users/model/balance_item.model.dart';
import '../model/inventory.model.dart';
import '../model/inventory_detail.model.dart';

class InvoiceGenerationService {
  final UserInfoTransactionRepository userInfoTransactionRepository = UserInfoTransactionRepository();

  /// Generate invoice for inventory (both payment and receive types)
  Future<void> generateInvoice({
    required InventoryModel inventory,
    required bool includeBalance,
    required List<BalanceItemModel> balanceList,
  }) async {
    try {
      // Check if inventory details exist
      if (inventory.inventoryDetails == null || inventory.inventoryDetails!.isEmpty) {
        throw Exception('اطلاعات فاکتور موجود نیست');
      }
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
              _buildInvoiceHeader(inventory),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: _getInvoiceColumnWidths(),
                children: [
                  _buildInvoiceTableHeader(),
                  for (var i = 0; i < inventory.inventoryDetails!.length; i++)
                    _buildInvoiceDataRow(inventory.inventoryDetails![i], i, inventory.type ?? 0),
                ],
              ),
              if (includeBalance) ...[
                pw.SizedBox(height: 10),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 250,
                        child: _buildBalanceWidget(balanceList),
                      ),
                    ]
                ),
                pw.Container(
                  width: 250,
                  child: _buildBalanceGoldWidget(balanceList),
                ),
              ],
              pw.SizedBox(height: 20),
              _buildInvoiceFooter(inventory.inventoryDetails!),
            ];
          },
          footer: (context) => _buildPageNumber(context.pageNumber, context.pagesCount),
        ),
      );

      final bytes = await pdf.save();
      final fileName = (inventory.type ?? 0) == 0
          ? 'factorInventoryReceive_${DateTime.now().millisecondsSinceEpoch}.pdf'
          : 'factorInventoryPayment_${DateTime.now().millisecondsSinceEpoch}.pdf';

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
      throw Exception('خطا در تولید فاکتور: $e');
    }
  }

  pw.Widget _buildInvoiceHeader(InventoryModel inventory) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center,
            children:[
              pw.Text('فاکتور مشتری ${inventory.account?.name ?? '-'}', style: pw.TextStyle(fontSize: 15)),
            ]
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('شماره فاکتور: ${inventory.id ?? '-'}',style: pw.TextStyle(fontSize: 12)),
            pw.Text('تاریخ: ${inventory.date?.toPersianDate(twoDigits: true) ?? '-'}',style: pw.TextStyle(fontSize: 12)),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('نام ${(inventory.type ?? 0) == 0 ? 'مشتری' : 'تحویل گیرنده'}: ${(inventory.type ?? 0) == 0 ? inventory.account?.name ?? '-' : inventory.recipient ?? '-'}',style: pw.TextStyle(fontSize: 12)),
            pw.Text('شناسه مشتری: ${inventory.account?.id ?? '-'}',style: pw.TextStyle(fontSize: 12)),
          ],
        ),
        pw.Divider(thickness: 1),
      ],
    );
  }

  Map<int, pw.TableColumnWidth> _getInvoiceColumnWidths() {
    return {
      0: pw.FlexColumnWidth(2.5),
      1: pw.FlexColumnWidth(2.5),
      4: pw.FlexColumnWidth(1.5),
    };
  }

  pw.TableRow _buildInvoiceTableHeader() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Text('مقدار', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Text('محصول', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Text('ردیف', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
        ),
      ],
    );
  }

  pw.TableRow _buildInvoiceDataRow(InventoryDetailModel detail, int index, int type) {
    return pw.TableRow(
      children: [
        _buildDataCell(detail.item?.id==1  ? " گرم ${detail.weight ?? 0}, آزمایشگاه: ${detail.laboratory?.name ?? '-'}, شماره آزمایشگاه: ${detail.laboratory?.id ?? '-'}, وزن ترازو: ${detail.quantity ?? 0}, عیار: ${detail.carat ?? 0}"  :
        detail.itemUnit?.id==2 && (detail.item?.id==10 || detail.item?.id==12 || detail.item?.id==13 || detail.item?.id==14 || detail.item?.id==15 || detail.item?.id==16) ? " گرم ${detail.weight ?? 0}, عیار: ${detail.carat ?? 0}, وزن ترازو: ${detail.quantity ?? 0} "
            : detail.quantity?.toString().seRagham(separator: ",") ?? ''),
        _buildDataCell(" (${type == 0 ? 'دریافت' : 'پرداخت'}) ${detail.item?.name ?? '-'}"),
        _buildDataCell((detail.rowNum ?? index + 1).toString(), isCenter: true),
      ],
    );
  }

  // ساخت سلول‌های داده
  pw.Padding _buildDataCell(String text, {bool isCenter = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 8),
        textAlign:pw.TextAlign.center,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.Widget _buildPageNumber(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'صفحه ${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }

  pw.Widget _buildInvoiceFooter(List<InventoryDetailModel> details) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 40),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Column(
              children: [
                pw.Text('امضا مسئول',style: pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.Column(
              children: [
                pw.Text('مهر و امضا مشتری',style: pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildBalanceWidget(List<BalanceItemModel> balanceList) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('مانده فعلی', style: pw.TextStyle(fontSize: 12,)),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
          columnWidths: {
            0: pw.FlexColumnWidth(2.5),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('مقدار', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('واحد', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('نام محصول', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
              ],
            ),
            ...balanceList.map((e) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text((e.item?.itemUnit?.name=='ریال' ? e.balance.toString().seRagham(separator: ',') : e.balance ?? 0.0).toString(), style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(e.item?.itemUnit?.name ?? '', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(e.item?.name ?? '', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildBalanceGoldWidget(List<BalanceItemModel> balanceList) {
    final totalGram = balanceList
        .where((balance) => balance.item?.itemUnit?.name == "گرم")
        .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0));
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('مانده طلایی', style: pw.TextStyle(fontSize: 12,)),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
          columnWidths: {
            0: pw.FlexColumnWidth(2.5),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('مقدار', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('واحد', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text((totalGram.toStringAsFixed(3).seRagham(separator: ',')).toString() , style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('گرم', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
