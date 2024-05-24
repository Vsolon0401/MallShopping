
import { StyleConstants } from '@ohos/common/src/main/ets/constants/StyleConstants'
import { addressService } from '@ohos/common/src/main/ets/service/AddressService'
import { Logger } from '@ohos/common/src/main/ets/utils/Logger'
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel'
import { HeaderBar } from './HeaderBar'
import Prompt from '@system.prompt'
import { AddressEditDialog } from './AddressEditDialog'
import promptAction from '@ohos.promptAction'

@Component
export struct AddressSelect {
  @Consume('selectedAddress') selectedAddress: UserAddress;
  @State addressList: UserAddress[] = []
  @State toEditAddress: UserAddress = new UserAddress();
  private onSelectAddress?: () => void;

  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddressEditDialog({
      addressInfo: $toEditAddress,
      refresh: () => this.fetchAddressList()
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  aboutToAppear() {
    this.fetchAddressList()
  }

  aboutToDisappear() {
    this.dialogController = null;
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

  handleEdit(address: UserAddress) {
    this.toEditAddress = address
    this.dialogController.open()
  }

  async handleDelete(selected: UserAddress) {
    try {
      promptAction.showDialog({
        title: '删除地址确认！',
        message: '此操作不可撤销哦',
        buttons: [
          {
            text: '取消',
            color: "#ff000000"
          },
          {
            text: '删除',
            color: '#f74c42'
          }
        ]
      }, async (err, data) => {
        if (data.index === 0) {
          return;
        } else {
          const res = await addressService.delAddress(selected.id)
          if (res.code === 200) {
            this.fetchAddressList()
            promptAction.showToast({ message: '删除成功' })
          }
        }
      })
    } catch (e) {
      Logger.error(JSON.stringify(e))
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
          .onClick(() => this.handleEdit($$.address))

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
      .backgroundColor($r('app.color.page_background'))
    }
    .width(StyleConstants.FULL_WIDTH)
  }
}