import { BreakPointType, StyleConstants } from '@ohos/common';
import { Preferences } from '@ohos/common/src/main/ets/utils/Preferences';
import { PageConstants } from '../constants/PageConstants';
import {loginService} from '../service/LoginService';
import {UserInfo} from '../viewmodel/LoginData'
import promptAction from '@ohos.promptAction';
import NotificationManager from '@ohos.notificationManager';
import router from '@ohos.router';

@Entry
@Component
struct LoginPage {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @State userInfo: UserInfo = new UserInfo();
  @State switchLogin: boolean = false;
  @State buttonTextList: string[] = ['登录', '注册']
  private timeoutId: number = 0

  async getAuthCode() {
    if (this.userInfo.phone.length && loginService.reg_tel.test(this.userInfo.phone)) {
      const authCode = await loginService.getAuthCode(this.userInfo.phone)
      const notificationRequest = {
        id: 1,
        content: {
          contentType: NotificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 普通文本类型通知
          normal: {
            title: '【用户注册验证码】',
            text: authCode,
            additionalText: '若非本人操作，请忽略此信息',
          }
        }
      }
      NotificationManager.publish(notificationRequest, (err) => {
        if (err) {
          console.error(`[ANS] failed to publish, error[${err}]`);
          return;
        }
        console.info(`[ANS] publish success`);
      });
    }
  }

  async handleRegister() {
    let { username, phone, authCode, password } = this.userInfo
    if (authCode) {
      const res = await loginService.register(username, password, phone, authCode)
      if (res) {
        promptAction.showToast({
          message: '注册成功，请返回登录',
          duration: 1500
        })
      }
    } else {
      promptAction.showToast({
        message: '请输入验证码',
        duration: 1500
      })
    }
  }

  async handleLogin() {
    const { username, password } = this.userInfo
    const loginStatus = await loginService.login(username, password)
    if (loginStatus) {
      const loginInfo = await loginService.getUserInfo()
      if (loginInfo.code === 200) {
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
  }


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
          .width(200)
          .height(40)
          .inputFilter('[0-9]')
          .textAlign(TextAlign.Start)
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
      .justifyContent(FlexAlign.SpaceBetween)

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


  @Styles buttonStyle() {
    .width(320)
    .height(40)
    .margin(20)
  }

  build() {
    Column() {
      Image($r('app.media.ic_backgroud_login'))
        .width(new BreakPointType({
          sm: 300,
          md: 300,
          lg: 400
        }).getValue(this.currentBreakpoint))
        .aspectRatio(PageConstants.IMAGE_ASPECT_RATIO)
        .objectFit(ImageFit.Contain)

      Row() {
        Text(`欢迎来到商城，请${this.buttonTextList[0]}`)
          .fontSize($r('app.float.bigger_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
      }
      .justifyContent(FlexAlign.Start)

      if (this.buttonTextList[0] === '登录') {
        this.SignIn()
      } else if (this.buttonTextList[0] === '注册') {
        this.SignUp()
      }

      Row({ space: 10 }) {
        Button(this.buttonTextList[0])
          .backgroundColor(0x317aff)
          .width(180)
          .onClick(() => {
            if (this.buttonTextList[0] === '登录') {
              this.handleLogin()
            } else if (this.buttonTextList[0] === '注册') {
              this.handleRegister()
            }
          })
        Button(this.buttonTextList[1])
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            if (this.buttonTextList[0] === '登录') {
              this.buttonTextList = ['注册', '返回']
            } else if (this.buttonTextList[0] === '注册') {
              this.buttonTextList = ['登录', '注册']
            }
          })
      }

    }
    .margin({ top: 50 })
    .padding({ left: 20, right: 20 })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  aboutToDisappear() {
    clearTimeout(this.timeoutId);
  }
}