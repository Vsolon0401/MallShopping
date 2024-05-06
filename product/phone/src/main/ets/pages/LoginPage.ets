import { BreakPointType } from '@ohos/common';
import { Preferences } from '@ohos/common/src/main/ets/utils/Preferences';
import { PageConstants } from '../constants/PageConstants';
import {loginService} from '../service/LoginService';
import {UserInfo} from '../viewmodel/LoginData'
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct LoginPage {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @State userInfo: UserInfo = new UserInfo();
  @State switchLogin: boolean = false;
  @State buttonTextList: string[] = ['登录', '立即注册']
  private timeoutId: number = 0


  @Builder SignIn() {
    Column() {
      // username
      TextInput({ placeholder: '请输入会员用户名', text: this.userInfo.username })
        .buttonStyle()
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.userInfo.username = value
        })

      // password
      TextInput({ placeholder: '请输入密码', text: this.userInfo.password })
        .buttonStyle()
        .type(InputType.Password)
        .showPasswordIcon(true)
        .onChange((value: string) => {
          this.userInfo.password = value
        })
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder SignUp() {
    Column() {
      // username
      TextInput({ placeholder: '请输入会员用户名', text: this.userInfo.username })
        .buttonStyle()
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.userInfo.username = value
        })

      // password
      TextInput({ placeholder: '请输入密码', text: this.userInfo.password })
        .buttonStyle()
        .type(InputType.Password)
        .showPasswordIcon(true)
        .onChange((value: string) => {
          this.userInfo.password = value
        })

      // phone
      Row() {
        TextInput({ placeholder: '请输入会员手机号', text: this.userInfo.phone })
          .backgroundColor('#f4f6f5')
          .type(InputType.Number)
          .width(220)
          .height(40)
          .inputFilter('[0-9]')
          .onChange((value: string) => {
            this.userInfo.phone = value
          })

        Button('获取验证码')
          .width(100)
          .height(30)
          .onClick(() => this.getAuthCode())
      }
      .backgroundColor('#f4f6f5')
      .width(320)
      .borderRadius(20)
      .margin(20)
      .justifyContent(FlexAlign.End)

      // authCode
      TextInput({ placeholder: '请输入6位验证码', text: this.userInfo.authCode })
        .type(InputType.Number)
        .buttonStyle()
        .maxLength(10)
        .inputFilter('[0-9]')
        .onChange((value: string) => {
          this.userInfo.authCode = value
        })
    }
    .alignItems(HorizontalAlign.Center)
  }


  async getAuthCode() {
    if (this.userInfo.phone.length && loginService.reg_tel.test(this.userInfo.phone)) {
      this.userInfo.authCode = await loginService.getAuthCode(this.userInfo.phone)
    }
  }

  async handleRegister() {
    let { username, phone, authCode, password } = this.userInfo
    if (authCode) {
      const res = await loginService.register(username, password, phone, authCode)
      if (res) {

      }
    } else {
      promptAction.showToast({
        message: `${username}:${phone}:${authCode}:${password}`,
        duration: 1500
      })
    }
  }

  async handleLogin() {
    const { username, password } = this.userInfo
    await loginService.login(username, password)
    const isLogin = await loginService.getUserInfo()
    if (isLogin) {
      promptAction.showToast({
        message: '登录成功',
        duration: 800,
      })
      this.timeoutId = setTimeout(() => {
        router.replaceUrl({
          url: PageConstants.MAIN_PAGE_URL,
        })
      }, PageConstants.DELAY_TIME)
    }
  }

  @Styles buttonStyle() {
    .width(400)
    .height(40)
    .margin(20)
  }

  build() {
    Column() {
      Image($r('app.media.ic_eshop'))
        .width(new BreakPointType({
          sm: $r('app.float.splash_image_size'),
          md: $r('app.float.splash_image_size'),
          lg: $r('app.float.splash_image_size_lg')
        }).getValue(this.currentBreakpoint))
        .aspectRatio(PageConstants.IMAGE_ASPECT_RATIO)
        .objectFit(ImageFit.Contain)
        .borderRadius(100)

      if (this.buttonTextList[0] === '登录') {
        this.SignIn()
      } else if (this.buttonTextList[0] === '注册') {
        this.SignUp()
      }

      Row({ space: 10 }) {
        Button(this.buttonTextList[0])
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            if (this.buttonTextList[0] === '登录') {
              this.handleLogin()
            } else if (this.buttonTextList[0] === '注册') {
              this.handleRegister()
            }
          })
        Button(this.buttonTextList[1])
          .backgroundColor(0x317aff)
          .width(180)
          .onClick(() => {
            if (this.buttonTextList[0] === '登录') {
              this.buttonTextList = ['注册', '返回登录']
            } else if (this.buttonTextList[0] === '注册') {
              this.buttonTextList = ['登录', '立即注册']
            }
          })
      }

    }
    .margin({ top: 100 })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  aboutToDisappear() {
    clearTimeout(this.timeoutId);
  }
}