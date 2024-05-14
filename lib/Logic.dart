// ignore_for_file: file_names

import 'dart:math';
import 'dart:convert';
import 'package:dart_des/dart_des.dart';
import 'package:crypto/crypto.dart';

class MonoalphabeticCipher {
  // قائمة (قائمة الأحرف) تمثل الأبجدية العادية (a-z)
  late List<String> plainAlphabet;

  // قائمة (قائمة الأحرف) تمثل الأبجدية المشفرة (يتم إنشاؤها بشكل عشوائي)
  late List<String> cipherAlphabet;

  // خريطة تشفير (مفتاح-قيمة) تربط كل حرف في النص الأصلي بالحرف المقابل له في النص المشفر
  late Map<String, String> cipherMap;

  // خريطة فك تشفير عكسية (مفتاح-قيمة) تربط كل حرف في النص المشفر بالحرف المقابل له في النص الأصلي
  late Map<String, String> reverseCipherMap;

  MonoalphabeticCipher() {
    // إنشاء قائمة الأحرف الأبجدية العادية (a-z)
    plainAlphabet = List<String>.generate(26, (int index) => String.fromCharCode(index + 97));

    // إنشاء نسخة من الأبجدية العادية
    cipherAlphabet = List<String>.from(plainAlphabet);

    // خلط الأحرف في قائمة الأبجدية المشفرة بشكل عشوائي
    cipherAlphabet.shuffle(Random());

    // إنشاء خريطة تشفير تربط كل حرف في النص الأصلي بالحرف المقابل له في النص المشفر
    // باستخدام القائمتين plainAlphabet و cipherAlphabet
    cipherMap = Map.fromIterables(plainAlphabet, cipherAlphabet);

    // إنشاء خريطة فك تشفير عكسية تربط كل حرف في النص المشفر بالحرف المقابل له في النص الأصلي
    // باستخدام القائمتين cipherAlphabet و plainAlphabet
    reverseCipherMap = Map.fromIterables(cipherAlphabet, plainAlphabet);
  }

  String encrypt(String plaintext) {
    String ciphertext = "";
    for (int i = 0; i < plaintext.length; i++) {
      String char = plaintext[i].toLowerCase();
      if (plainAlphabet.contains(char)) {
        // استبدال الحرف الحالي بالحرف المقابل له في خريطة التشفير (تشفير)
        ciphertext += cipherMap[char]!;
      } else {
        // الحرف ليس من الأبجدية، يتم إضافته كما هو إلى النص المشفر
        ciphertext += char;
      }
    }
    return ciphertext;
  }

  String decrypt(String ciphertext) {
    String plaintext = "";
    for (int i = 0; i < ciphertext.length; i++) {
      String char = ciphertext[i].toLowerCase();
      if (plainAlphabet.contains(char)) {
        // استبدال الحرف الحالي بالحرف المقابل له في خريطة فك التشفير (فك التشفير)
        plaintext += reverseCipherMap[char]!;
      } else {
        // الحرف ليس من الأبجدية، يتم إضافته كما هو إلى النص الأصلي
        plaintext += char;
      }
    }
    return plaintext;
  }
}

class CaesarCipher {

  String encrypt(String plaintext,int shift) {
    return _transform(plaintext, shift);
  }

  String decrypt(String ciphertext,int shift) {
    return _transform(ciphertext, -shift);
  }

  bool _isAlphabetic(int charCode) {
    return (charCode >= 97 && charCode <= 122) || (charCode >= 65 && charCode <= 90);
  }

  String _transform(String text, int shift) {
    final buffer = StringBuffer();
    for (final char in text.runes) {
      final isUpperCase = char >= 65 && char <= 90;
      final offset = isUpperCase ? 65 : 97;
      final charCode = _isAlphabetic(char) ? ((char - offset + shift) % 26 + offset) : char;
      buffer.writeCharCode(charCode);
    }
    return buffer.toString();
  }
}

class AffineCipher {
   int a=0;
  int b=0;
  final int m = 26; // عدد الحروف في الأبجدية الإنجليزية


  // تحقق من أن a و m أعداد أولية متبادلة
  int _modInverse(int a, int m) {
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) {
        return x;
      }
    }
    throw Exception('لا يوجد معكوس ضربي');
  }

  // تشفير حرف واحد
  int _encryptChar(int charCode) {
    return ((a * (charCode - 'A'.codeUnitAt(0)) + b) % m) + 'A'.codeUnitAt(0);

  }

  // فك تشفير حرف واحد
  int _decryptChar(int charCode) {
    int aInv = _modInverse(a, m);
    return (aInv * (charCode - 'A'.codeUnitAt(0) - b + m)) % m + 'A'.codeUnitAt(0);
  }

  // تشفير نص كامل
  String encrypt(String text,int a,int b) {
    this.a=a;
    this.b=b;
    return String.fromCharCodes(
      text.toUpperCase().codeUnits.map(_encryptChar),
    );
  }

  // فك تشفير نص كامل
  String decrypt(String text,int a,int b) {
    this.a=a;
    this.b=b;
    return String.fromCharCodes(
      text.toUpperCase().codeUnits.map(_decryptChar),
    );
  }
}
// class PlayfairCipher {
//   final String key; // Keyword (case-insensitive)
//   late final List<String> _table; // Playfair cipher table
//
//   PlayfairCipher({required this.key}) {
//     _table = generateTable(key);
//   }
//
//   String encrypt(String plaintext) {
//     plaintext = plaintext.toUpperCase().replaceAll('J', 'I').replaceAll('X', 'KS');
//     List<String> divs = _splitIntoPairs(plaintext);
//     String ciphertext = '';
//
//     for (int i = 0; i < divs.length; i += 2) {
//       final first = divs[i];
//       final second = (i + 1 < divs.length) ? divs[i + 1] : 'X'; // Add 'X' as padding if needed
//
//       final firstRow = _table.indexOf(first[0]) ~/ 5;
//       final firstCol = _table.indexOf(first[0]) % 5;
//       final secondRow = _table.indexOf(second[0]) ~/ 5;
//       final secondCol = _table.indexOf(second[0]) % 5;
//
//       final newFirst = _table[firstRow * 5 + secondCol];
//       final newSecond = _table[secondRow * 5 + firstCol];
//
//       ciphertext += newFirst + newSecond;
//     }
//
//     return ciphertext;
//   }
//
//   String decrypt(String ciphertext) {
//     ciphertext = ciphertext.toUpperCase().replaceAll('J', 'I').replaceAll('X', 'KS');
//     List<String> divs = _splitIntoPairs(ciphertext);
//     String plaintext = '';
//
//     for (int i = 0; i < divs.length; i += 2) {
//       final first = divs[i];
//       final second = (i + 1 < divs.length) ? divs[i + 1] : 'X'; // Add 'X' as padding if needed
//
//       final firstRow = _table.indexOf(first[0]) ~/ 5;
//       final firstCol = _table.indexOf(first[0]) % 5;
//       final secondRow = _table.indexOf(second[0]) ~/ 5;
//       final secondCol = _table.indexOf(second[0]) % 5;
//
//       final newFirst = _table[secondRow * 5 + firstCol];
//       final newSecond = _table[firstRow * 5 + secondCol];
//
//       plaintext += newFirst + newSecond;
//     }
//
//     return plaintext;
//   }
//
//   List<String> _splitIntoPairs(String text) {
//     List<String> divs = [];
//     for (int i = 0; i < text.length; i += 2) {
//       if (i + 1 < text.length) {
//         divs.add(text[i] + text[i + 1]);
//       } else {
//         divs.add(text[i] + 'X'); // Add 'X' as padding if needed
//       }
//     }
//     return divs;
//   }
//
//   List<String> generateTable(String key) {
//     // Remove duplicates and non-alphabetic characters from the key
//     String sanitizedKey = key.toUpperCase().replaceAll(RegExp(r'[^\A-Z]'), '').split('').toSet().join('');
//
//     // Fill the table with the sanitized key and remaining alphabet characters
//     List<String> table = [];
//     for (int i = 0; i < sanitizedKey.length; i++) {
//       table.add(sanitizedKey[i]);
//     }
//     for (int i = 65; i <= 90; i++) {
//       if (!table.contains(String.fromCharCode(i))) {
//         table.add(String.fromCharCode(i));
//       }
//     }
//
//     return table;
//   }
// }
class PlayfairCipher{
  late  String key;



  void generateKeyTableEncryent(String key, int ks, var keyT) {
    int i, j, k;

// a 26 character hashmap
// to store count of the alphabet
    var dicty = List<int>.filled(26, 0);
    for (i = 0; i < ks; i++) {
      if (key[i] != 'j') dicty[key.codeUnitAt(i) - 'a'.codeUnitAt(0)] = 2;
    }

    dicty['j'.codeUnitAt(0) - 'a'.codeUnitAt(0)] = 1;

    i = 0;
    j = 0;

    for (k = 0; k < ks; k++) {
      if (dicty[key.codeUnitAt(k) - 'a'.codeUnitAt(0)] == 2) {
        dicty[key.codeUnitAt(k) - 'a'.codeUnitAt(0)] -= 1;
        keyT[i][j] = key[k];
        j++;
        if (j == 5) {
          i++;
          j = 0;
        }
      }
    }

    for (k = 0; k < 26; k++) {
      if (dicty[k] == 0) {
        keyT[i][j] = String.fromCharCode(k + 'a'.codeUnitAt(0));
        j++;
        if (j == 5) {
          i++;
          j = 0;
        }
      }
    }
  }



  String prepare(String str, int ptrs) {
    if (ptrs % 2 != 0) str = '${str}z';
    return str;
  }

  String encryptByPlayfairCipher(String str, var keyT, int ps) {
    int i;
    var a = List<int>.filled(4, 0);

    for (i = 0; i < ps; i += 2) {
      search(keyT, str[i], str[i + 1], a);

      if (a[0] == a[2]) {
        str = str.substring(0, i) +
            keyT[a[0]][(a[1] + 1) % 5] +
            str.substring(i + 1);
        str = str.substring(0, i + 1) +
            keyT[a[0]][(a[3] + 1) % 5] +
            str.substring(i + 2);
      } else if (a[1] == a[3]) {
        str = str.substring(0, i) +
            keyT[(a[0] + 1) % 5][a[1]] +
            str.substring(i + 1);
        str = str.substring(0, i + 1) +
            keyT[(a[2] + 1) % 5][a[1]] +
            str.substring(i + 2);
      } else {
        str = str.substring(0, i) + keyT[a[0]][a[3]] + str.substring(i + 1);
        str = str.substring(0, i + 1) + keyT[a[2]][a[1]] + str.substring(i + 2);
      }
    }
    return str;
  }

  String encrypt(String str,String key) {
    this.key=key;
    int ps, ks;
    var keyT = List.generate(5, (i) => List.filled(5, ""), growable: false);

// Key
    ks = key.length;
    key = key.replaceAll(' ', '');
    key = key.toLowerCase();

// Plaintext
    ps = str.length;
    str = str.replaceAll(' ', '');
    str = str.toLowerCase();

    str = prepare(str, ps);

    generateKeyTableEncryent(key, ks, keyT);

    str = encryptByPlayfairCipher(str, keyT, ps);
    return str;
  }
  //s.replaceAll(new RegExp(r'[^\w\s]+'),'')
  void generateKeyTable(String key, int ks, var keyT) {
    int i, j, k;

// a 26 character hashmap
// to store count of the alphabet
    var dicty = List<int>.filled(26, 0);

    for (i = 0; i < ks; i++) {
      if (key[i] != 'j') dicty[key.codeUnitAt(i) - 'a'.codeUnitAt(0)] = 2;
    }
    dicty['j'.codeUnitAt(0) - 'a'.codeUnitAt(0)] = 1;

    i = 0;
    j = 0;
    for (k = 0; k < ks; k++) {
      if (dicty[key.codeUnitAt(k) - 'a'.codeUnitAt(0)] == 2) {
        dicty[key.codeUnitAt(k) - 'a'.codeUnitAt(0)] -= 1;
        keyT[i][j] = key[k];
        j++;
        if (j == 5) {
          i++;
          j = 0;
        }
      }
    }
    for (k = 0; k < 26; k++) {
      if (dicty[k] == 0) {
        keyT[i][j] = String.fromCharCode(k + 'a'.codeUnitAt(0));
        j++;
        if (j == 5) {
          i++;
          j = 0;
        }
      }
    }
  }

  void search(var keyT, String a, String b, var arr) {
    int i, j;

    if (a == 'j') {
      a = 'i';
    } else if (b == 'j') {b = 'i';}

    for (i = 0; i < 5; i++) {
      for (j = 0; j < 5; j++) {
        if (keyT[i][j] == a) {
          arr[0] = i;
          arr[1] = j;
        } else if (keyT[i][j] == b) {
          arr[2] = i;
          arr[3] = j;
        }
      }
    }
  }

  int mod5(int a) {
    if (a < 0) a += 5;
    return (a % 5);
  }

  String decryptByPlayfairCipher(String str, var keyT, int ps) {
    int i;
    var a = List<int>.filled(4, 0);
    for (i = 0; i < ps; i += 2) {
      search(keyT, str[i], str[i + 1], a);
      if (a[0] == a[2]) {
        str = str.substring(0, i) +
            keyT[a[0]][mod5(a[1] - 1)] +
            str.substring(i + 1);
        str = str.substring(0, i + 1) +
            keyT[a[0]][mod5(a[3] - 1)] +
            str.substring(i + 2);
      } else if (a[1] == a[3]) {
        str = str.substring(0, i) +
            keyT[mod5(a[0] - 1)][a[1]] +
            str.substring(i + 1);
        str = str.substring(0, i + 1) +
            keyT[mod5(a[2] - 1)][a[1]] +
            str.substring(i + 2);
      } else {
        str = str.substring(0, i) + keyT[a[0]][a[3]] + str.substring(i + 1);
        str = str.substring(0, i + 1) + keyT[a[2]][a[1]] + str.substring(i + 2);
      }
    }
    return str;
  }

  String decrypt(String str,String key) {
    this.key=key;
    int ps, ks;
    var keyT = List.generate(5, (i) => List.filled(5, ""), growable: false);

// Key
    ks = key.length;
    key = key.replaceAll(' ', '');
    key = key.replaceAll(RegExp(r'[^\w\s]+'), '');
    key = key.toLowerCase();

// ciphertext
    ps = str.length;
    str = str.replaceAll(' ', '');
    str = str.replaceAll(RegExp(r'[^\w\s]+'), '');
    str = str.toLowerCase();

    generateKeyTable(key, ks, keyT);

    str = decryptByPlayfairCipher(str, keyT, ps);
    return str;
  }
}

// ignore: camel_case_types
class Sha_1{
  Map<String, String>sha_1={};
  String encrypt(String message)  {

    var data = message;
    var bytes = utf8.encode(data);
    var digest = sha1.convert(bytes);
    sha_1 [digest.toString()]="$message";
    print (sha_1);
    return digest.toString();


  }
  String? decrypt(String sha1Digest){
    if(sha_1.containsKey(sha1Digest)){
      return sha_1[sha1Digest];
    }else{
      return " Sorry, I cannot decrypt it ";
    }

    return " Sorry, I cannot decrypt it ";
  }
}



class DesEncryption {
  final DES _desECB;

  // Constructor that takes a string key and ensures it's 8 bytes long
  DesEncryption(String key)
      : _desECB = DES(key: _checkKey(key), mode: DESMode.ECB);

  // Private method to check and adjust the key length
  static List<int> _checkKey(String key) {
    if (key.length > 8) {
      key = key.substring(0, 8); // If key is longer than 8, truncate it
    } else {
      while (key.length < 8) {
        key = "0$key"; // If key is shorter than 8, pad with zeros
      }
    }
    return utf8.encode(key);
  }

  // Method to encrypt a message
  String encrypt(String message) {
    var bytes = utf8.encode(message);
    List<int> encrypted = _desECB.encrypt(bytes);
    return base64.encode(encrypted);
  }

  // Method to decrypt a message
  String decrypt(String encryptedBase64) {
    var encryptedBytes = base64.decode(encryptedBase64);
    List<int> decrypted = _desECB.decrypt(encryptedBytes);
    return utf8.decode(decrypted);
  }
}



class RSA {
  int _p = 0;
  int _q = 0;
  int _n = 0;
  int _phi = 0;
  int _e = 0;
  int _d = 0;

  RSA(_p,_q) {
    _n = _p * _q;
    _phi = (_p - 1) * (_q - 1);
    _e = _findE(_phi);
    _d = _findD(_e, _phi);
  }

  String encrypt(String message) {
    var encrypted = message.codeUnits.map((unit) {
      return _modPow(unit, _e, _n);
    }).toList();
    return encrypted.join(',');
  }

  String decrypt(String encryptedMessage) {
    var encryptedUnits = encryptedMessage.split(',').map(int.parse).toList();
    var decrypted = encryptedUnits.map((unit) {
      return _modPow(unit, _d, _n);
    });
    return String.fromCharCodes(decrypted);
  }

  int _modPow(int base, int exponent, int modulus) {
    if (modulus == 1) return 0;
    var result = 1;
    base = base % modulus;
    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = (result * base) % modulus;
      }
      exponent = exponent >> 1;
      base = (base * base) % modulus;
    }
    return result;
  }

  int _findE(int phi) {
    for (int i = 2; i < phi; i++) {
      if (_gcd(i, phi) == 1) {
        return i;
      }
    }
    return 2;
  }

  int _findD(int e, int phi) {
    int d = 1;
    while ((e * d) % phi != 1 || d == e) {
      d++;
    }
    return d;
  }

  int _gcd(int a, int b) {
    if (b == 0) {
      return a;
    }
    return _gcd(b, a % b);
  }
}








