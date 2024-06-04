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

import { searchSwiper, classifyTitle, swiperImage, activityTitle, ActivityTitleModel, Advertise, HotProduct, PageOption} from '../viewmodel/HomeData';
import { LocalDataManager, CommodityList, Commodity, StyleConstants, BreakpointConstants, CategoryList, Category, RecommendScroll,Logger, CommonDataSource, Brand, FlashPromotion, BrandList, FlashPromotionList, Classify, formatLocalhost, ProductWaterFlow } from '@ohos/common';
import { homeService } from '../model/homeService';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Preview
@Component
export struct Home {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @State titleIndex: number = 0;
  @State activityTitleIndex: number = 0;
  @State flushSaleList: any[] = [];
  // 一级分类信息
  @State classifyLevel1: Classify[] = [new Classify('首页')];
  // 二级分类
  @State classifyLevel2: Classify[] = [];
  // 轮播广告图
  @State advertiseList: Advertise[] = [];
  // 人气推荐
  @State hotProductList: Category[] = [];
  // 新品推荐
  @State newProductList: Category[] = [];
  // 品牌
  @State brandList: Brand[] = [];
  // 秒杀专区
  @State flashPromotion: FlashPromotion = new FlashPromotion()
  // waterFall的scroll控制器
  private scroller: Scroller = new Scroller();
  private onClickItem = (CategoryId: number) => {};

  aboutToAppear() {
    homeService.fetchClassify(this.titleIndex).then((res) => {
      this.classifyLevel1 = this.classifyLevel1.concat(res.data)
    })
    homeService.fetchContent().then((res) => {
      this.advertiseList = res.data?.advertiseList || []
      this.hotProductList = res.data?.hotProductList || []
      this.newProductList = res.data?.newProductList || []
      this.brandList = res.data?.brandList || []
      this.flashPromotion = res.data?.homeFlashPromotion
    })
  }


  // 加载二级分类
  async handleCateClick(parentId: number) {
    if (parentId !== 0) {
      const res = await homeService.fetchClassify(parentId)
      if (res.data instanceof Array && Array.isArray(res.data) && res.data.length) {
        this.classifyLevel2 = res.data
      }
    }
    this.titleIndex = parentId;
  }

  // 点击搜索栏进入搜索页
  routerToSearch() {
    router.pushUrl({
      url: 'pages/SearchCommodityPage'
    }).catch((err: Error) => {
      Logger.error(JSON.stringify(err));
    });
  }

  // 点击品牌带参数进入搜索页
  routerWithParamsToSearch(searchKey: string) {
    router.pushUrl({
      url: 'pages/SearchCommodityPage',
      params: { searchKey: searchKey }
    }).catch((err: Error) => {
      Logger.error(JSON.stringify(err));
    });
  }

  // 搜索栏
  @Builder
  SearchTitle() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Image($r("app.media.ic_eshop_old"))
          .height(StyleConstants.FULL_HEIGHT)
          .aspectRatio(1)
        Image($r('app.media.ic_scan'))
          .height(StyleConstants.FULL_HEIGHT)
          .aspectRatio(1)
      }
      .height($r('app.float.vp_twenty_four'))
      .width(StyleConstants.FULL_WIDTH)
      .margin({ bottom: $r('app.float.vp_eight') })

      Row() {
        Image($r('app.media.ic_search'))
          .width($r('app.float.vp_twenty'))
          .height($r('app.float.vp_twenty'))
          .margin({
            left: $r('app.float.vp_twelve'),
            right: $r('app.float.vp_eight')
          })
        Swiper() {
          ForEach(searchSwiper, (item: Resource) => {
            Column() {
              Text(item)
                .fontSize($r('app.float.small_font_size'))
                .fontColor(Color.Black)
            }
            .alignItems(HorizontalAlign.Start)
          }, (item: Resource) => JSON.stringify(item))
        }
        .autoPlay(true)
        .loop(true)
        .vertical(true)
        .indicator(false)
      }
      .height($r('app.float.search_swiper_height'))
      .width(StyleConstants.FULL_WIDTH)
      .borderRadius($r('app.float.vp_twenty'))
      .backgroundColor(Color.White)
      .onClick(() => this.routerToSearch())
    }
    .width(StyleConstants.FULL_WIDTH)
    .padding({ top: $r('app.float.vp_twelve'), bottom: $r('app.float.vp_twelve') })
  }
  // 分类
  @Builder
  ClassifyTitle() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Scroll() {
        List() {
          ForEach(this.classifyLevel1, (item: Classify, index?: number) => {
            ListItem() {
              Text(item.name)
                .fontSize($r('app.float.middle_font_size'))
                .opacity(this.titleIndex === index ? StyleConstants.FULL_OPACITY : StyleConstants.EIGHTY_OPACITY)
                .fontWeight(this.titleIndex === index ? StyleConstants.FONT_WEIGHT_SEVEN : StyleConstants.FONT_WEIGHT_FOUR)
                .fontColor(Color.White)
                .maxLines(StyleConstants.ONE_TEXT_LINE)
                .margin({ right: $r('app.float.vp_four') })
                .onClick(() => {
                  if (index !== undefined) {
                    this.handleCateClick(index)
                  }
                })
            }
          }, (item: Classify) => JSON.stringify(item))
        }
        .width(StyleConstants.FULL_WIDTH)
        .listDirection(Axis.Horizontal)
      }
      .flexBasis('auto')
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      Row() {
        Image($r('app.media.ic_split_line'))
          .width($r('app.float.vp_one'))
          .height($r('app.float.vp_fourteen'))
        Image($r('app.media.ic_more'))
          .width($r('app.float.vp_sixteen'))
          .height($r('app.float.vp_sixteen'))
          .margin({
            left: $r('app.float.vp_two'),
            right: $r('app.float.vp_two')
          })
        Text($r('app.string.title_bar_classification'))
          .fontSize($r('app.float.middle_font_size'))
          .fontColor(Color.White)
          .opacity(this.titleIndex === undefined ? StyleConstants.FULL_OPACITY : StyleConstants.EIGHTY_OPACITY)
          .fontWeight(this.titleIndex === undefined ?
          StyleConstants.FONT_WEIGHT_SEVEN : StyleConstants.FONT_WEIGHT_FOUR)
      }
      .margin({ right: $r('app.float.vp_six')})
      .onClick(() => {
        this.titleIndex = 0;
      })
    }
    .margin({ top: $r('app.float.vp_twelve')})
    .width(StyleConstants.FULL_WIDTH)
  }

  // 二级分类信息
  @Builder
  ClassifyZone() {
    Scroll() {
      List() {
        ForEach(this.classifyLevel2, (item: Classify) => {
          ListItem() {
            Column() {
              Image(formatLocalhost(item.icon))
                .width('66vp')
                .objectFit(ImageFit.Contain)
                .margin(10)

              Text(item.name)
                .fontColor(Color.Black)
                .maxLines(StyleConstants.ONE_TEXT_LINE)
                .fontSize($r('app.float.middle_font_size'))
                .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
                .lineHeight($r('app.float.commodity_desc_height'))
            }
          }
          .onClick(() => {
            this.routerWithParamsToSearch(item.name)
          })
        }, (item: Classify) => JSON.stringify(item))
      }
      .width(StyleConstants.FULL_WIDTH)
      .margin({ top: $r('app.float.vp_twelve'), bottom: $r('app.float.vp_twelve') })
      .listDirection(Axis.Vertical)
      .lanes(StyleConstants.FOUR_TEXT_LINE)

    }
    .height('205vp')
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_sixteen'))
    .scrollable(ScrollDirection.Horizontal)
    .margin({ top: $r('app.float.vp_twelve'), bottom: $r('app.float.vp_twelve') })
    .width(StyleConstants.FULL_WIDTH)
    .scrollBar(BarState.Off)
  }

  // 广告轮播图
  @Builder
  CustomSwiper() {
    Swiper() {
      if (this.advertiseList.length === 0) {
        ForEach(swiperImage, (item: Resource) => {
          Image(item)
            .width(StyleConstants.FULL_WIDTH)
            .aspectRatio(StyleConstants.IMAGE_ASPECT_RATIO)
            .borderRadius($r('app.float.vp_sixteen'))
            .backgroundColor(Color.White)
        }, (item: Resource) => JSON.stringify(item))
      } else {
        ForEach(this.advertiseList, (item: Advertise) => {
          Image(item.pic)
            .width(StyleConstants.FULL_WIDTH)
            .aspectRatio(StyleConstants.IMAGE_ASPECT_RATIO)
            .borderRadius($r('app.float.vp_sixteen'))
            .backgroundColor(Color.White)
        }, (item: Advertise) => JSON.stringify(item.url))
      }
    }
    .indicatorStyle({ selectedColor: $r('app.color.indicator_select') })
    .autoPlay(true)
    .itemSpace(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? 0 : StyleConstants.ITEM_SPACE)
    .width(StyleConstants.FULL_WIDTH)
    .indicator(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM)
    .displayCount(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? StyleConstants.DISPLAY_THREE :
      (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ? StyleConstants.DISPLAY_TWO :
      StyleConstants.DISPLAY_ONE))
    .margin({ top: $r('app.float.vp_twelve'), bottom: $r('app.float.vp_twelve') })
  }

  // 专题区
  @Builder
  ActivityTitle() {
    Flex({ justifyContent: FlexAlign.SpaceAround }) {
      ForEach(activityTitle, (item: ActivityTitleModel, index?: number) => {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center
        }) {
          Text(item.title)
            .fontSize($r('app.float.small_font_size'))
            .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
            .fontColor(Color.Black)
          Text(item.desc)
            .fontSize($r('app.float.smaller_font_size'))
            .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
            .fontColor(this.activityTitleIndex === index ? $r('app.color.focus_color') : Color.Black)
            .opacity(this.activityTitleIndex === index ? StyleConstants.FULL_OPACITY : StyleConstants.SIXTY_OPACITY)
        }
        .onClick(() => {
          if (index !== undefined) {
            this.activityTitleIndex = index;
          }
        })
        .height(StyleConstants.FULL_HEIGHT)
      }, (item: ActivityTitleModel) => JSON.stringify(item))
    }
    .height($r('app.float.activity_title_height'))
    .width(StyleConstants.FULL_WIDTH)
    .padding($r('app.float.vp_twelve'))
    .margin({ bottom: $r('app.float.vp_six'), top: $r('app.float.vp_six') })
    .backgroundColor($r('app.color.page_background'))
    .borderRadius($r('app.float.vp_sixteen'))
  }

  // 人气推荐
  @Builder
  PopularZone() {
    Column() {
      CategoryList({
        categoryList: $hotProductList,
        onClickItem: (data: Category): void => this.onClickItem(data.id)
      })
    }
    .width(StyleConstants.FULL_WIDTH)
    .margin({ top: $r('app.float.vp_twelve'), bottom: $r('app.float.vp_twelve') })
  }


  // 品牌专区
  @Builder
  BrandZone() {
    Column() {
      BrandList({
        brandList: $brandList,
        onClickItem: (brandName: string) => this.routerWithParamsToSearch(brandName)
      })
    }
    .width(StyleConstants.FULL_WIDTH)
    .margin({ top: $r('app.float.vp_twelve'), bottom: $r('app.float.vp_twelve') })
  }

  // 推荐
  @Builder
  NewProductZone() {
    Column() {
      CategoryList({
        categoryList: $newProductList,
        onClickItem: (data: Category): void => this.onClickItem(data.id)
      })
    }
    .width(StyleConstants.FULL_WIDTH)
    .margin({ top: $r('app.float.vp_twelve'), bottom: $r('app.float.vp_twelve') })
  }

  // 秒杀专区
  @Builder
  FlushSaleZone() {
    Column() {
      FlashPromotionList({
        flashPromotion: $flashPromotion,
        onClickItem: (data: Category): void => this.onClickItem(data.id)
      })
    }
  }

  // 猜你喜欢(推荐
  // @Builder
  // RecommendList() {
  //   Column() {
  //     Row({ space: 5 }) {
  //       Image($r('app.media.ic_love'))
  //         .objectFit(ImageFit.Contain)
  //         .width(25)
  //
  //       Text('猜你喜欢')
  //         .fontColor(Color.Black)
  //         .fontSize($r('app.float.middle_font_size'))
  //         .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
  //         .lineHeight($r('app.float.commodity_desc_height'))
  //     }
  //     .padding(10)
  //     .margin({ top: $r('app.float.vp_six'), bottom: $r('app.float.vp_six')})
  //     .width(StyleConstants.FULL_WIDTH)
  //     .alignItems(VerticalAlign.Center)
  //   }
  //
  //   RecommendScroll({
  //     recommendList: $recommendList,
  //     onClickItem: (data: Category): void => this.onClickItem(data.id)
  //   })
  // }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.ic_app_background'))
        .width(StyleConstants.FULL_WIDTH)
        .height($r('app.float.image_background_height'))
        .objectFit(ImageFit.Auto)
      Flex({ direction: FlexDirection.Column }) {
        this.SearchTitle()
        Scroll(this.scroller) {
          Column() {
            this.ClassifyTitle()
            if (this.titleIndex === 0) {
              this.CustomSwiper()
            } else {
              this.ClassifyZone()
            }
            this.ActivityTitle()
            if (this.activityTitleIndex === 0) {
              this.PopularZone()
            } else if (this.activityTitleIndex === 1) {
              this.BrandZone()
            } else if (this.activityTitleIndex === 2) {
              this.NewProductZone()
            } else if (this.activityTitleIndex === 3) {
              this.FlushSaleZone()
            }

          }
        }
        .scrollBar(BarState.Off)
      }
      .padding({ left: $r('app.float.vp_twelve'), right: $r('app.float.vp_twelve') })
    }
  }
}
