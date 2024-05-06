import { StyleConstants } from '../constants/StyleConstants';
import { CommonDataSource } from '../utils/CommonDataSource';
import { BaseResponse } from '../utils/Request';
import { Category } from '../viewmodel/CategoryModel';
import { EmptyComponent } from './EmptyComponent';
import promptAction from '@ohos.promptAction';
import { Logger } from '../utils/Logger';
import { formatLocalhost } from '../utils/Utils';

@Component
export struct RecommendScroll {


  @Link recommendList: CommonDataSource<Category>;
  // private onPullUp: (params: any) => Promise<BaseResponse<Category[]>>;
  private onClickItem? = (Category: Category) => {};
  // private scroller: Scroller = new Scroller();


  @Builder
  CategoryItem(info: Category) {
    Column() {
      Image(formatLocalhost(info.pic))
        .width($r('app.float.commodity_item_image_size'))
        .height($r('app.float.commodity_item_image_size'))
        .objectFit(ImageFit.Contain)
        .margin({
          top: $r('app.float.vp_sixteen'),
          bottom: $r('app.float.vp_eight')
        })
      Column() {
        Text(info.name)
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
      }
      .width(StyleConstants.FULL_WIDTH)
      .alignItems(HorizontalAlign.Start)
    }
    .margin($r('app.float.vp_eight'))
    .padding($r('app.float.vp_twelve'))
    .height($r('app.float.commodity_item_height'))
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_eight'))
  }

  build() {
    if (this.recommendList.totalCount() > 0) {
      List({ space: StyleConstants.TWELVE_SPACE }) {
        LazyForEach(this.recommendList, (item: Category) => {
          ListItem() {
            this.CategoryItem(item)
          }
          // .margin({ left: $r('app.float.vp_six'), right: $r('app.float.vp_six') })
          .onClick(() => {
            if (this.onClickItem !== undefined) {
              this.onClickItem(item);
            }
          })
        }, (item: Category) => JSON.stringify(item))
      }
      .lanes(StyleConstants.TWO_TEXT_LINE)
      .width(StyleConstants.FULL_WIDTH)
      .margin({ left: $r('app.float.commodity_list_margin'), right: $r('app.float.commodity_list_margin') })
      .listDirection(Axis.Vertical)
    } else {
      EmptyComponent({ outerHeight: StyleConstants.FIFTY_HEIGHT, emptyText: '暂无秒杀活动' })
    }
  }
}