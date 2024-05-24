import { StyleConstants } from '../constants/StyleConstants';
import { CommonDataSource } from '../utils/CommonDataSource';
import { BaseResponse } from '../utils/Request';
import { Category } from '../viewmodel/CategoryModel';
import { EmptyComponent } from './EmptyComponent';
import promptAction from '@ohos.promptAction';
import { Logger } from '../utils/Logger';
import { formatLocalhost } from '../utils/Utils';


@Component
export struct ProductWaterFlow {
  @Link recommendList: CommonDataSource<Category>;
  private onPullUp?: () => Promise<void>;
  private onClickItem? = (Category: Category) => {};


  @Builder
  CategoryItem(info: Category) {
    Column() {
      Image(formatLocalhost(info.pic))
        .width($r('app.float.commodity_item_image_size'))
        .height($r('app.float.commodity_item_image_size'))
        .objectFit(ImageFit.Contain)
        .margin({
          top: $r('app.float.vp_twelve'),
          bottom: $r('app.float.vp_eight')
        })
      Text(info.name)
        .fontColor(Color.Black)
        .maxLines(StyleConstants.TWO_TEXT_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize($r('app.float.small_font_size'))
        .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
        .lineHeight($r('app.float.commodity_desc_height'))
        .alignSelf(ItemAlign.Start)
      Text($r('app.string.commodity_piece', info.price))
        .fontColor($r('app.color.focus_color'))
        .fontSize($r('app.float.middle_font_size'))
        .alignSelf(ItemAlign.Start)
        .lineHeight($r('app.float.vp_twenty'))
        .margin({
          top: $r('app.float.vp_four'),
          bottom: $r('app.float.vp_eight')
        })
      // Row() {
      //   if (this.item?.promotion) {
      //     Text(`${this.item?.promotion}`)
      //       .height($r('app.float.promotion_text_height'))
      //       .fontSize($r('app.float.promotion_font_size'))
      //       .fontColor(Color.White)
      //       .borderRadius($r('app.float.promotion_radius'))
      //       .backgroundColor($r('app.color.focus_color'))
      //       .padding({
      //         left: $r('app.float.promotion_padding_left'),
      //         right: $r('app.float.promotion_padding_right')
      //       })
      //       .margin({
      //         top: $r('app.float.promotion_margin_top'),
      //         right: $r('app.float.promotion_margin_right')
      //       })
      //   }
      //   if (this.item?.bonus_points) {
      //     Text(`${this.item?.bonus_points}`)
      //       .height($r('app.float.promotion_text_height'))
      //       .fontSize($r('app.float.promotion_font_size'))
      //       .fontColor($r('app.color.focus_color'))
      //       .borderRadius($r('app.float.promotion_radius'))
      //       .borderWidth($r('app.float.bonus_points_radius_width'))
      //       .borderColor($r('app.color.focus_color'))
      //       .padding({
      //         left: $r('app.float.bonus_points_padding_left'),
      //         right: $r('app.float.bonus_points_padding_right')
      //       })
      //       .margin({ top: $r('app.float.bonus_points_margin_top') })
      //   }
      // }
      // .width(Const.FULL_WIDTH)
      // .justifyContent(FlexAlign.Start)
    }
    .padding({
      left: $r('app.float.vp_twelve'),
      right: $r('app.float.vp_twelve'),
      bottom: $r('app.float.vp_twelve')
    })
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_eight'))
    .onClick(() => {
      if (this.onClickItem !== undefined) {
        this.onClickItem(info)
      }
    })
  }

  @Builder
  itemFoot() {
    Column() {
      Text('到底了')
        .fontColor(Color.Gray)
        .fontSize($r('app.float.middle_font_size'))
        .width(StyleConstants.FULL_WIDTH)
        .height($r('app.float.vp_twenty'))
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
      .onReachEnd(() => {
        if (this.onPullUp !== undefined) {
          this.onPullUp()
        }
      })
    } else {
      EmptyComponent({ outerHeight: StyleConstants.FIFTY_HEIGHT, emptyText: '暂无秒杀活动' })
    }
  }
}