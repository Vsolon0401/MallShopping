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
import { OrderDetailList } from '@ohos/orderdetail';
import { LocalDataManager, Order, Commodity, orderService, OrderInfo, Logger } from '@ohos/common';

@Entry
@Component
struct OrderDetailListPage {
  @State orderInfo: OrderInfo[] = []
  @Provide currentTabIndex: number = 0;

  aboutToAppear() {
    let params = router.getParams() as Record<string, Object>;
    this.currentTabIndex = params.tabIndex as number;
    this.fetchOrderList(params.tabIndex)
  }

  async fetchOrderList(currentTabIndex) {
    try {
      const status = currentTabIndex-1
      orderService.fetchOrderList(status).then(res => {
        const orderInfoList: OrderInfo[] = res.data.list
        this.orderInfo = orderInfoList?.length > 0
          ? orderInfoList
          : []
      })
    } catch (e) {
      Logger.error(JSON.stringify(e))
    }
  }

  build() {
    Column() {
      OrderDetailList({
        orderInfo: $orderInfo,
        onTabChange: this.fetchOrderList
      })
    }
  }
}