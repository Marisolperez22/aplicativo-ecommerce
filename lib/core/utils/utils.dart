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

}
