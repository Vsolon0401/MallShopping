import { StyleConstants } from '../constants/StyleConstants';
import { CommonDataSource } from '../utils/CommonDataSource';
import { BaseResponse } from '../utils/Request';
import { Category } from '../viewmodel/CategoryModel';
import { EmptyComponent } from './EmptyComponent';
import promptAction from '@ohos.promptAction';
import { Logger } from '../utils/Logger';
import { formatLocalhost } from '../utils/Utils';


// FIXME: 改成了search那的接口，需要调整数据结构
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

  @Builder
  itemFoot() {
    Column() {
      Text('到底了')
        .fontColor(Color.Gray)
        .fontSize($r('app.float.middle_font_size'))
        .width(StyleConstants.FULL_WIDTH)
        .height($r('app.float.capsule_height'))
        .textAlign(TextAlign.Center)
    }
  }

  build() {
    if (this.recommendList.totalCount() > 0) {
      WaterFlow({ footer: () => this.itemFoot() }) {
      LazyForEach(this.recommendList, (item: Category) => {
        FlowItem() {
          this.CategoryItem(item)
        }
      }, (item: Category) => JSON.stringify(item))
      }
      .layoutWeight(StyleConstants.WATER_FLOW_LAYOUT_WEIGHT)
      .layoutDirection(FlexDirection.Column)
      .columnsTemplate(StyleConstants.WATER_FLOW_COLUMNS_TEMPLATE)
      .columnsGap($r('app.float.water_flow_columns_gap'))
      .rowsGap($r('app.float.water_flow_row_gap'))
    } else {
      EmptyComponent({ outerHeight: StyleConstants.FIFTY_HEIGHT, emptyText: '暂无秒杀活动' })
    }
  }
}