
import { StyleConstants } from '@ohos/common/src/main/ets/constants/StyleConstants'
import { addressService } from '@ohos/common/src/main/ets/service/AddressService'
import { Logger } from '@ohos/common/src/main/ets/utils/Logger'
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel'
import { HeaderBar } from './HeaderBar'
import Prompt from '@system.prompt'

@Component
export struct AddressSelected {
  @Consume('selectedAddress') selectedAddress: UserAddress;
  @State addressList: UserAddress[] = []
  private onSelectAddress?: () => void;

  aboutToAppear() {
    this.fetchAddressList()
  }

  fetchAddressList() {
    addressService.fetchAddressList().then(res => {
      this.addressList = res.data
    })
  }

  handleSelect(selected: UserAddress) {
    this.selectedAddress = selected
    this.onSelectAddress()
  }

  // todo:
  async handleEdit() {

  }

  async handleDelete(selected: UserAddress) {
    const res = await addressService.delAddress(selected.id)
    if (res.code === 200) {
      this.fetchAddressList()
      Prompt.showToast({ message: '删除成功' })
    }
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
          .fontSize($r('app.float.small_font_size'))
          .margin({ right: $r('app.float.vp_twelve') })
          .fontColor(Color.Gray)
      }
      .alignItems(HorizontalAlign.Start)

      Row() {
        Image($r('app.media.ic_edit'))
          .width($r('app.float.vp_eighteen'))
          .height($r('app.float.vp_eighteen'))
          .margin({ right: $r('app.float.vp_twelve') })

        Image($r('app.media.ic_delete'))
          .width($r('app.float.vp_eighteen'))
          .height($r('app.float.vp_eighteen'))
          .margin({ right: $r('app.float.vp_twelve') })
          .onClick(() => this.handleDelete($$.address))
      }
    }
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_sixteen'))
    .width(StyleConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: $r('app.float.vp_twelve') })
    .padding($r('app.float.vp_sixteen'))
    .onClick(() => this.handleSelect($$.address))
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
          .backgroundColor($r('app.color.page_background'))
        }
      }
      .width(StyleConstants.FULL_WIDTH)
    }
    .width(StyleConstants.FULL_WIDTH)
  }
}