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
import {
  BreakpointSystem,
  LocalDataManager,
  Logger,
  Product,
  Commodity,
  OrderOperationStatus,
  StyleConstants,
  BreakpointConstants,
  CartItem,
  Preferences,
  CommonDataSource,
  EsProduct,
  searchService
,

} from '@ohos/common';
import { Home } from '@ohos/home';
import { NewProduct } from '@ohos/newproduct';
import { ShopCart } from '@ohos/shopcart';
import { Personal } from '@ohos/personal';
import { buttonInfo, ButtonInfoModel } from '../viewmodel/MainPageData';
import { PageConstants } from '../constants/PageConstants';
import { OrderCount } from '@ohos/commoditydetail/src/main/ets/viewmodel/TypeModel';
import { shoppingCartService } from '@ohos/common/src/main/ets/service/ShoppingCartService';
import { UserInfo } from '../viewmodel/LoginData';
import { loginService } from '../service/LoginService';

@Entry
@Component
struct MainPage {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @StorageLink('IndexPage') currentPageIndex: number = 0;
  // ->
  @Provide('userInfo') userInfo: UserInfo = new UserInfo()
  @State shoppingCartList: CartItem[] = [];
  @State recommendList:CommonDataSource<EsProduct> = new CommonDataSource([])
  @State orderCount: OrderCount = {
    payment: 0,
    ship: 0,
    receipt: 0,
    evaluation: 0,
    sale: 0
  };
  private breakpointSystem = new BreakpointSystem();
  private localDataManager: LocalDataManager = LocalDataManager.instance();

  aboutToAppear() {
    this.breakpointSystem.register();
    this.queryOrderList();
  }


  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  queryUserInfo() {
    loginService.getUserInfo().then(res=> {
      this.userInfo = res.data
    })
  }

  queryShopCart() {
    shoppingCartService.fetchCartList().then(res => {
      this.shoppingCartList = res;
    })
  }

  fetchRecommend(productId: number) {
    return searchService.fetchRecommendById(productId)
  }

  routerDetailPage<T>(productId: T) {
    router.pushUrl({
      url: PageConstants.COMMODITY_DETAIL_PAGE_URL,
      params: { data: productId }
    }).catch((err: Error) => {
      Logger.error(JSON.stringify(err));
    });
  }

  // FIXME：先不管订单数统计
  queryOrderList() {
    this.orderCount = {
      payment: 0,
      ship: 0,
      receipt: 0,
      evaluation: 0,
      sale: 0
    };
  }

  onPageShow() {
    this.queryUserInfo();
    this.queryShopCart();
    this.queryOrderList();
  }

  build() {
    Column() {
      Tabs({
        barPosition: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarPosition.Start : BarPosition.End,
        index: this.currentPageIndex
      }) {
        TabContent() {
          // 首页
          Home({
            onClickItem: <T>(data: T): void => this.routerDetailPage<T>(data)
          })
        }
        .tabBar(this.BottomNavigation(buttonInfo[PageConstants.HOME_INDEX]))

        TabContent() {
          NewProduct({
            onClickItem: (productId: number) => this.routerDetailPage(productId)
          })
        }
        .tabBar(this.BottomNavigation(buttonInfo[PageConstants.NEW_PRODUCT_INDEX]))

        TabContent() {
          ShopCart({
            products: $shoppingCartList,
            onNeedUpdate: (): void => this.queryShopCart()
          })
        }
        .tabBar(this.BottomNavigation(buttonInfo[PageConstants.SHOP_CART_INDEX]))

        TabContent() {
          Personal({
            orderCount: $orderCount,
            onClickItem: <T>(data: T): void => this.routerDetailPage<T>(data)
          })
        }
        .tabBar(this.BottomNavigation(buttonInfo[PageConstants.PERSONAL_INDEX]))
      }
      .barWidth(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
        $r('app.float.bar_width') : StyleConstants.FULL_WIDTH)
      .barHeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
        StyleConstants.SIXTY_HEIGHT : $r('app.float.vp_fifty_six'))
      .vertical(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG)
      .scrollable(false)
      .onChange((index: number) => {
        if (index !== this.currentPageIndex) {
          this.currentPageIndex = index;
          if (index === PageConstants.PERSONAL_INDEX) {
            this.queryShopCart();
          } else if (index === PageConstants.PERSONAL_INDEX) {
            this.queryOrderList();
          }
        }
      })
    }
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder BottomNavigation(button: ButtonInfoModel) {
    Column({ space: PageConstants.BUTTON_SPACE }) {
      Image(this.currentPageIndex === button.index ? button.selectImg : button.img)
        .objectFit(ImageFit.Contain)
        .width($r('app.float.main_image_size'))
        .height($r('app.float.main_image_size'))
      Text(button.title)
        .fontColor(this.currentPageIndex === button.index ? $r('app.color.focus_color') : Color.Black)
        .opacity(this.currentPageIndex === button.index ? StyleConstants.FULL_OPACITY : StyleConstants.SIXTY_OPACITY)
        .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.micro_font_size'))
    }
    .width(StyleConstants.FULL_WIDTH)
    .height(StyleConstants.FULL_HEIGHT)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}