import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

class InvoicePdfGenerator {
  static Future<void> generatePdf(Map<String, dynamic> invoice) async {
    // Fetch image if available
    Uint8List? imageBytes;
    if (invoice['doctorImageUrl'] != null &&
        invoice['doctorImageUrl'].isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(invoice['doctorImageUrl']));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        }
      } catch (e) {
        // Handle the error
      }
    }
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Invoice",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Dr. ${invoice['doctorName']}",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text("${invoice['doctorSpecfication']}"),
                      pw.Text("${invoice['doctorAbout']}"),
                    ],
                  ),
                  if (imageBytes != null)
                    pw.ClipOval(
                      child: pw.Container(
                        width: 100, // Adjust size as needed
                        height: 100,
                        child: pw.Image(
                          pw.MemoryImage(imageBytes),
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    pw.Text('No Image'),
                ],
              ),
              pw.SizedBox(height: 24),
              pw.Divider(),
              buildField("Invoice Id", invoice['id']),
              buildField("Appointment Id", invoice['appointmentId']),
              buildField("Patient Name", invoice['patientName']),
              buildField(
                "Patient Contact Number",
                invoice['patientContactNumber'],
              ),
              buildField("Date", invoice['date']),
              buildField("Time", invoice['time']),
              buildField("Status", invoice['status']),
              buildField("Type", invoice['type']),
              buildField("Contact", invoice['contact']),
              buildField("Note", invoice['note']),
              buildField("Cosultation Fee", invoice['consultationFee']),
              buildField("Medicines Fee", invoice['medicinesFee']),
              buildField("Total Fee", invoice['totalFee']),
              buildField("Fee Discount", invoice['feeDiscount']),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget buildField(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "$title:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(flex: 3, child: pw.Text(value)),
        ],
      ),
    );
  }
}
