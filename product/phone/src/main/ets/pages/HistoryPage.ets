
import { historyService } from '@ohos/common/src/main/ets/service/HistoryService'
import { Logger } from '@ohos/common/src/main/ets/utils/Logger'
import { PageOption } from '@ohos/home/src/main/ets/viewmodel/HomeData'
import { HeaderBar } from '@ohos/orderdetail/src/main/ets/components/HeaderBar'
import router from '@ohos.router'
import { EmptyComponent, formatLocalhost, MemberHistory, StyleConstants } from '@ohos/common'
import { PageConstants } from '../constants/PageConstants'

@Entry
@Component
struct HistoryPage {
  @State historyList: MemberHistory[] = []
  @State pageOption: PageOption = new PageOption()

  aboutToAppear() {
    historyService.fetchHistory(this.pageOption).then(res => {
      this.historyList = res.data?.list || []
    })
  }

  routerDetailPage<T>(productId: T) {
    router.pushUrl({
      url: PageConstants.COMMODITY_DETAIL_PAGE_URL,
      params: { data: productId }
    }).catch((err: Error) => {
      Logger.error(JSON.stringify(err));
    });
  }

  handleMemberHistoryCancel(productId: number) {

  }

  @Builder
  MemberHistoryItem(info: MemberHistory) {
    Row() {
      Image(formatLocalhost(info.productPic))
        .width($r('app.float.commodity_item_image_size'))
        .height($r('app.float.commodity_item_image_size'))
        .objectFit(ImageFit.Contain)
        .margin({
          // top: $r('app.float.vp_sixteen'),
          right: $r('app.float.vp_eight')
        })
      Column() {
        Text(info.productName)
          .fontColor(Color.Black)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(StyleConstants.ONE_TEXT_LINE)
          .fontSize($r('app.float.middle_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
          .lineHeight($r('app.float.commodity_desc_height'))
          .layoutWeight(1)
        Text(info.productSubTitle)
          .fontColor(Color.Grey)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(StyleConstants.TWO_TEXT_LINE)
          .fontSize($r('app.float.smaller_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
          .lineHeight($r('app.float.commodity_desc_height'))
          .layoutWeight(1)
      }
      .width(StyleConstants.FULL_WIDTH)
      .alignItems(HorizontalAlign.Start)
      .constraintSize({
        maxWidth: '200vp'
      })
    }
    .padding($r('app.float.vp_twelve'))
    .height($r('app.float.category_item_height'))
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_eight'))
  }

  @Builder
  CancelMemberHistory(item: MemberHistory) {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.End
    }) {
      Column() {
        Image($r('app.media.ic_cancel'))
          .width($r('app.float.vp_twenty_four'))
          .height($r('app.float.vp_twenty_four'))
          .margin({ bottom: $r('app.float.vp_ten') })
        Text('取消')
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.White)
      }
      .padding({ right: $r('app.float.vp_fourteen') })
    }
    .onClick(() => this.handleMemberHistoryCancel(item.productId))
    .height(155)
    .width($r('app.float.item_delete_width'))
    .backgroundColor($r('app.color.focus_color'))
    .borderRadius($r('app.float.vp_sixteen'))
    .margin({ left: $r('app.float.item_delete_margin_left') })
  }

  @Builder
  MemberHistoryList() {
    List() {
      ForEach(this.historyList, (item: MemberHistory) => {
        ListItem() {
          this.MemberHistoryItem(item)
        }
        .margin({
          bottom: 10
        })
        .onClick(() => this.routerDetailPage(item.productId))
        .swipeAction({ end: this.CancelMemberHistory(item), edgeEffect: SwipeEdgeEffect.None})
      }, (item: MemberHistory) => JSON.stringify(item))
    }
    .width(StyleConstants.FULL_WIDTH)
    .margin({ left: $r('app.float.commodity_list_margin'), right: $r('app.float.commodity_list_margin') })
    .backgroundColor($r('app.color.page_background'))
    .listDirection(Axis.Vertical)
  }

  build() {
    Column() {
      HeaderBar({ title: '收藏记录', onBack: () => router.back() })
      if (this.historyList?.length > 0) {
        this.MemberHistoryList()
      } else {
        EmptyComponent({ emptyText: '暂无数据' })
      }
    }
    .backgroundColor($r('app.color.page_background'))
    .width(StyleConstants.FULL_WIDTH)
  }
}