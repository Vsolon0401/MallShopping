
import { StyleConstants } from '@ohos/common/src/main/ets/constants/StyleConstants'
import { addressService } from '@ohos/common/src/main/ets/service/AddressService'
import { Logger } from '@ohos/common/src/main/ets/utils/Logger'
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel'
import { HeaderBar } from './HeaderBar'

@Component
export struct AddressSelected {
  @State addressList: UserAddress[] = []
  private onSelectAddress?: () => void;

  aboutToAppear() {
    addressService.fetchAddressList().then(res => {
      Logger.debug(JSON.stringify(res))
    })
  }

  handleSelect() {

  }

  @Builder
  AddressItem($$:{ address: UserAddress }) {
    Row() {
      Column() {
        Text($$.address.name + ' ' + $$.address.phoneNumber)
          .fontSize($r('app.float.middle_font_size'))
          .margin({ right: $r('app.float.vp_twelve') })
          .fontColor(Color.Black)

        Text($$.address.province + ' ' + $$.address.detailAddress)
          .fontSize($r('app.float.middle_font_size'))
          .margin({ right: $r('app.float.vp_twelve') })
          .fontColor(Color.Black)
      }

      Row() {
        Image($r('app.media.ic_edit'))
          .width($r('app.float.vp_eighteen'))
          .height($r('app.float.vp_eighteen'))
          .margin({ right: $r('app.float.vp_twelve') })

        Image($r('app.media.ic_delete'))
          .width($r('app.float.vp_eighteen'))
          .height($r('app.float.vp_eighteen'))
          .margin({ right: $r('app.float.vp_twelve') })
      }
    }
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_sixteen'))
    .width(StyleConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: $r('app.float.vp_twelve') })
    .padding($r('app.float.vp_sixteen'))
  }


  build() {
    Flex({ direction: FlexDirection.Column }) {
      HeaderBar({
        title: '收货地址',
        onBack: this.onSelectAddress
      })
      Column() {
        Scroll() {
          List(){
            ForEach(this.addressList, (item: UserAddress) => {
              ListItem() {
                this.AddressItem({
                  address: item
                })
              }
            }, (item: UserAddress) => JSON.stringify(item))
          }
          .width(StyleConstants.FULL_WIDTH)
        }
      }
      .width(StyleConstants.FULL_WIDTH)
    }
    .width(StyleConstants.FULL_WIDTH)
  }
}