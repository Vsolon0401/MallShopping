
import { StyleConstants } from '@ohos/common/src/main/ets/constants/StyleConstants'
@Entry
@Component
struct LoginPage {

  @Builder
  PasswordLogin() {
    Column() {
      Text('账号登录')
        .fontSize($r('app.float.bigger_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({
          top: '40vp'
        })

      TextInput({ placeholder: $r('app.string.phone_login_placeholder') })
        .type(InputType.PhoneNumber)
        .placeholderColor($r('app.color.input_placeholder_color'))
        .enterKeyType(EnterKeyType.Next)
        .caretColor($r('app.color.theme_color'))
        .backgroundColor($r('app.color.input_background'))
        .margin({
          top: $r('app.float.vp_six'),
          bottom: $r('app.float.vp_six')
        })


      TextInput({ placeholder: $r('app.string.password_login_placeholder') })
        .type(InputType.Password)
        .placeholderColor($r('app.color.input_placeholder_color'))
        .caretColor($r('app.color.theme_color'))
        .backgroundColor($r('app.color.input_background'))
        .margin({
          top: $r('app.float.vp_six'),
          bottom: $r('app.float.vp_six')
        })

      Button('登录',  { type: ButtonType.Capsule })
        .backgroundColor($r('app.color.theme_color'))
        .width('80%')

    }
    .width(StyleConstants.FULL_WIDTH)
    .height(StyleConstants.FULL_HEIGHT)
  }

  @Builder
  SmsLogin() {
    Column() {
      Text('短信登录/注册')
        .fontSize($r('app.float.bigger_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({
          top: '40vp'
        })

      TextInput({ placeholder: '请输入手机号' })
        .type(InputType.PhoneNumber)
        .placeholderColor($r('app.color.input_placeholder_color'))
        .enterKeyType(EnterKeyType.Next)
        .caretColor($r('app.color.theme_color'))
        .backgroundColor($r('app.color.input_background'))
        .margin({
          top: $r('app.float.vp_six'),
          bottom: $r('app.float.vp_six')
        })

      Row() {
        TextInput({ placeholder: '请输入验证码' })
          .type(InputType.Password)
          .placeholderColor($r('app.color.input_placeholder_color'))
          .caretColor($r('app.color.theme_color'))
          .backgroundColor($r('app.color.input_background'))
          .margin({
            top: $r('app.float.vp_six'),
            bottom: $r('app.float.vp_six')
          })
      }

      Button('登录/注册',  { type: ButtonType.Capsule })
        .backgroundColor($r('app.color.theme_color'))
        .width('80%')
    }
    .width(StyleConstants.FULL_WIDTH)
    .height(StyleConstants.FULL_HEIGHT)
  }

  build() {
    Column() {

      this.PasswordLogin()
    }
    .width(StyleConstants.FULL_WIDTH)
    .height(StyleConstants.FULL_HEIGHT)
  }
}