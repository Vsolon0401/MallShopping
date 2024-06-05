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

import { StyleConstants, BreakpointConstants, BreakPointType, CommonDataSource, Category } from '@ohos/common';
import { newProductService } from '../model/NewProductService';
import { swiperImage, classifyTitle, productData, ProductDataModel, aspectRatio, PageOption } from '../viewmodel/NewProductData';
import promptAction from '@ohos.promptAction';

@Component
export struct NewProduct {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @State titleIndex: number = 0;
  // 猜你喜欢
  @State recommendList: CommonDataSource<Category> = new CommonDataSource([]);
  // 分页查询状态
  @State pageOption: PageOption = new PageOption();
  private onClickItem?: (productId: number) => void

  aboutToAppear() {
    newProductService.fetchRecommendProductList(this.pageOption).then(res => {
      this.recommendList.addData(0, res.data)
      this.pageOption.pageNum += 1
    })
  }

  // 上拉加载
  async handlePullUp() {
    const { pageNum, pageSize } = this.pageOption
    const res = await newProductService.fetchRecommendProductList({pageNum: pageNum, pageSize: pageSize})
    if (res.data instanceof Array && Array.isArray(res.data) && res.data.length) {
      const index = this.recommendList.totalCount()
      this.recommendList.addData(index, res.data)
      this.pageOption.pageNum += 1
    } else {
      promptAction.showToast({
        message: '已经到头了',
        duration: 1000
      })
    }
  }

  @Builder
  CustomSwiper() {
    Swiper() {
      ForEach(swiperImage, (item: Resource) => {
        Image(item)
          .width(StyleConstants.FULL_WIDTH)
          .aspectRatio(StyleConstants.IMAGE_ASPECT_RATIO)
          // .borderRadius($r('app.float.vp_sixteen'))
          .backgroundColor(Color.White)
      }, (item: Resource) => JSON.stringify(item))
    }
    .indicatorStyle({
      color: $r('app.color.twenty_alpha_black'),
      selectedColor: $r('app.color.sixty_alpha_black'),
      right: $r('app.float.vp_twenty_four')
    })
    .autoPlay(true)
    .itemSpace(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? 0 : StyleConstants.ITEM_SPACE)
    .width(StyleConstants.FULL_WIDTH)
    .indicator(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM)
    .displayCount(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? StyleConstants.DISPLAY_THREE :
      (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
      StyleConstants.DISPLAY_TWO : StyleConstants.DISPLAY_ONE))
    .margin({
      bottom: 5
    })
  }

  @Builder
  ProductList() {
    List({ space: StyleConstants.TWELVE_SPACE }) {
      LazyForEach(this.recommendList, (item: Category) => {
        ListItem() {
          Column() {
            Image(item.pic)
              .width(StyleConstants.FULL_WIDTH)
              .aspectRatio(new BreakPointType({
                sm: aspectRatio.sm,
                md: aspectRatio.md,
                lg: aspectRatio.lg
              }).getValue(this.currentBreakpoint))
              .objectFit(ImageFit.Fill)
            Column() {
              if (item.brandName) {
                Text(item.brandName)
                  .fontSize($r('app.float.smaller_font_size'))
                  .border({
                    width: $r('app.float.vp_one'),
                    color: $r('app.color.three_alpha_black'),
                    radius: $r('app.float.vp_fourteen')
                  })
                  .height($r('app.float.comment_text_height'))
                  .padding({
                    left: $r('app.float.vp_eight'),
                    right: $r('app.float.vp_eight')
                  })
                  .margin({
                    left: $r('app.float.vp_eight'),
                    top: $r('app.float.vp_eight')
                  })
              }
              Text(item.name)
                .fontSize($r('app.float.small_font_size'))
                .maxLines(StyleConstants.TWO_TEXT_LINE)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({
                  top: $r('app.float.vp_eight'),
                  bottom: $r('app.float.vp_eight'),
                  left: $r('app.float.vp_eight')
                })
            }
            .height(90)
            .width(StyleConstants.FULL_WIDTH)
            .backgroundColor(Color.White)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)
            .borderRadius({ bottomLeft: $r('app.float.vp_eight'), bottomRight: $r('app.float.vp_eight') })
          }
          .backgroundColor(Color.White)
          .borderRadius($r('app.float.vp_eight'))
          .onClick(() => { //FIXME:
            if (this.onClickItem !== undefined) {
              this.onClickItem(item.id)
            }
          })
        }
        .margin({
          left: $r('app.float.vp_six'),
          right: $r('app.float.vp_six')
        })
      }, (item: Category) => JSON.stringify(item))
    }
    .lanes(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
      StyleConstants.DISPLAY_TWO : StyleConstants.DISPLAY_THREE)
    .padding({ left: $r('app.float.vp_twelve'), right: $r('app.float.vp_twelve') })
  }

  build() {
    Scroll() {
      Column() {
        this.CustomSwiper()
        this.ProductList()
      }
    }
    .scrollBar(BarState.Off)
    .onScrollEdge((side: Edge) => {
      if (side === Edge.Bottom) {
        this.handlePullUp()
      }
    })
  }
}