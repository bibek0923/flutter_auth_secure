class Validators {

static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';

    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!regex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

static String? validateUsername(String? value ){
if(value!.trim().isEmpty ){
  return "Email is required";
}
if(value.length<6){
  return "Length should be greater than 6";
}
RegExp regExp = RegExp(r'^[\w.-]+$');
if(!regExp.hasMatch(value) ){
  return "Enter a valid usename";
}
return null;
}

static String? validatePassword(String? value){
if(value!.trim().isEmpty ){
  return "Password is required";
}
RegExp regExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
if(!regExp.hasMatch(value)){
  return "Must include upper, lower, number, special char";
}
return null;
}

static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number required';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'Enter valid 10-digit phone number';
    return null;
  }

static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm password';
    if (value != original) return 'Passwords do not match';
    return null;
  }
}
