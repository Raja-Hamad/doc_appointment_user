import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/widgets/invoice_detail_view_reusable_widget.dart';
import 'package:doctor_appointment_user/widgets/invoice_pdf_generator.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceDetailView extends StatefulWidget {
  var invoice;
  InvoiceDetailView({super.key, required this.invoice});

  @override
  State<InvoiceDetailView> createState() => _InvoiceDetailViewState();
}

class _InvoiceDetailViewState extends State<InvoiceDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Appointment",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.invoice.doctorName,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.invoice.doctorSpecfication,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          Text(widget.invoice.doctorAbout),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.network(
                          widget.invoice.doctorImageUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InvoiceDetailViewReusableWidget(
                  title: "Invoice Id",
                  value: widget.invoice.id,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Appointment Id",
                  value: widget.invoice.appointmentId,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Patient Name",
                  value: widget.invoice.patientName,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Patient Contact Number",
                  value: widget.invoice.patientContactNumber,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Appointment Date",
                  value: widget.invoice.appointmentDate,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Appointment Time",
                  value: widget.invoice.appointmentTime,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Appointment Type",
                  value: widget.invoice.bookingType,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Appointment Status",
                  value: widget.invoice.bookingStatus,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Additional Note",
                  value: widget.invoice.notes,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Consultation Fee",
                  value: widget.invoice.consultationFee,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Medicines Fee",
                  value: widget.invoice.medicinesFee,
                ),
                const SizedBox(height: 20),
                InvoiceDetailViewReusableWidget(
                  title: "Total Fee",
                  value: widget.invoice.totalFee,
                ),
                const SizedBox(height: 50),
                SubmitButtonWidget(
                  buttonColor: AppColors.primary,
                  title: "Generate PDF",
                  isLoading: false,
                  onPress: () {
                    InvoicePdfGenerator.generatePdf({
                      "id": widget.invoice.id,
                      "appointmentId": widget.invoice.appointmentId,
                      "feeDiscount": widget.invoice.feeDiscount,
                      "patientContactNumber":
                          widget.invoice.patientContactNumber,
                      'consultationFee': widget.invoice.consultationFee,
                      'medicinesFee': widget.invoice.medicinesFee,
                      'totalFee': widget.invoice.totalFee,
                      'doctorName': widget.invoice.doctorName,
                      'doctorSpecfication': widget.invoice.doctorSpecfication,
                      'doctorAbout': widget.invoice.doctorAbout,
                      'doctorImageUrl': widget.invoice.doctorImageUrl,
                      'patientName': widget.invoice.patientName ?? '',
                      'date': widget.invoice.appointmentDate ?? '',
                      'time': widget.invoice.appointmentTime ?? '',
                      'status': widget.invoice.bookingStatus ?? '',
                      'type': widget.invoice.bookingType ?? '',
                      'contact': widget.invoice.patientContactNumber ?? '',
                      'note': widget.invoice.notes ?? '',
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
