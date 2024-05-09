/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommodityOrderItem } from './CommodityOrderItem';
import { CartPromotionItem, Order } from '@ohos/common';
import { ConfirmOrderType } from '@ohos/common/src/main/ets/viewmodel/OrderModel';



@Component
export struct CommodityOrderList {
  @Consume('confirmOrder') confirmOrderInfo: ConfirmOrderType;

  build() {
    Column() {
      Text('商品信息')
        .fontSize($r('app.float.small_font_size'))
      Divider()
        .height($r('app.float.vp_one'))
        .backgroundColor($r("app.color.five_alpha_black"))
      ForEach(this.confirmOrderInfo.cartPromotionItemList, (item: CartPromotionItem) => {
        CommodityOrderItem({
          orderData: item
        });
      }, (item: Order, index?: number) => JSON.stringify(item) + index);
      // todo: 优惠卷、积分、及其费用
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text($r('app.string.order_list_reward'))
          .fontSize($r('app.float.small_font_size'))
        Text($r('app.string.order_list_standard_reward'))
          .fontSize($r('app.float.small_font_size'))
      }
      .padding({
        top: $r('app.float.vp_twelve'),
        bottom: $r('app.float.vp_twelve')
      })
      .height($r('app.float.order_item_height'))

      Divider()
        .height($r('app.float.vp_one'))
        .backgroundColor($r("app.color.five_alpha_black"))

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text('运费')
          .fontSize($r('app.float.small_font_size'))
        Text($r('app.string.commodity_piece', this.confirmOrderInfo.calcAmount?.freightAmount))
          .fontSize($r('app.float.small_font_size'))
      }
      .padding({
        top: $r('app.float.vp_twelve'),
        bottom: $r('app.float.vp_twelve')
      })
      .height($r('app.float.order_item_height'))

      Divider()
        .height($r('app.float.vp_one'))
        .backgroundColor($r("app.color.five_alpha_black"))

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text($r('app.string.order_list_invoices'))
          .fontSize($r('app.float.small_font_size'))
        Row() {
          Text($r('app.string.order_list_personal_invoices'))
            .fontSize($r('app.float.small_font_size'))
          Image($r('app.media.ic_point'))
            .height($r('app.float.vp_twelve'))
            .width($r('app.float.vp_six'))
            .margin({ left: $r('app.float.vp_twelve') })
        }
      }
      .padding({
        top: $r('app.float.vp_twelve'),
        bottom: $r('app.float.vp_twelve')
      })
      .height($r('app.float.order_item_height'))
    }
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_sixteen'))
    .margin({ bottom: $r('app.float.vp_twelve') })
    .padding($r('app.float.vp_sixteen'))
  }
}