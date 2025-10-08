import { cryptoFramework } from '@kit.CryptoArchitectureKit';

export default class CryptoService {
  static iv = CryptoService.genIvParamsSpec();
  static generateRandom(len: number) {
    let rand = cryptoFramework.createRandom();
    let generateRandSync = rand.generateRandomSync(len);
    return generateRandSync;
  }

  static genIvParamsSpec() {
    let ivBlob = CryptoService.generateRandom(16);
    let ivParamsSpec: cryptoFramework.IvParamsSpec = {
      algName: 'IvParamsSpec',
      iv: ivBlob
    };
    return ivParamsSpec;
  }

  // Encrypt the message.
  static encryptMessage(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
    let cipher = cryptoFramework.createCipher('AES128|CBC|PKCS7');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, CryptoService.iv);
    let cipherData = cipher.doFinalSync(plainText);
    return cipherData;
  }

  // Decrypt the message.
  static decryptMessage(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
    let decoder = cryptoFramework.createCipher('AES128|CBC|PKCS7');
    decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, CryptoService.iv);
    let decryptData = decoder.doFinalSync(cipherText);
    return decryptData;
  }

  static genSymKeyByData(symKeyData: Uint8Array) {
    let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
    let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    let symKey = aesGenerator.convertKeySync(symKeyBlob);
    console.info('convertKeySync success');
    return symKey;
  }
}
