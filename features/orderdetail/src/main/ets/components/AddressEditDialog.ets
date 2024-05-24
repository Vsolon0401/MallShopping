
import { addressService, GridConstants, Logger, StyleConstants } from '@ohos/common'
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel'
import promptAction from '@ohos.promptAction';

@CustomDialog
export struct AddressEditDialog {
  @State loading: boolean = true;
  @Link addressInfo: UserAddress;

  private refresh?: () => void;
  private dialogType?: string;
  controller?: CustomDialogController;

  aboutToAppear(){
    if (this.addressInfo !== undefined) {
      this.loading = false
    }
  }

  async handleSaveEdit() {
    const res = await addressService.updateAddress(this.addressInfo)
    if (res.code === 200) {
      promptAction.showToast({ message: '修改成功' })
      this.refresh()
    }
  }

  async handleSaveAdd() {
    const res = await addressService.addAddress(this.addressInfo)
    if (res.code === 200) {
      promptAction.showToast({ message: '添加成功' })
      this.refresh()
    }
  }

  @Styles
  DividerStyle() {
    .width(StyleConstants.FULL_WIDTH)
    .height($r('app.float.vp_one'))
    .backgroundColor($r("app.color.five_alpha_black"))
    .margin({
      top: $r('app.float.vp_twelve'),
      bottom: $r('app.float.vp_twelve')
    })
  }

  @Builder
  SaveButton() {
    Row() {
      Button({ type: ButtonType.Capsule, stateEffect: true }) {
        Row() {
          Text('保存')
            .fontColor(Color.White)
            .fontSize($r('app.float.middle_font_size'))
            .height($r('app.float.capsule_height'))
            .textAlign(TextAlign.Center)
            .width(StyleConstants.FULL_WIDTH)
        }
        .width(StyleConstants.FULL_WIDTH)
      }
      .width(StyleConstants.FULL_WIDTH)
      .backgroundColor($r("app.color.theme_color"))
      .onClick(() => {
        if (this.dialogType === 'add') {
          this.handleSaveAdd()
        } else {
          this.handleSaveEdit()
        }
          this.controller?.close()
        })
    }
    .width(StyleConstants.FULL_WIDTH)
  }

  @Builder
  FormInput(label: string, placeholder: string,  key: string ) {
    Row() {
      Text(label)
        .fontSize($r('app.float.middle_font_size'))
        .fontColor(Color.Black)

      TextInput({ placeholder: placeholder, text: this.addressInfo[`${key}`] })
        .backgroundColor($r('app.color.page_background'))
        .layoutWeight(1)
        .onChange((value) => {
          this.addressInfo[`${key}`] = value
        })
    }
    .width(StyleConstants.FULL_WIDTH)
  }

  build() {
    GridRow({ columns: { sm: GridConstants.COLUMN_FOUR, md: GridConstants.COLUMN_EIGHT,
      lg: GridConstants.COLUMN_TWELVE }, gutter: GridConstants.GUTTER_TWELVE }) {
      GridCol({ span: { sm: GridConstants.SPAN_FOUR, md: GridConstants.SPAN_EIGHT, lg: GridConstants.SPAN_EIGHT },
        offset: { lg: GridConstants.OFFSET_TWO } }) {
        Column() {
          Row() {
            Text(this.dialogType === 'add' ? '新增收货地址' :'修改收货地址')
              .fontSize($r('app.float.big_font_size'))
              .fontColor(Color.Black)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          if (this.loading) {
            LoadingProgress()
              .height($r("app.float.vp_twenty_four"))
              .width($r("app.float.vp_twenty_four"))
              .color($r("app.color.theme_color"))
          } else {
            Divider()
              .DividerStyle()

            // 收货人
            this.FormInput('收货人', '收货人姓名', 'name')

            Divider()
              .DividerStyle()

            // 手机号
            this.FormInput('手机号','收货人手机号', 'phoneNumber')

            Divider()
              .DividerStyle()

            this.FormInput('地区', '收货人地区', 'province')

            Divider()
              .DividerStyle()

            // 详细地址
            this.FormInput('详细地址',  '如街道、门牌号、小区等', 'detailAddress')

            Divider()
              .DividerStyle()

            // 保存按钮
            this.SaveButton()
          }
        }
        .padding($r('app.float.vp_sixteen'))
        .borderRadius($r('app.float.dialog_radius'))
        .backgroundColor($r('app.color.page_background'))
        .width(StyleConstants.FULL_WIDTH)
      }
    }
    .margin({
      left: $r("app.float.vp_sixteen"),
      right: $r("app.float.vp_sixteen")
    })
  }
}