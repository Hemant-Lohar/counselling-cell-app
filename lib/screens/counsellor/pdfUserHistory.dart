import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart';
import 'pdfAPI.dart';

class PdfUserHistory {
  static Future<File> generate(String user, String name) async {
    List<Widget> widgetList = [];
    final documentReference =
        FirebaseFirestore.instance.collection("users").doc(user);
    await documentReference
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      log(data["name"]);
      widgetList.add(Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Basic Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Name: ${data["name"]}"), //
            Text("Age: ${data["age"]}"), // <-
            Text("Gender: ${data["gender"]}"), //
            Text("Mobile No.: ${data["mobile"]}"), //
            Text("Department: ${data["department"]}"),
            Text("Class: ${data["class"]}"), //
            Text("Division ${data["division"]}"),
            Text("URN: ${data["urn"]}"),
            Text("Email ID: ${data["id"]}"),
            Divider(),
            Text("Session history",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]));
    });
    await documentReference.collection("completedSession").get().then(
      (querySnapshot) {
        if (querySnapshot.size == 0) {
          widgetList.add(Text("No sessions are conducted for user:$name"));
        } else {
          for (var docSnapshot in querySnapshot.docs) {
            var data = docSnapshot.data();
            widgetList.add(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Session No.: ${data["sessionNumber"]}"),
                  Text("Date: ${data["date"]}"),
                  Text("Time: ${data["timeStart"]} to ${data["timeEnd"]}"),
                  Text("Type of visit : ${data["mode"]}"),
                  Text("Observation: ${data["observation"]}"),
                  Text("New issues found: ${data["new_issues"]}"),
                  Text("Details of session: ${data["details"]}"),
                  Divider()
                ]));
          }
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

    final pdf = Document();
    pdf.addPage(MultiPage(build: (context) => widgetList));

    return  PdfAPI.saveDocument(name: '${name}_history.pdf', pdf: pdf);
  }

  // static Widget buildHeader(String user) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     SizedBox(height: 1 * PdfPageFormat.cm),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         buildSupplierAddress(invoice.supplier),
  //         Container(
  //           height: 50,
  //           width: 50,
  //           child: BarcodeWidget(
  //             barcode: Barcode.qrCode(),
  //             data: invoice.info.number,
  //           ),
  //         ),
  //       ],
  //     ),
  //     SizedBox(height: 1 * PdfPageFormat.cm),
  //     Row(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         buildCustomerAddress(invoice.customer),
  //         buildInvoiceInfo(invoice.info),
  //       ],
  //     ),
  //   ],
  // );
  //
  // static Widget buildCustomerAddress(Customer customer) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //     Text(customer.address),
  //   ],
  // );
  //
  // static Widget buildInvoiceInfo(InvoiceInfo info) {
  //   final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
  //   final titles = <String>[
  //     'Invoice Number:',
  //     'Invoice Date:',
  //     'Payment Terms:',
  //     'Due Date:'
  //   ];
  //   final data = <String>[
  //     info.number,
  //     Utils.formatDate(info.date),
  //     paymentTerms,
  //     Utils.formatDate(info.dueDate),
  //   ];
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: List.generate(titles.length, (index) {
  //       final title = titles[index];
  //       final value = data[index];
  //
  //       return buildText(title: title, value: value, width: 200);
  //     }),
  //   );
  // }
  //
  // static Widget buildSupplierAddress(Supplier supplier) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //     SizedBox(height: 1 * PdfPageFormat.mm),
  //     Text(supplier.address),
  //   ],
  // );
  //
  // static Widget buildTitle(String user) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(
  //       'INVOICE',
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //     ),
  //     SizedBox(height: 0.8 * PdfPageFormat.cm),
  //     Text(invoice.info.description),
  //     SizedBox(height: 0.8 * PdfPageFormat.cm),
  //   ],
  // );
  //
  // static Widget buildInvoice(String user) {
  //   final headers = [
  //     'Description',
  //     'Date',
  //     'Quantity',
  //     'Unit Price',
  //     'VAT',
  //     'Total'
  //   ];
  //   final data = invoice.items.map((item) {
  //     final total = item.unitPrice * item.quantity * (1 + item.vat);
  //
  //     return [
  //       item.description,
  //       Utils.formatDate(item.date),
  //       '${item.quantity}',
  //       '\$ ${item.unitPrice}',
  //       '${item.vat} %',
  //       '\$ ${total.toStringAsFixed(2)}',
  //     ];
  //   }).toList();
  //
  //   return Table.fromTextArray(
  //     headers: headers,
  //     data: data,
  //     border: null,
  //     headerStyle: TextStyle(fontWeight: FontWeight.bold),
  //     headerDecoration: BoxDecoration(color: PdfColors.grey300),
  //     cellHeight: 30,
  //     cellAlignments: {
  //       0: Alignment.centerLeft,
  //       1: Alignment.centerRight,
  //       2: Alignment.centerRight,
  //       3: Alignment.centerRight,
  //       4: Alignment.centerRight,
  //       5: Alignment.centerRight,
  //     },
  //   );
  // }
  //
  // static Widget buildTotal(String user) {
  //   final netTotal = invoice.items
  //       .map((item) => item.unitPrice * item.quantity)
  //       .reduce((item1, item2) => item1 + item2);
  //   final vatPercent = invoice.items.first.vat;
  //   final vat = netTotal * vatPercent;
  //   final total = netTotal + vat;
  //
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     child: Row(
  //       children: [
  //         Spacer(flex: 6),
  //         Expanded(
  //           flex: 4,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               buildText(
  //                 title: 'Net total',
  //                 value: Utils.formatPrice(netTotal),
  //                 unite: true,
  //               ),
  //               buildText(
  //                 title: 'Vat ${vatPercent * 100} %',
  //                 value: Utils.formatPrice(vat),
  //                 unite: true,
  //               ),
  //               Divider(),
  //               buildText(
  //                 title: 'Total amount due',
  //                 titleStyle: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 value: Utils.formatPrice(total),
  //                 unite: true,
  //               ),
  //               SizedBox(height: 2 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //               SizedBox(height: 0.5 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // static Widget buildFooter(Invoice invoice) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   children: [
  //     Divider(),
  //     SizedBox(height: 2 * PdfPageFormat.mm),
  //     buildSimpleText(title: 'Address', value: invoice.supplier.address),
  //     SizedBox(height: 1 * PdfPageFormat.mm),
  //     buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
  //   ],
  // );
  //
  // static buildSimpleText({
  //   required String title,
  //   required String value,
  // }) {
  //   final style = TextStyle(fontWeight: FontWeight.bold);
  //
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: pw.CrossAxisAlignment.end,
  //     children: [
  //       Text(title, style: style),
  //       SizedBox(width: 2 * PdfPageFormat.mm),
  //       Text(value),
  //     ],
  //   );
  // }
  //
  // static buildText({
  //   required String title,
  //   required String value,
  //   double width = double.infinity,
  //   TextStyle? titleStyle,
  //   bool unite = false,
  // }) {
  //   final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);
  //
  //   return Container(
  //     width: width,
  //     child: Row(
  //       children: [
  //         Expanded(child: Text(title, style: style)),
  //         Text(value, style: unite ? style : null),
  //       ],
  //     ),
  //   );
  // }
}
