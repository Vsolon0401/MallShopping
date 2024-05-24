
import { Preferences, StyleConstants, UserInfo } from '@ohos/common'
import router from '@ohos.router'
import { PageConstants } from '../constants/PageConstants'
import { HeaderBar } from '@ohos/orderdetail/src/main/ets/components/HeaderBar'
import { loginService } from '../service/LoginService'

// todo: 动态设置个人资料
@Entry
@Component
struct Setting {

  @State userInfo: UserInfo = new UserInfo()

  onPageShow() {
    loginService.getUserInfo().then(res => {
      this.userInfo = res.data
    })
  }

  async handleLogout() {
    await Preferences.delete('token')
    router.replaceUrl({
      url: PageConstants.LOGIN_PAGE_URL
    })
  }

  @Styles
  lineStyle() {
    .height(50)
    .width(StyleConstants.FULL_WIDTH)
  }

  @Styles
  arrowStyle() {
    .width($r('app.float.vp_sixteen'))
    .height($r('app.float.vp_sixteen'))
  }

  @Styles
  dividerStyle() {
    .width(StyleConstants.FULL_WIDTH)
    .height($r('app.float.vp_one'))
    .backgroundColor($r("app.color.five_alpha_black"))
    .margin({
      top: $r('app.float.vp_four'),
      bottom: $r('app.float.vp_four')
    })
  }

  @Builder
  Avatar() {
    Row() {
      Text('头像')
        .fontSize($r('app.float.vp_sixteen'))

      Row() {
        Image(this.userInfo?.icon || $r('app.media.ic_person'))
          .width($r('app.float.icon_person_size'))
          .height($r('app.float.icon_person_size'))
          .borderRadius($r('app.float.vp_twenty_four'))
          .margin({
            right: $r('app.float.vp_eight')
          })

        Image($r('app.media.ic_right_arrow'))
          .arrowStyle()
      }
    }
    .lineStyle()
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  UserName() {
    Row() {
      Text('昵称')
        .fontSize($r('app.float.vp_sixteen'))

      Row() {
        Text(this.userInfo?.nickname || '未知昵称')
          .fontSize($r('app.float.vp_sixteen'))

        Image($r('app.media.ic_right_arrow'))
          .arrowStyle()
      }
    }
    .lineStyle()
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  Gender() {
    Row() {
      Text('性别')
        .fontSize($r('app.float.vp_sixteen'))

      Row() {
        Text(this.userInfo?.gender === 1 ? '男' : '女')
          .fontSize($r('app.float.vp_sixteen'))

        Image($r('app.media.ic_right_arrow'))
          .arrowStyle()
      }
    }
    .lineStyle()
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  Region() {
    Row() {
      Text('地区')
        .fontSize($r('app.float.vp_sixteen'))

      Row() {
        Text(this.userInfo?.city || '地球')
          .fontSize($r('app.float.vp_sixteen'))

        Image($r('app.media.ic_right_arrow'))
          .arrowStyle()
      }
    }
    .lineStyle()
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  Birthday() {
    Row() {
      Text('生日')
        .fontSize($r('app.float.vp_sixteen'))

      Row() {
        Text(this.userInfo?.birthday?.substring(0, 9) || '未设置生日')
          .fontSize($r('app.float.vp_sixteen'))

        Image($r('app.media.ic_right_arrow'))
          .arrowStyle()
      }
    }
    .lineStyle()
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  Logout() {
    Row() {
      Button('退出登录')
        .width(StyleConstants.EIGHTY_WIDTH)
        .height('40vp')
        .backgroundColor($r('app.color.theme_color'))
        .onClick(() => this.handleLogout())
    }
    .offset({
      y: 80
    })
  }

  build() {
    Column() {
      HeaderBar({ title: '设置', onBack: () => router.back() })

      Column() {
        this.Avatar()
        Divider()
          .dividerStyle()
        this.UserName()
        Divider()
          .dividerStyle()
        this.Gender()
        Divider()
          .dividerStyle()
        this.Region()
        Divider()
          .dividerStyle()
        this.Birthday()
      }
      .width(StyleConstants.FULL_WIDTH)
      .height(600)
      .margin({
        top: 10
      })
      .padding({
        left: 10,
        right: 5
      })
      this.Logout()
    }
    .width(StyleConstants.FULL_WIDTH)
  }
}