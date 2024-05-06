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
import { LocalDataManager, Commodity, productService, CommodityInfo, Logger } from '@ohos/common';
import { CommodityDetail } from '@ohos/commoditydetail';

@Entry
@Component
struct CommodityDetailPage {
  @State commodityId: string = '';
  @State info?: Commodity = undefined;
  private localDataManager: LocalDataManager = LocalDataManager.instance();

  @State commodityInfo?: CommodityInfo = undefined;

  aboutToAppear() {
    let params = router.getParams() as Record<string, Object>;
    this.commodityId = params.data as string;
    this.info = this.localDataManager.queryCommodityListById(this.commodityId);
    productService.fetchProductDetail(params.data as number).then((res) => {
      this.commodityInfo = res.data
    })
  }

  build() {
    Row() {
      CommodityDetail({
        commodityId: this.commodityId,
        info: $commodityInfo
      })
    }
    .backgroundColor($r('app.color.page_background'))
  }
}