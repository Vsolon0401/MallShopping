
import { addressService, Logger, StyleConstants } from '@ohos/common';
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel';
import { HeaderBar } from '@ohos/orderdetail/src/main/ets/components/HeaderBar';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { AddressEditDialog } from '@ohos/orderdetail/src/main/ets/components/AddressEditDialog';

@Entry
@Component
struct AddressPage {
  @State addressList: UserAddress[] = []
  @State toEditAddress: UserAddress = new UserAddress();

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

  fetchAddressList() {
    addressService.fetchAddressList().then(res => {
      this.addressList = res.data
    })
  }

  handleEdit(address: UserAddress) {
    this.toEditAddress = address;
    this.dialogController.open()
  }

  handleAdd() {
    this.dialogController.open()
  }

  async handleSetDefaultAddress(userAddress: UserAddress, isOn: boolean) {
    userAddress.defaultStatus = isOn ? 1 : 0
    const res = await addressService.updateAddress(userAddress)
    if (res.code === 200) {
      this.fetchAddressList()
    }
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
        Toggle({ type: ToggleType.Switch, isOn: $$.address.defaultStatus === 1 })
          .width($r("app.float.vp_twenty_four"))
          .height($r("app.float.vp_twenty_four"))
          .margin({ right: $r("app.float.vp_six") })
          .selectedColor($r("app.color.theme_color"))
          .onChange((isOn) => this.handleSetDefaultAddress($$.address, isOn))

        Text('默认地址')
          .fontSize($r('app.float.middle_font_size'))
          .margin({ right: $r('app.float.vp_twelve') })
          .fontColor(Color.Black)

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
  }


  build() {
    Flex({ direction: FlexDirection.Column }) {
      HeaderBar({
        title: '收货地址',
        onBack: () => router.back()
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
      Row() {
        Button('新增地址')
          .width(StyleConstants.EIGHTY_WIDTH)
          .height('40vp')
          .backgroundColor($r('app.color.theme_color'))
          .onClick(() => this.handleAdd())
      }
      .alignSelf(ItemAlign.Center)
      .offset({
        y: 550
      })
    }
    .width(StyleConstants.FULL_WIDTH)
    .height(StyleConstants.FULL_HEIGHT)
    .backgroundColor($r('app.color.page_background'))
  }
}