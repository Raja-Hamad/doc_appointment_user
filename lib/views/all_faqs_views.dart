import 'package:doctor_appointment_user/model/faq_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';

class FaqsView extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
  
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text("All FAQs",
                style: GoogleFonts.poppins(color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore.collection("faqs").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                
                    final faqDocs = snapshot.data!.docs;
                
                    if (faqDocs.isEmpty) {
                      return Center(
                        child: Text(
                          "No FAQs available at the moment.",
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      );
                    }
                
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: faqDocs.length,
                      itemBuilder: (context, index) {
                        final faq = FaqModel.fromJson(faqDocs[index].data());
                
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              unselectedWidgetColor: AppColors.primary,
                              colorScheme: Theme.of(context).colorScheme.copyWith(
                                    primary: AppColors.primary,
                                  ),
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              title: Text(
                                faq.question ?? "",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              children: [
                                Text(
                                  faq.answer ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
