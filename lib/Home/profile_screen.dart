import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:clubfutbol/controller/config.dart';
import 'package:clubfutbol/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/models/models.dart';
import '../controller/request/service.dart';
import '../login/login_screen.dart';
import '../widgets/change_credentials_dialog.dart';
import '../widgets/info_card.dart';
import '../widgets/profile_image_handler.dart';
import '../utils/shared_prefs_util.dart';
import '../widgets/editable_fields_container.dart';
import '../widgets/teams_expansion_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  ProfileData? _profileData;
  bool _isLoading = true;
  bool _showPending = false;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimeout();
    _loadProfileData();
  }

  void _startTimeout() {
    Timer(const Duration(seconds: 3), () {
      if (_isLoading) {
        if (mounted) {
          setState(() {
            _showPending = true;
          });
        }
      }
    });
  }

  Future<void> _loadProfileData() async {
    final userId = await SharedPrefsUtil.getUserId();

    if (userId.isNotEmpty) {
      try {
        final profile = await ProfileService().obtenerPerfil(userId);
        if (mounted) {
          setState(() {
            _profileData = profile;
            _emailController.text = _profileData!.email;
            _imageFile = null;
            _isLoading = false;
            _showPending = false;
          });
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar(e.toString());
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        _showErrorSnackBar('ID de usuario no encontrado');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _editLoginData() {
    showUpdateLoginDataDialog(
      context: context,
      onSave: (newEmail, newPassword) async {
        final userId = await SharedPrefsUtil.getUserId();
        bool success = false;
        if (userId.isNotEmpty) {
          try {
            if (newEmail.isNotEmpty) {
              success =
                  await ProfileService().actualizarCorreo(userId, newEmail);
            }
            if (newPassword.isNotEmpty) {
              success = await ProfileService()
                  .actualizarContrasena(userId, newPassword);
            }

            if (success) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Datos de inicio de sesión actualizados con éxito')),
                );
              }
              setState(() {
                _emailController.text = newEmail;
              });
              await SharedPrefsUtil.clearUserData();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            }
          } catch (e) {
            if (mounted) {
              _showErrorSnackBar(e.toString());
            }
          }
        }
      },
      onLogout: () async {
        await SharedPrefsUtil.clearUserData();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await SharedPrefsUtil.clearUserData();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    final userId = await SharedPrefsUtil.getUserId();

    try {
      final success =
          await ImageUploadService().subirImagenPerfil(userId, imageFile);
      if (success) {
        if (mounted) {
          setState(() {
            _imageFile = imageFile;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagen de perfil subida con éxito')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    }
  }

  Future<void> _deleteProfileImage() async {
    final userId = await SharedPrefsUtil.getUserId();

    try {
      final success = await ImageUploadService().eliminarImagenPerfil(userId);
      if (success) {
        if (mounted) {
          setState(() {
            _imageFile = null;
            _profileData = _profileData?.copyWith(profileImage: '');
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Imagen de perfil eliminada con éxito')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    }
  }

  Future<void> _refreshProfileData() async {
    await _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _isLoading && !_showPending
          ? _buildShimmerEffect(screenWidth, screenHeight)
          : RefreshIndicator(
              onRefresh: _refreshProfileData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04,
                  bottom: screenHeight * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoCard(
                      profileData: _profileData ?? _buildPendingProfileData(),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight * 0.35,
                      imageFile: _imageFile,
                      onEditImage: () => ProfileImageHandler.showImageOptions(
                        context,
                        (image) {
                          if (image != null) {
                            _uploadProfileImage(image);
                          } else {
                            _deleteProfileImage();
                          }
                        },
                        baseUrl,
                      ),
                      onDeleteImage: _deleteProfileImage,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: (_profileData?.categories.isNotEmpty ?? false)
                          ? TeamsExpansionCard(
                              categories: _profileData!.categories,
                            )
                          : _buildPendingTeamsCard(screenWidth),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: EditableFieldsContainer(
                        email: _emailController.text.isNotEmpty
                            ? _emailController.text
                            : 'Correo pendiente',
                        onEdit: _editLoginData,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () => _logout(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColorOrange,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                              vertical: screenHeight * 0.015,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cerrar Sesión',
                            style: GoogleFonts.mulish(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ProfileData _buildPendingProfileData() {
    return ProfileData(
      id: '',
      name: 'sin definir',
      height: '0',
      weight: '0',
      age: '0',
      foot: 'sin definir',
      position: 'sin definir',
      categories: [],
      profileImage: '',
      email: 'Correo pendiente',
    );
  }

  Widget _buildPendingTeamsCard(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Text(
            'Equipos pendientes',
            style: GoogleFonts.mulish(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            top: screenWidth * 0.02,
          ),
          child: Container(
            height: 100,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                'No hay equipos disponibles',
                style: GoogleFonts.mulish(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect(double screenWidth, double screenHeight) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.35,
              color: Colors.grey[300],
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth,
              height: 50,
              color: Colors.grey[300],
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth,
              height: 50,
              color: Colors.grey[300],
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth * 0.5,
              height: 50,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
