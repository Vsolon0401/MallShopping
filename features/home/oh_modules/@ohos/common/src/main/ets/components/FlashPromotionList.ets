
import { StyleConstants } from '../constants/StyleConstants';
import { CommonDataSource } from '../utils/CommonDataSource';
import { formatLocalhost } from '../utils/Utils';
import { FlashPromotion, FlashProduct } from '../viewmodel/flashPromotionModel'
import { EmptyComponent } from './EmptyComponent';

@Component
export struct FlashPromotionList {
  @Link flashPromotion: FlashPromotion;
  private onClickItem? = (FlashProduct: FlashProduct) => {};

  @Builder
  FlashTimer() {
    Row({ space: 10 }) {
      Image($r('app.media.ic_flush'))
        .width(30)
        .objectFit(ImageFit.Contain)

      Text('当前秒杀场次:')

      TextClock()
        .format('hh:mm')
        .fontColor(Color.White)
        .backgroundColor(Color.Black)
    }
    .margin({ left: $r('app.float.vp_six'), right: $r('app.float.vp_six') })
  }

  @Builder
  FlashProductItem(info: FlashProduct) {
    Row() {
      Image(formatLocalhost(info.pic))
        .width('80vp')
        .height('80vp')
        .objectFit(ImageFit.Contain)
        .margin({
          top: $r('app.float.vp_sixteen'),
          bottom: $r('app.float.vp_eight')
        })
      Column() {
        Text(info.name)
          .fontColor(Color.Black)
          .maxLines(StyleConstants.THREE_TEXT_LINE)
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
      }
      .width(StyleConstants.FULL_WIDTH)
      .alignItems(HorizontalAlign.Start)
      .constraintSize({
        maxWidth: '100vp'
      })
    }
    .padding($r('app.float.vp_twelve'))
    .margin({ left: $r('app.float.vp_six'), right: $r('app.float.vp_six') })
    .height('120vp')
    .width(StyleConstants.HALFWAY_WIDTH)
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_eight'))
  }

  @Builder
  FlashProduct() {
    Scroll() {
      if (this.flashPromotion.productList.length > 0) {
        List() {
          LazyForEach(new CommonDataSource<FlashProduct>(this.flashPromotion.productList), (item: FlashProduct) => {
            ListItem() {
              this.FlashProductItem(item)
            }
          }, (item: FlashProduct) => JSON.stringify(item))
        }
        .width(StyleConstants.FULL_WIDTH)
        .listDirection(Axis.Horizontal)
        .margin({ top: $r('app.float.vp_four'), bottom: $r('app.float.vp_four') })
      } else {
        EmptyComponent({ outerHeight: StyleConstants.FIFTY_HEIGHT })
      }

    }
  }

  build() {
    Column() {
      this.FlashTimer()
      this.FlashProduct()
    }
    .alignItems(HorizontalAlign.Start)
  }
}