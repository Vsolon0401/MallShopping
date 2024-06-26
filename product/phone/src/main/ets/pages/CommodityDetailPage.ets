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
import { productService, CommodityInfo } from '@ohos/common';
import { CommodityDetail } from '@ohos/commoditydetail';


@Entry
@Component
struct CommodityDetailPage {
  @State commodityId: string = '';
  @State info?: CommodityInfo = undefined;
  // 商品图片
  @State productImgList: string[] = [];

  aboutToAppear() {
    let params = router.getParams() as Record<string, Object>;
    this.commodityId = params.data as string;
    productService.fetchProductDetail(params.data as number).then((res) => {
      const detailInfo = res.data
      this.info = detailInfo
      // 商品图片
      if (detailInfo.product.albumPics?.length > 1) {
        detailInfo.product.albumPics.split(',').forEach(item => {
          if (item !== null && item != '') {
            this.productImgList.push(item)
          }
        })
      } else {
        this.productImgList.push(detailInfo.pic)
      }
    })
  }

  build() {
    Row() {
      CommodityDetail({
        commodityId: this.commodityId,
        info: $info,
        productImgList: $productImgList
      })
    }
    .backgroundColor($r('app.color.page_background'))
  }
}