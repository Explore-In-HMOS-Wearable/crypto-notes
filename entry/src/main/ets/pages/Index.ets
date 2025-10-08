import cryptoService from '../util/CryptoService'
import { buffer } from '@kit.ArkTS';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

@Entry
@Component
struct Index {
  @State note: string = ''
  @State encryptText: string = ''
  @State decryptText: string = ''
  @State encrypted: cryptoFramework.DataBlob | null = null
  @State decrypted: string = ''
  @State log: string = ''

  build() {
    Column({ space: 10 }) {
      // Title
      Text('🔐 Crypto Notes')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Orange)
        .margin({ bottom: 8 })
        .textAlign(TextAlign.Center)

      // Log area
      if (this.log) {
        Text(this.log)
          .fontSize(12)
          .fontColor(Color.White)
          .maxLines(6)
          .margin({ bottom: 6 })
      }

      // Note input area
      TextInput({ placeholder: 'Enter your note' })
        .width('80%')
        .height(40)
        .backgroundColor(Color.Gray)
        .fontSize(12)
        .onChange(v => {
          this.note = v
          this.log = '✏️ Note typed: ' + v
        })
        .placeholderFont({ size: 12 })

      // Buttons
      Row({ space: 6 }) {
        Button('Save').onClick(() => {
          if (!this.note) {
            this.log = '⚠️ Note cannot be empty'
            return
          }
          try {
            let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
            let symKey = cryptoService.genSymKeyByData(keyData);
            let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(this.note, 'utf-8').buffer) };
            let encrypted = cryptoService.encryptMessage(symKey, plainText);
            this.encryptText = buffer.from(encrypted.data).toString()
            this.encrypted = encrypted;
            this.decryptText = '';
            this.log = '✅ Note encrypted successfully:\n' + this.encryptText;
          } catch (e) {
            this.log = '❌ Encryption failed';
          }
        }).backgroundColor(Color.Green).fontSize(12)

        Button('Open').onClick(() => {
          if (!this.encrypted) {
            this.log = '⚠️ Please save a note first'
            return
          }
          try {
            const keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
            const symKey = cryptoService.genSymKeyByData(keyData);
            const decryptedData = cryptoService.decryptMessage(symKey, this.encrypted);
            this.decrypted = buffer.from(decryptedData.data).toString('utf-8');
            this.log = '🔓 Note decrypted successfully:\n' + this.decrypted;
          } catch (e) {
            this.decrypted = '';
            this.log = '❌ Decryption failed';
            this.log = JSON.stringify(e);
          }
        }).fontSize(12)
      }
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor('#0D1117')
  }
}