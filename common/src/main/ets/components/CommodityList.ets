import { StyleConstants } from '../constants/StyleConstants';
import { CommonDataSource } from '../utils/CommonDataSource';
import { Commodity } from '../viewmodel/CommodityModel';

@Component
export struct CommodityList {
  @Link commodityList: Commodity[];
  @Prop column: number;
  private onClickItem = (Commodity: Commodity) => {};


  @Builder
  CommodityItem(info: Commodity) {
    Column() {
      Image($rawfile(info.images[0]))
        .width($r('app.float.commodity_item_image_size'))
        .height($r('app.float.commodity_item_image_size'))
        .objectFit(ImageFit.Contain)
        .margin({
          top: $r('app.float.vp_sixteen'),
          bottom: $r('app.float.vp_eight')
        })
      Column() {
        Text($r('app.string.commodity_piece_description', info.title, info.description))
          .fontColor(Color.Black)
          .maxLines(StyleConstants.TWO_TEXT_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize($r('app.float.small_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
          .lineHeight($r('app.float.commodity_desc_height'))
        Text($r('app.string.commodity_piece', info.price))
          .fontColor($r('app.color.focus_color'))
          .fontSize($r('app.float.middle_font_size'))
          .margin({
            top: $r('app.float.vp_four'),
            bottom: $r('app.float.vp_eight')
          })
        Text(`${info.promotion}`)
          .fontSize($r('app.float.micro_font_size'))
          .fontColor(Color.White)
          .backgroundColor($r('app.color.focus_color'))
          .borderRadius($r('app.float.vp_four'))
          .height($r('app.float.vp_sixteen'))
          .padding({
            right: $r('app.float.vp_eight'),
            left: $r('app.float.vp_eight')
          })
      }
      .width(StyleConstants.FULL_WIDTH)
      .alignItems(HorizontalAlign.Start)
    }
    .padding($r('app.float.vp_twelve'))
    .height($r('app.float.commodity_item_height'))
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_eight'))
  }

  build() {
    if (this.commodityList.length > 0) {
      List({ space: StyleConstants.TWELVE_SPACE }) {
        LazyForEach(new CommonDataSource<Commodity>(this.commodityList), (item: Commodity) => {
          ListItem() {
            this.CommodityItem(item)
          }
          .onClick(() => {
            if (this.onClickItem !== undefined) {
              this.onClickItem(item);
            }
          })
        }, (item: Commodity) => JSON.stringify(item))
      }
      .margin({ left: $r('app.float.commodity_list_margin'), right: $r('app.float.commodity_list_margin') })
      .listDirection(Axis.Vertical)
      .lanes(this.column ?? 0)
    }
  }
}