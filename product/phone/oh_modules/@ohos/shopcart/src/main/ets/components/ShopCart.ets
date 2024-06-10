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
import { ShopCartConstants } from '../constants/ShopCartConstants';
import {Logger,CounterProduct,EmptyComponent,StyleConstants,BreakpointConstants,CartItem,shoppingCartService, searchService, ProductWaterFlow, EsProduct, CommonDataSource, formatLocalhost} from '@ohos/common';
import { SelectProducts, UpdateShopProps } from '@ohos/common/src/main/ets/viewmodel/ProductModel';
import promptAction from '@ohos.promptAction';

@Component
export struct ShopCart {
  private onNeedUpdate?: () => void;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @Link @Watch('onListChange') products: Array<CartItem>;
  @State sumPrice: number = 0;
  @State isSelectAll: boolean = false;
  @State selectProducts: SelectProducts[] = [];

  aboutToAppear() {
    this.onListChange();
  }

  needUpdateShopCart() {
    if (this.onNeedUpdate !== undefined) {
      this.onNeedUpdate();
    }
  }

  private countSumPrice() {
    this.sumPrice = 0;
    this.isSelectAll = this.selectProducts.every((item: SelectProducts) => item.selected);
    let tempPrice: number = 0;
    this.selectProducts.forEach((item: SelectProducts) => {
      if (item.selected) {
        let data = this.products.find((value: CartItem) => (value.productName + value.productAttr) === item.key);
        const ins = (data !== undefined ? data.price * data.quantity : 0);
        tempPrice += ins;
      }
    })
    this.sumPrice = tempPrice;
  }

  settleAccounts() {
    const orderList = this.products
      .filter((item: CartItem, index: number) =>
        (item.productName + item.productAttr) === this.selectProducts[index].key
        && this.selectProducts[index].selected === true)
      .map((item: CartItem) => {
        return item.id
      });
    router.pushUrl({
      url: ShopCartConstants.CONFIRM_ORDER_PAGE_URL,
      params: { cartIdList: orderList }
    }).catch((err: Error) => {
      Logger.error(JSON.stringify(err));
    });
  }

  onListChange() {
    if (this.selectProducts.length === 0) {
      this.products.forEach((item: CartItem) => {
        let payload: SelectProducts = { selected: false, key: '' };
        payload.selected = !!item.selected;
        payload.key = item.productName + item.productAttr;
        this.selectProducts.push(payload);
      })
    } else if (this.selectProducts.length !== this.products.length) {
      this.products.forEach((item: CartItem) => {
        const key = item.productName + item.productAttr;
        const check = this.selectProducts.findIndex(select => select.key === key)
        if (check === -1) {
          this.selectProducts.push({ key, selected: !!item.selected })
        }
      })
    }
    this.countSumPrice();
  }

  selectProductChange(index: number): boolean {
    if (this.selectProducts[index] !== undefined) {
      return this.selectProducts[index].selected;
    }
    return false;
  }

  // 更新购物车
  updateShopCart(cartItem: CartItem) {
    shoppingCartService.updateCartItem(cartItem)
  }

  // 删除商品
  handleDelProduct(item: CartItem, index: number) {
    shoppingCartService.delCartItem(item.id).then(() => {
      this.selectProducts.splice(index, 1)
      promptAction.showToast({
        message: '删除成功'
      })
    })
    this.needUpdateShopCart();
  }

  // 跳转生成订单页面
  routerDetailPage<T>(productId: T) {
    router.pushUrl({
      url: 'pages/CommodityDetailPage',
      params: { data: productId }
    }).catch((err: Error) => {
      Logger.error(JSON.stringify(err));
    });
  }

  // 单独修改商品数量
  onChangeCount = async (count: number, info: CartItem) => {
    await shoppingCartService.updateItemQuantity(info.id, count)
    this.needUpdateShopCart();
  }

  // 侧滑删除
  @Builder
  ItemDelete(item: CartItem, index: number) {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.End
    }) {
      Column() {
        Image($r('app.media.ic_trash'))
          .width($r('app.float.vp_twenty_four'))
          .height($r('app.float.vp_twenty_four'))
          .margin({ bottom: $r('app.float.vp_ten') })
        Text($r('app.string.delete'))
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.White)
      }
      .padding({ right: $r('app.float.vp_fourteen') })
    }
    .onClick(() => this.handleDelProduct(item, index))
    .height($r('app.float.item_delete_height'))
    .width($r('app.float.item_delete_width'))
    .backgroundColor($r('app.color.focus_color'))
    .borderRadius($r('app.float.vp_sixteen'))
    .margin({ left: $r('app.float.item_delete_margin_left') })
  }

  // 商品渲染
  @Builder
  CartItem(item: CartItem, index: number) {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Checkbox({
        name: `${ShopCartConstants.CHECKBOX}${index}`,
        group: ShopCartConstants.CHECKBOX_GROUP
      })
        .width($r('app.float.vp_twenty_four'))
        .height($r('app.float.vp_twenty_four'))
        .selectedColor($r('app.color.select_color'))
        .select(this.selectProductChange(index))
        .onClick(() => {
          let tempData: SelectProducts = {
            key: this.selectProducts[index].key,
            selected: !this.selectProducts[index].selected
          }
          this.selectProducts.splice(index, 1, tempData)
          this.countSumPrice()
        })
      Image(formatLocalhost(item.productPic))
        .height($r('app.float.card_image_size'))
        .width($r('app.float.card_image_size'))
        .objectFit(ImageFit.Cover)
        .margin({ left: $r('app.float.vp_sixteen') })
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceAround }) {
        Text($r('app.string.commodity_piece_description', item.productName, item.productSubTitle))
          .fontSize($r('app.float.small_font_size'))
          .margin({ bottom: $r('app.float.vp_eight') })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(StyleConstants.TWO_TEXT_LINE)
          .width(StyleConstants.FULL_WIDTH)
        Text(item.productAttr)
          .fontSize($r('app.float.smaller_font_size'))
          .maxLines(1)
          .fontColor($r('app.color.sixty_alpha_black'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width(StyleConstants.FULL_WIDTH)
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Text() {
            Span($r('app.string.rmb'))
              .fontSize($r('app.float.smaller_font_size'))
              .fontColor($r('app.color.focus_color'))
            Span(`${item.price}`)
              .fontSize($r('app.float.middle_font_size'))
              .fontColor($r('app.color.focus_color'))
          }

          CounterProduct({
            count: item.quantity,
            onNumberChange: (num: number) => {
              this.onChangeCount(num, item);
            }
          })
        }
      }
      .margin({
        left: $r('app.float.vp_sixteen'),
        top: $r('app.float.vp_twelve'),
        bottom: $r('app.float.vp_twelve')
      })
      .width(StyleConstants.FULL_WIDTH)
    }
    .padding({
      left: $r('app.float.vp_twelve'),
      right: $r('app.float.vp_twelve')
    })
    .borderRadius($r('app.float.vp_sixteen'))
    .backgroundColor(Color.White)
    .width(StyleConstants.FULL_WIDTH)
    .height($r('app.float.item_delete_height'))
  }

  @Builder
  Settle() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Flex({ alignItems: ItemAlign.Center }) {
        Checkbox({ name: ShopCartConstants.CHECKBOX, group: ShopCartConstants.CHECKBOX_GROUP }) // 全选框
          .selectedColor($r('app.color.select_color'))
          .select(this.isSelectAll)
          .onClick(() => {
            this.isSelectAll = !this.isSelectAll;
            const selectAll: SelectProducts[] = this.selectProducts.map((item) => {
              return { key: item.key, selected: this.isSelectAll }
            })
            this.selectProducts = selectAll
            this.countSumPrice()
          })
        Text($r('app.string.select_all'))
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.Grey)
      }
      .height(StyleConstants.FULL_HEIGHT)
      .width($r('app.float.settle_select_width'))

      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        Text($r('app.string.total'))
          .fontSize($r('app.float.smaller_font_size'))
          .fontWeight(FontWeight.Bold)
        Text() {
          Span($r('app.string.rmb'))
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor($r('app.color.focus_color'))
          Span(`${this.sumPrice}`)
            .fontSize($r('app.float.middle_font_size'))
            .fontColor($r('app.color.focus_color'))
        }
        .margin({
          right: $r('app.float.vp_eight'),
          left: $r('app.float.vp_eight')
        })

        Button($r('app.string.checkout'), { type: ButtonType.Capsule, stateEffect: true }) // 结算
          .backgroundColor($r('app.color.focus_color'))
          .fontSize($r('app.float.smaller_font_size'))
          .height($r('app.float.settle_button_height'))
          .width($r('app.float.settle_select_width'))
          .onClick(() => {
            this.settleAccounts();
          })
      }
      .height(StyleConstants.FULL_HEIGHT)
    }
    .padding({
      right: $r('app.float.vp_twelve'),
      left: $r('app.float.vp_twelve')
    })
    .backgroundColor(Color.White)
    .width(StyleConstants.FULL_WIDTH)
    .height($r('app.float.vp_fifty_six'))
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text($r('app.string.cart'))
        .fontSize($r('app.float.huge_font_size'))
        .height($r('app.float.vp_fifty_six'))
        .padding({ left: $r('app.float.vp_twenty_four') })
        .width(StyleConstants.FULL_WIDTH)
        .textAlign(TextAlign.Start)
      Scroll() {
        Column() {
          if (this.products.length > 0) {
            List({ space: StyleConstants.FIFTEEN_SPACE }) {
              ForEach(this.products, (item: CartItem, index?: number) => {
                ListItem() {
                  if (index !== undefined) {
                    this.CartItem(item, index)
                  }
                }
                .swipeAction({ end: this.ItemDelete(item, index), edgeEffect: SwipeEdgeEffect.None})
              }, (item: CartItem) => JSON.stringify(item))
            }
          } else {
            Column() {
              EmptyComponent()
            }
            .width(StyleConstants.FULL_WIDTH)
            .height(StyleConstants.FIFTY_HEIGHT)
          }
        }
        .justifyContent(FlexAlign.Start)
      }
      .scrollBar(BarState.Off)
      .margin({
        left: $r('app.float.vp_twelve'),
        right: $r('app.float.vp_twelve')
      })
      .height(StyleConstants.FULL_HEIGHT)

      if ((this.selectProducts).some(((item: SelectProducts) => item.selected === true))) {
        this.Settle()
      }
    }
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor($r('app.color.page_background'))
  }
}