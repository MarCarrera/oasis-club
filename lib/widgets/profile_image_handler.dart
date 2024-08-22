import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import '../controller/config.dart';
import '../controller/request/service.dart';
import '../utils/shared_prefs_util.dart';

class ProfileImageHandler {
  static Future<File?> pickImage(
      BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static void showImageOptions(
      BuildContext context, Function(File?) onImageSelected, String? imageUrl) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              if (imageUrl != null)
                // ListTile(
                //   leading: const Icon(Icons.visibility),
                //   title: const Text('Ver foto'),
                //   // onTap: () {
                //   //   Navigator.of(context).pop();
                //   //   _showFullImage(context,
                //   //       imageUrl); // Mostrar imagen completa con imageUrl
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Escoger de la galería'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    File? image = await pickImage(context, ImageSource.gallery);
                    if (image != null) {
                      onImageSelected(image);
                    }
                  },
                ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar una foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  File? image = await pickImage(context, ImageSource.camera);
                  if (image != null) {
                    onImageSelected(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  bool deleted = await _deleteProfileImage(context);
                  if (deleted) {
                    onImageSelected(null);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // static Future<void> _showFullImage(BuildContext context, String imageUrl) {
  //   final imageProvider = NetworkImage('$baseUrl$imageUrl');

  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: PhotoViewGallery.builder(
  //           itemCount: 1,
  //           builder: (context, index) {
  //             return PhotoViewGalleryPageOptions(
  //               imageProvider: imageProvider,
  //               minScale: PhotoViewComputedScale.contained,
  //               maxScale: PhotoViewComputedScale.covered * 2,
  //               heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
  //             );
  //           },
  //           scrollPhysics: const BouncingScrollPhysics(),
  //           backgroundDecoration: const BoxDecoration(
  //             color: Colors.black,
  //           ),
  //           pageController: PageController(),
  //         ),
  //       );
  //     },
  //   ).catchError((error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error al mostrar la imagen: $error')),
  //     );
  //   });
  // }

  static Future<bool> _deleteProfileImage(BuildContext context) async {
    try {
      String userId = await SharedPrefsUtil.getUserId();
      bool success = await ImageUploadService().eliminarImagenPerfil(userId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil eliminada')),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se pudo eliminar la foto de perfil')),
        );
      }
      return success;
    } catch (e) {
      print('Error al eliminar la foto de perfil: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocurrió un error al eliminar la foto')),
        );
      }
      return false;
    }
  }
}
