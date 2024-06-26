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

import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { AddressInfo } from './AddressInfo';
import { HeaderBar } from '../components/HeaderBar';
import { OrderDetailConstants } from '../constants/OrderDetailConstants';
import { CommodityOrderList } from './CommodityOrderList';
import { LocalDataManager, Order, OrderOperationStatus, GridConstants, StyleConstants, orderService } from '@ohos/common';
import { ConfirmOrderType, InsertOrderProps } from '@ohos/common/src/main/ets/viewmodel/OrderModel';
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel';

@Component
export struct ConfirmOrder {
  @Link cartIdList: number[];
  @Consume('selectedAddress') selectedAddress: UserAddress;
  @Consume('confirmOrder') confirmOrderInfo: ConfirmOrderType;
  private onSelectAddress?: () => void;

  /**
   * Confirm order to request server.
   */
  async confirmOrder(status: number) {
    const res = await orderService.generateOrder({
      cartIds: this.cartIdList,
      // couponId: 0,
      memberReceiveAddressId: this.selectedAddress.id,
      payType: 0,
      // useIntegration: 0
    })
    if (res.code === 200) {
      promptAction.showToast({ message: $r('app.string.order_commit_success') });
      router.replaceUrl({
        url: OrderDetailConstants.PAY_ORDER_PAGE_URL,
        params: { orderData: res.data }
      });
    }
  }

  submitConfirmOrder() {
    try {
      this.confirmOrder(OrderOperationStatus.UN_PAY);
    } catch (err) {
      promptAction.showToast({ message: $r('app.string.order_commit_fail', err) });
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      HeaderBar({
        title: $r('app.string.header_bar_title'),
        onBack: () => router.back()
      })
      Column() {
        Scroll() {
          GridRow({
            columns: {
              sm: GridConstants.COLUMN_FOUR,
              md: GridConstants.COLUMN_EIGHT,
              lg: GridConstants.COLUMN_TWELVE
            }
          }) {
            GridCol({
              span: {
                sm: GridConstants.SPAN_FOUR,
                md: GridConstants.SPAN_EIGHT,
                lg: GridConstants.SPAN_EIGHT
              },
              offset: { lg: GridConstants.OFFSET_TWO }
            }) {
              Column() {
                AddressInfo({
                  onSelectAddress: this.onSelectAddress
                })
                CommodityOrderList()
              }
            }
          }
        }
        .scrollBar(BarState.Off)
      }
      .flexGrow(StyleConstants.FLEX_GROW)
      .padding({ left: $r('app.float.vp_twelve'), right: $r('app.float.vp_twelve') })

      GridRow({
        columns: {
          sm: GridConstants.COLUMN_FOUR,
          md: GridConstants.COLUMN_EIGHT,
          lg: GridConstants.COLUMN_TWELVE
        },
        gutter: GridConstants.GUTTER_TWELVE
      }) {
        GridCol({
          span: {
            sm: GridConstants.SPAN_TWO,
            md: GridConstants.SPAN_TWO,
            lg: GridConstants.SPAN_TWO
          },
          offset: { lg: GridConstants.OFFSET_TWO }
        }) {
          Text($r('app.string.bottom_bar_amount', this.confirmOrderInfo.calcAmount?.totalAmount || 111))
            .fontSize($r('app.float.huge_font_size'))
            .margin({ right: $r('app.float.vp_twelve') })
            .fontColor($r('app.color.focus_color'))
            .textAlign(TextAlign.Start)
            .width(StyleConstants.FULL_WIDTH)
            .height($r('app.float.vp_fifty_six'))
        }

        GridCol({
          span: {
            sm: GridConstants.SPAN_TWO,
            md: GridConstants.SPAN_THREE,
            lg: GridConstants.SPAN_THREE
          },
          offset: {
            md: GridConstants.OFFSET_THREE,
            lg: GridConstants.OFFSET_THREE
          }
        }) {
          Button($r('app.string.bottom_bar_button'))
            .backgroundColor($r('app.color.focus_color'))
            .height($r('app.float.confirm_button_height'))
            .width(StyleConstants.FULL_WIDTH)
            .margin({ top: $r('app.float.vp_eight') })
            .onClick(() => this.submitConfirmOrder())
        }
      }
      .padding({
        left: $r('app.float.vp_twelve'),
        right: $r('app.float.vp_twelve')
      })
      .border({
        color: $r("app.color.five_alpha_black"),
        width: { top: $r('app.float.vp_one') }
      })
    }
    .backgroundColor($r('app.color.page_background'))
    .height(StyleConstants.FULL_HEIGHT)
    .width(StyleConstants.FULL_WIDTH)
  }
}