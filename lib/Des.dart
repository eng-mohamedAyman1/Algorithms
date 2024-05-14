import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'dart:math';
// DesEncryption(controllerKey1.toString())
// توليد زوج المفاتيح العامة والخاصة
AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPair(SecureRandom random) {
  var keyGen = RSAKeyGenerator()
    ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64), random));
  return keyGen.generateKeyPair();
}

// تشفير البيانات باستخدام المفتاح العام
Uint8List rsaEncrypt(PublicKey publicKey, Uint8List dataToEncrypt) {
  var encryptor = OAEPEncoding(RSAEngine())
    ..init(true, PublicKeyParameter<PublicKey>(publicKey)); // true=encrypt
  return _processInBlocks(encryptor, dataToEncrypt);
}

// فك تشفير البيانات باستخدام المفتاح الخاص
Uint8List rsaDecrypt(PrivateKey privateKey, Uint8List encryptedData) {
  var decryptor = OAEPEncoding(RSAEngine())
    ..init(false, PrivateKeyParameter<PrivateKey>(privateKey)); // false=decrypt
  return _processInBlocks(decryptor, encryptedData);
}

// معالجة البيانات بالكتل
Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List data) {
  final blockSize = engine.inputBlockSize;
  final outputBlockSize = engine.outputBlockSize;

  int offset = 0;
  final List<int> result = [];

  while (offset < data.length) {
    final chunkSize = (offset + blockSize <= data.length)
        ? blockSize
        : data.length - offset;
    result.addAll(engine.process(data.sublist(offset, offset + chunkSize)));
    offset += chunkSize;
  }

  return Uint8List.fromList(result);
}

void main() {
  // تهيئة SecureRandom
  final rnd = SecureRandom("Fortuna");
  final seedSource = Random.secure();
  final seeds = <int>[];
  for (int i = 0; i < 32; i++) {
    seeds.add(seedSource.nextInt(255));
  }
  rnd.seed(KeyParameter(Uint8List.fromList(seeds)));

  // توليد الأزواج الرئيسية
  final pair = generateKeyPair(rnd);
  final publicKey = pair.publicKey;
  final privateKey = pair.privateKey;

  // الرسالة للتشفير
  String message = 'رسالة سرية';
  Uint8List dataToEncrypt = Uint8List.fromList(utf8.encode(message));

  // تشفير الرسالة
  final encrypted = rsaEncrypt(publicKey, dataToEncrypt);
  // فك تشفير الرسالة
  final decrypted = rsaDecrypt(privateKey, encrypted);

  // طباعة النتائج
  print('Message: $message');
  print('Encrypted: ${base64.encode(encrypted)}');
  print('Decrypted: ${utf8.decode(decrypted)}');
}
