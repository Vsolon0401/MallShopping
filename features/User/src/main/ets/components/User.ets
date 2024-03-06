import { StyleConstants } from '@ohos/common'

@Preview({
  title: 'user'
})
@Component
struct User {

  @Builder
  Avatar() {
    Column() {
      Row() {
        Image('avatar')
          .width($r('app.float.icon_person_size'))
          .height($r('app.float.icon_person_size'))
          .borderRadius($r('app.float.vp_twenty_four'))

        Text('user name')
          .fontSize($r('app.float.vp_sixteen'))
          .fontColor(Color.White)
          .margin({ left: $r('app.float.vp_four')})
      }
      .width(StyleConstants.FULL_WIDTH)
      .height($r('app.float.icon_person_size'))
    }
  }

  @Builder
  SList() {
    Column() {
      List() {
        ForEach()
      }
    }
  }

  build() {

  }
}