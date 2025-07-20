class Utils {
  static String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un valor';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  static int calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 6;
    if (screenWidth > 900) return 5;
    if (screenWidth > 600) return 3;
    return 2;
  }

  static double calculateChildAspectRatio(double screenWidth) {
    if (screenWidth > 1200) return 0.65;
    if (screenWidth > 900) return 0.7;
    return 0.75;
  }
  
}
