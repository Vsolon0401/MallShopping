import { StyleConstants } from '../constants/StyleConstants';
import { CommonDataSource } from '../utils/CommonDataSource';
import { formatLocalhost } from '../utils/Utils';
import { Brand } from '../viewmodel/CategoryModel'
import { EmptyComponent } from './EmptyComponent';

@Component
export struct BrandList {
  @Link brandList: Brand[];
  private onClickItem? : (brandName: string) => void;


  @Builder
  BrandCard(brandItem: Brand) {
    Column() {
      Image(formatLocalhost(brandItem.logo))
        .width('66vp')
        .height('40vp')
        .objectFit(ImageFit.Contain)
        .margin(10)

      Text(brandItem.name)
        .fontColor(Color.Black)
        .maxLines(StyleConstants.ONE_TEXT_LINE)
        .fontSize($r('app.float.middle_font_size'))
        .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
        .lineHeight($r('app.float.commodity_desc_height'))
    }
    .height('80vp')
    .backgroundColor(Color.White)
    .onClick(() => {
      if (this.onClickItem !== undefined) {
        this.onClickItem(brandItem.name)
      }
    })
  }

  build() {
    if (this.brandList.length > 0) {
      List({ space: StyleConstants.TWELVE_SPACE }) {
        LazyForEach(new CommonDataSource<Brand>(this.brandList), (item: Brand) => {
          ListItem() {
            this.BrandCard(item)
          }
          .margin({ left: $r('app.float.vp_two'), right: $r('app.float.vp_two')})
        }, (item: Brand) => JSON.stringify(item))
      }
      .width(StyleConstants.FULL_WIDTH)
      .margin({ left: $r('app.float.commodity_list_margin'), right: $r('app.float.commodity_list_margin') })
      .listDirection(Axis.Vertical)
      .lanes(StyleConstants.FOUR_TEXT_LINE)
    } else {
      EmptyComponent({ outerHeight: StyleConstants.FIFTY_HEIGHT})
    }
  }
}