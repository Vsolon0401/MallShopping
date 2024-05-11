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

import router from '@ohos.router';
import { PayOrder } from '@ohos/orderdetail';
import { LocalDataManager, Logger, Order, OrderItem, orderService } from '@ohos/common';
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel';
import { ConfirmOrderType, OrderDetail, OrderInfo } from '@ohos/common/src/main/ets/viewmodel/OrderModel';

@Entry
@Component
struct PayOrderPage {

  @Provide('orderInfo') orderInfo: OrderInfo = new OrderInfo()
  @Provide('selectedAddress') selectedAddress: UserAddress = new UserAddress();
  @Provide('confirmOrder') confirmOrderInfo: ConfirmOrderType = new ConfirmOrderType();

  onPageShow() {
    const params = router.getParams() as Record<string, Object>;
    const orderInfo = params.orderData as any
    orderService.fetchOrderDetail(orderInfo.order.id).then(res => {
      const orderInfo = res.data as OrderInfo
      // 初始化地址
      this.selectedAddress = {
        name: orderInfo.receiverName,
        phoneNumber: orderInfo.receiverPhone,
        province: orderInfo.receiverProvince,
        city: orderInfo.receiverCity,
        detailAddress: orderInfo.receiverDetailAddress,
        region: orderInfo.receiverRegion,
        postCode: orderInfo.receiverPostCode
      }
      // 初始化CartItem
      this.confirmOrderInfo = {
        cartPromotionItemList: orderInfo.orderItemList.map((orderItem: OrderItem) => {
          return {
            productAttr: orderItem.productAttr,
            productPic: orderItem.productPic,
            productName: orderItem.productName,
            price: orderItem.productPrice,
            quantity: orderItem.productQuantity
          }
        }),
        memberReceiveAddressList: [],
        couponHistoryDetailList: [],
        calcAmount: {
          totalAmount: 0,
          freightAmount: orderInfo.freightAmount,
          promotionAmount: 0,
          payAmount: orderInfo.payAmount,
        }
      }
      this.orderInfo = orderInfo
    })
  }

  build() {
    Column() {
      PayOrder()
    }
  }
}