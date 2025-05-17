import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/community_post_model.dart';
import 'package:doctor_appointment_user/views/all_comments_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCommmunityPosts extends StatefulWidget {
  const AllCommmunityPosts({super.key});

  @override
  State<AllCommmunityPosts> createState() => _AllCommmunityPostsState();
}

class _AllCommmunityPostsState extends State<AllCommmunityPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Community Posts",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection("community_posts")
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      );
                    }
                    final communityPostsList =
                        snapshot.data!.docs
                            .map(
                              (json) => CommunityPostModel.fromMap(json.data()),
                            )
                            .toList();
                    return ListView.builder(
                      itemCount: communityPostsList.length,
                      itemBuilder: (context, index) {
                        final communityPost = communityPostsList[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AllCommentsView(
                                  communityPostModel: communityPost,
                                )));
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),

                                  child: Image.network(
                                    communityPost.adminImageUrl.toString(),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                communityPost.postTitle.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      communityPost.postDescription.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Author Name: ',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                communityPost.adminName
                                                    .toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: .5,
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.black),
                            ),
                          ],
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
