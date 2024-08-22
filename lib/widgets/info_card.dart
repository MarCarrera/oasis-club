import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controller/config.dart';
import '../controller/models/models.dart';
import '../utils/constants.dart';
import 'custom_clipper_card.dart';

class InfoCard extends StatelessWidget {
  final ProfileData profileData;
  final double screenWidth;
  final double screenHeight;
  final File? imageFile;
  final void Function() onEditImage;
  final void Function() onDeleteImage;

  const InfoCard({
    super.key,
    required this.profileData,
    required this.screenWidth,
    required this.screenHeight,
    required this.imageFile,
    required this.onEditImage,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomClipperCard(),
      child: Container(
        color: primaryColorOrange,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BounceInDown(
                duration: const Duration(seconds: 1),
                child: Text(
                  profileData.name,
                  style: GoogleFonts.mulish(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              FadeInUp(
                duration: const Duration(seconds: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          // ignore: deprecated_member_use
                          FontAwesomeIcons.running,
                          size: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Column(
                          children: [
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              profileData.position,
                              style: GoogleFonts.mulish(
                                fontSize: Platform.isIOS
                                    ? screenWidth * 0.028
                                    : screenWidth * 0.04,
                                //fontSize: screenWidth * 0.028, // 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.futbol,
                          size: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Pie: ${profileData.foot}',
                          style: GoogleFonts.mulish(
                            fontSize: screenWidth * 0.04,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard(
                          context,
                          title: 'EDAD',
                          value: profileData.age.toString(),
                        ),
                        _buildInfoCard(
                          context,
                          title: 'ESTATURA',
                          value: '${profileData.height}mt',
                        ),
                        _buildInfoCard(
                          context,
                          title: 'PESO',
                          value: '${profileData.weight}kg',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Stack(
                    children: [
                      InkWell(
                        onTap:
                            onEditImage, // Mantener solo la funcionalidad de edición
                        child: BounceInRight(
                          duration: const Duration(seconds: 1),
                          child: CircleAvatar(
                            radius: screenWidth * 0.12,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile!)
                                : profileData.profileImage.isNotEmpty
                                    ? NetworkImage(
                                        '$baseUrl${profileData.profileImage}')
                                    : const NetworkImage(defaultProfileImage)
                                        as ImageProvider<Object>,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: onEditImage,
                          child: CircleAvatar(
                            radius: screenWidth * 0.03,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              size: screenWidth * 0.04,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, required String value}) {
    return Flexible(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.mulish(
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Container(
                width: screenWidth * 0.08,
                height: 2,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
              ),
              Text(
                title,
                style: GoogleFonts.mulish(
                  fontSize: screenWidth * 0.02,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
