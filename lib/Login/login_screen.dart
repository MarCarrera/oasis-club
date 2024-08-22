import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/models/models.dart';
import '../controller/request/service.dart';
import '../home/home_screen.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/curved_clipper.dart';
import '../utils/shared_prefs_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _generalError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final userData = await SharedPrefsUtil.loadUserData();
    setState(() {
      _emailController.text = userData['email'] ?? '';
      _rememberMe = userData['rememberMe'] ?? false;
    });
  }

  void _saveUserData(
      String email, String password, bool rememberMe, Usuario usuario) {
    SharedPrefsUtil.saveUserData(
      email,
      password,
      rememberMe,
      usuario,
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  Future<void> _login() async {
    setState(() {
      _generalError = null;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final loginService = LoginService();
      try {
        final loginResponse = await loginService.iniciarSesion(
          _emailController.text,
          _passwordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        if (loginResponse != null) {
          _saveUserData(
            _emailController.text,
            _passwordController.text,
            _rememberMe,
            loginResponse,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _generalError = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final padding = screenWidth * 0.10;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: !isDarkMode ? Colors.white : colorCardDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(screenHeight, screenWidth),
            _buildLoginForm(padding, isDarkMode, screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenHeight, double screenWidth) {
    return ClipPath(
      clipper: CurvedClipper(),
      child: Container(
        height: screenHeight * 0.45,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 5.0),
                FadeInDown(
                  duration: const Duration(seconds: 1),
                  child: Text(
                    'DELTA FC',
                    style: GoogleFonts.mulish(
                      textStyle:
                          titleTextStyle.copyWith(fontSize: screenWidth * 0.08),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                FadeIn(
                  duration: const Duration(seconds: 1),
                  child: Image.asset(
                    'assets/LOGO_DELTA_HIGH.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(double padding, bool isDarkMode, double screenWidth,
      double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20.0),
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: Text(
                'Ingresa tu correo electrónico y contraseña para iniciar sesión',
                style: GoogleFonts.mulish(
                  textStyle: !isDarkMode ? bodyStyle : bodyStyleDark,
                  fontSize: screenWidth * 0.04,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: CustomTextField(
                controller: _emailController,
                decoration: emailInputDecoration.copyWith(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  fillColor: !isDarkMode ? Colors.white : colorCardDark,
                  labelStyle: GoogleFonts.mulish(
                    color: !isDarkMode ? Colors.black : colorTextDark2,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                labelText: 'Usuario',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su correo electrónico';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: CustomTextField(
                controller: _passwordController,
                decoration: passwordInputDecoration.copyWith(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  fillColor: !isDarkMode ? Colors.white : colorCardDark,
                  labelStyle: GoogleFonts.mulish(
                    color: !isDarkMode ? Colors.black : colorTextDark2,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                labelText: 'Contraseña',
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: !isDarkMode ? Colors.black54 : colorTextDark2,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su contraseña';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            if (_generalError != null) ...[
              FadeInUp(
                duration: const Duration(seconds: 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _generalError!,
                    style: GoogleFonts.mulish(
                      color: Colors.red,
                      fontSize: screenWidth * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'Recordarme',
                    style: GoogleFonts.mulish(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: loginButtonBackgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.mulish(
                            textStyle: loginButtonTextStyle.copyWith(
                                fontSize: screenWidth * 0.045),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/bitalaIcon.png',
                    width: screenWidth * 0.07,
                    height: screenHeight * 0.06,
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(
                        'http://hidalgo.no-ip.info:5610/soporteBitala/index.html'),
                    child: Text(
                      'Bitala MX 2024',
                      style: GoogleFonts.mulish(
                        fontSize: screenWidth * 0.034,
                        fontWeight: FontWeight.w700,
                        color: primaryColorBlue,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/escudo3DColor.png',
                    width: screenWidth * 0.06,
                    height: screenHeight * 0.06,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
