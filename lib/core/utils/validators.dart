class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'''^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$''',
  );

  static final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (!_usernameRegExp.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores (3-20 characters)';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Full name must be less than 50 characters';
    }
    return null;
  }

  static String? bookTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Book title is required';
    }
    if (value.length < 1) {
      return 'Book title must be at least 1 character';
    }
    if (value.length > 100) {
      return 'Book title must be less than 100 characters';
    }
    return null;
  }

  static String? bookDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Book description is required';
    }
    if (value.length < 10) {
      return 'Book description must be at least 10 characters';
    }
    if (value.length > 1000) {
      return 'Book description must be less than 1000 characters';
    }
    return null;
  }

  static String? chapterTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Chapter title is required';
    }
    if (value.length > 100) {
      return 'Chapter title must be less than 100 characters';
    }
    return null;
  }

  static String? chapterContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Chapter content is required';
    }
    if (value.length < 100) {
      return 'Chapter content must be at least 100 characters';
    }
    return null;
  }

  static String? bio(String? value) {
    if (value != null && value.length > 500) {
      return 'Bio must be less than 500 characters';
    }
    return null;
  }

  static String? website(String? value) {
    if (value != null && value.isNotEmpty) {
      final uri = Uri.tryParse(value);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        return 'Invalid website URL';
      }
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value != null && value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be less than $maxLength characters';
    }
    return null;
  }
}
