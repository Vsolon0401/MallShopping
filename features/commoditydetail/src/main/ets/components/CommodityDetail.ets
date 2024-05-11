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
import { CartItem, collectionService, CommodityInfo, getSkuStock, historyService, Order, ProductSpecification, shoppingCartService } from '@ohos/common';
import { FinishType, ProductService } from '../viewmodel/TypeModel';
import { SpecificationDialog } from './SpecificationDialog';
import { barData, userEvaluate, moreEvaluate, serviceList, Evaluate, BarData, BarType } from '../viewmodel/CommodityDetailData';
import { CapsuleGroupButton } from '../components/CapsuleGroupButton';
import { CommodityConstants } from '../constants/CommodityConstants';
import {
  LocalDataManager,
  Logger,
  Commodity,
  StyleConstants,
  GridConstants,
  CommonDataSource,
  getID,
  Specification
} from '@ohos/common';
import { ProductAttribute, ShopProps, SkuSpecification, SkuStock } from '@ohos/common/src/main/ets/viewmodel/ProductModel';

@Extend(Button) function titleButton() {
  .backgroundColor($r('app.color.zero_alpha_black'))
  .width($r('app.float.title_button_size'))
  .height($r('app.float.title_button_size'))
  .borderRadius($r('app.float.vp_four'))
}


@Component
export struct CommodityDetail {
  // 商品id
  @Prop commodityId: string;
  // 商品详情信息
  @Link @Watch('onInfoChange') info: CommodityInfo;
  // 购物车商品信息
  @State productCartInfo: CartItem = new CartItem();
  // 商品图片
  @Link productImgList: string[];
  // 服务列表
  @State serviceList: ProductService[] = CommodityConstants.DEFAULT_SERVICE_LIST;
  // 优惠信息
  @State promotionTip: string = '';
  // 已选商品的属性
  @State @Watch('onSelectKeysChange') selectKeys: ProductSpecification[] = [];
  // 选择的商品数
  @State count: number = 1;
  // 商品规格列表
  @State productSpecificationList: SkuSpecification[] = [];
  // 收藏状态用于筛选barList, 反选状态
  @State favorite: BarType.COLLECTION | BarType.CANCEL_COLLECTION = BarType.COLLECTION
  // 初始化状态
  private isInit: boolean = false;
  @State swiperIndex: number = 0;
  @State productOptions: string = '';


  private skuCache: Set<string> = new Set()
  private data: CommonDataSource<Evaluate> = new CommonDataSource<Evaluate>(userEvaluate.evaluate !== undefined ?
  userEvaluate.evaluate : []);

  dialogController: CustomDialogController = new CustomDialogController({
    builder: SpecificationDialog({
      onFinish: (type: FinishType, count: number, selectKeys: ProductSpecification[]) =>
        this.onSpecificationFinish(type, count, selectKeys),
      data: $info,
      count: $count,
      selectTags: $selectKeys,
      productOptions:$productOptions,
      productSpecificationList: $productSpecificationList
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  onInfoChange() {
    //初始化
    if (!this.isInit && this.info !== undefined) {
      // set存储sku筛选可用选项
      this.info.skuStockList.forEach((skuStock: SkuStock) => {
        const spData: ProductSpecification[] = JSON.parse(skuStock.spData)
        spData.forEach(spItem => {
          this.skuCache.add(spItem.value)
        })
      })
      this.initSpecification()
      this.initPromotionTipList(this.info)

      // 初始化服务信息
      this.serviceList.forEach((item, index) => {
        if (!this.info.product.serviceIds.includes(item.id.toString())) {
          this.serviceList.splice(index, 1)
        }
      })

      // 创建历史浏览记录
      this.createHistory()

      // 初始话收藏记录
      this.fetchCollection(this.info.product.id)
      this.isInit = true
    }
  }
  // 初始化规格
  initSpecification() {
    const productAttribute: ProductAttribute[] = this.info.productAttributeList.filter(item => item.type === 0)
    const specList = []
    let specChildList = []
    // 构建specList， specChildList
    productAttribute.forEach((item) => {
      specList.push({
        id: item.id,
        name: item.name
      })

      const specListHand = item.handAddStatus === 1
        ? this.info.productAttributeValueList.find(
          av => av.productAttributeId === item.id
        ).value.split(',')
        : item.inputList.split(',')

      specListHand.forEach((specValue) => {
        specChildList.push({
          pid: item.id,
          pname: item.name,
          name: specValue
        })
      })
    })

    // filter
    specChildList = specChildList.filter(item => this.skuCache.has(item.name))

    const productSpecificationList: SkuSpecification[] = []
    const defaultSelected: ProductSpecification[] = []
    specList.forEach(specItem => {
       const productSpecificationValueList = specChildList.reduce((acc, curSp) => {
         if (curSp.pname === specItem.name || curSp.pid === specItem.id) {
           acc.push(curSp.name)
         }
         return acc
       }, [])
      // 默认选择第一项
      if (this.selectKeys.length === 0) {
        defaultSelected.push({ key: specItem.name, value: productSpecificationValueList[0] })
      }

      productSpecificationList.push({ key: specItem.name, specList: productSpecificationValueList })
    })

    this.productSpecificationList = productSpecificationList
    this.selectKeys = defaultSelected
  }
  // 初始化优惠信息
  initPromotionTipList(data: CommodityInfo) {
    const promotionType = this.info.product.promotionType;
    switch(promotionType) {
      case 0:
        this.promotionTip = '暂无优惠'
        break;
      case 1:
        this.promotionTip = '单品优惠'
        break;
      case 2:
        this.promotionTip = '会员优惠'
        break;
      case 3:
        this.promotionTip = '多买优惠'
        for (let item of data.productLadderList) {
          this.promotionTip += (" 满" + item.count + "件打" + Number(item.discount) * 10 + "折");
        }
        break;
      case 4:
        for (let item of data.productFullReductionList) {
          this.promotionTip += (" 满" + item.fullPrice + "元减" + item.reducePrice + "元");
        }
        this.promotionTip = '满减优惠'
        break;
      case 5:
        this.promotionTip = '限时优惠'
        break;
    }
  }
  // 创建浏览记录
  createHistory() {
    const product = this.info.product
    historyService.createReadHistory({
      productId: product.id,
      productName: product.name,
      productPic: product.pic,
      productPrice: product.price,
      productSubTitle: product.subTitle,
    })
  }
  // 获取收藏信息
  fetchCollection(productId: number) {
    collectionService.fetchCollectionDetail(productId).then(res => {
      this.favorite = res.data != null ? BarType.COLLECTION : BarType.CANCEL_COLLECTION
    })
  }

  onSelectKeysChange() {
    this.productOptions = '';
    if (this.selectKeys !== undefined) {
      this.selectKeys.forEach((item) => {
        this.productOptions += item.value + ' ';
      })
    }
  }

  async onSpecificationFinish(type: FinishType, count: number, selectKeys: ProductSpecification[]) {
    this.count = count;
    this.selectKeys = selectKeys;
    switch (type) {
      case FinishType.JOIN_SHOPPING_CART:
        const product = this.info.product
        const productSkuStock: SkuStock = getSkuStock(this.info.skuStockList, this.selectKeys)
        if (productSkuStock !== null) {
          const cartItem: CartItem = {
            price: product.price,
            productAttr: productSkuStock.spData,
            productBrand: product.brandName,
            productCategoryId: product.productCategoryId,
            productId: product.id,
            productName: product.name,
            productPic: product.pic,
            productSkuCode: productSkuStock.skuCode,
            productSkuId: productSkuStock.id,
            productSn: product.productSn,
            productSubTitle: product.subTitle,
            quantity: 1
          }
          const res = await shoppingCartService.addCartItem(cartItem)
          if (res.code === 200) {
            promptAction.showToast({
              message: $r('app.string.insert_cart_success')
            });
          }
        }
        break;
      case FinishType.BUY_NOW:
        // if (this.info !== undefined) {
        //   let orderList: Order = {
        //     orderId: params.id,
        //     image: this.info.images[0],
        //     title: this.info.title,
        //     description: this.info.description,
        //     price: this.info.price,
        //     count: params.count,
        //     commodityId: Number.parseInt(params.commodityId),
        //     specifications: this.selectKeys
        //   }
        //   router.pushUrl({
        //     url: CommodityConstants.CONFIRM_ORDER_PAGE_URL,
        //     params: { orderList: [orderList] }
        //   }).catch((err: Error) => {
        //     Logger.error(JSON.stringify(err));
        //   });
        //   break;
        // }
    }
  }

  async bottomBtnClick(type: FinishType) {
    if (this.selectKeys !== undefined) {
      this.onSpecificationFinish(type, this.count, this.selectKeys);
    }
  }

  async handleBarClick(item: BarData) {
    const type = item.type
    switch (type) {
      case BarType.SHARE:
        break;
      case BarType.COLLECTION:
        const product = this.info.product
        const res = await collectionService.addCollection({
          productId: product.id,
          productName: product.name,
          productPic: product.pic,
          productPrice: product.price.toString(),
          productSubTitle: product.subTitle
        })
        if (res.code === 200) {
          this.favorite = BarType.COLLECTION
          promptAction.showToast({
            message: '收藏成功'
          })
        }
        break;
      case BarType.CANCEL_COLLECTION:
        const productId = this.info.product.id
        const action = await collectionService.delCollection(productId)
        if (action.code === 200) {
          this.favorite = BarType.CANCEL_COLLECTION
          promptAction.showToast({
            message: '收藏成功'
          })
        }
      case BarType.PREFERENTIAL:
        break;
    }
  }

  @Styles backgroundStyle(){
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_sixteen'))
    .padding({
      left: $r('app.float.vp_twelve'),
      right: $r('app.float.vp_twelve'),
      top: $r('app.float.vp_sixteen'),
      bottom: $r('app.float.vp_sixteen')
    })
    .margin({
      top: $r('app.float.vp_twelve'),
      right: $r('app.float.vp_twelve'),
      left: $r('app.float.vp_twelve')
    })
  }

  // 商品图片
  @Builder CustomSwiper(payload: string[]) {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Swiper() {
        ForEach(payload, (item: string) => {
          Flex({ justifyContent: FlexAlign.Center }) {
            Image(item)
              .height(StyleConstants.FULL_HEIGHT)
              .aspectRatio(1)
              .objectFit(ImageFit.Cover)
          }
          .margin({
            left: $r('app.float.swiper_image_margin'),
            right: $r('app.float.swiper_image_margin'),
            top: $r('app.float.vp_twenty'),
            bottom: $r('app.float.vp_twenty')
          })
        }, (item: string) => JSON.stringify(item))
      }
      .onChange((index: number) => this.swiperIndex = index)
      .indicator(false)
      .width(StyleConstants.FULL_WIDTH)
      .height(StyleConstants.FULL_HEIGHT)

      Text(`${this.swiperIndex + 1}/${payload.length}`)
        .fontSize($r('app.float.smaller_font_size'))
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .width($r('app.float.swiper_indicator_text_width'))
        .height($r('app.float.vp_eighteen'))
        .backgroundColor($r('app.color.forty_alpha_black'))
        .borderRadius($r('app.float.swiper_indicator_text_radius'))
        .margin({
          right: $r('app.float.vp_sixteen'),
          bottom: $r('app.float.vp_sixteen')
        })
    }
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(Color.White)
    .height($r('app.float.swiper_height'))
  }

  // 商品标题
  @Builder TitleBar(payload: CommodityInfo) {
    Flex({ direction: FlexDirection.Column }) {
      Text() {
        Span($r('app.string.rmb'))
          .fontSize($r('app.float.middle_font_size'))
          .fontColor($r('app.color.focus_color'))
        Span(`${payload.product.price}`)
          .fontSize($r('app.float.bigger_font_size'))
          .fontColor($r('app.color.focus_color'))
      }
      Column() {
        Text(payload.product.name)
          .fontColor(Color.Black)
          .fontSize($r('app.float.middle_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)

        Text(payload.product.subTitle)
          .fontColor(Color.Gray)
          .fontSize($r('app.float.small_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
      }
      .width(StyleConstants.FULL_WIDTH)
      .margin({ top: $r('app.float.vp_four') })

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(barData.filter(barItem => barItem.type !== this.favorite), (item: BarData) => {
          Row() {
            Image(item.icon !== undefined ? item.icon : '')
              .height($r('app.float.vp_fourteen'))
              .width($r('app.float.vp_fourteen'))
              .margin({ right: $r('app.float.vp_four') })
            Text(item.text)
              .fontSize($r('app.float.micro_font_size'))
              .fontColor($r('app.color.sixty_alpha_black'))
          }
          .onClick(() => this.handleBarClick(item))
        }, (item: BarData) => JSON.stringify(item))
      }
      .height($r('app.float.vp_fourteen'))
      .margin({ top: $r('app.float.vp_twelve') })
    }
    .backgroundStyle()
  }

  // 商品优惠信息
  @Builder Preferential() {
    Row() {
      Marquee({
        start: (this.promotionTip !== '' && this.promotionTip !== '暂无优惠'),
        src: this.promotionTip
      })
        .layoutWeight(StyleConstants.LAYOUT_WEIGHT)
        .fontColor(Color.Black)
        .fontSize($r('app.float.middle_font_size'))
        .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
    }
      .backgroundStyle()

  }

  // 已选商品属性
  @Builder Specification() {
    Row() {
      Text($r('app.string.choice'))
        .fontColor(Color.Black)
        .fontSize($r('app.float.small_font_size'))
        .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
        .margin({ right: $r('app.float.vp_sixteen') })
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text(`${this.productOptions}x${this.count}`)
          .fontSize($r('app.float.small_font_size'))
        Image($r('app.media.ic_point'))
          .height($r('app.float.vp_twelve'))
          .width($r('app.float.vp_six'))
      }
      .layoutWeight(StyleConstants.LAYOUT_WEIGHT)
      .onClick(() => this.dialogController.open())
    }
    .backgroundStyle()
  }

  // 参数、配送、服务
  @Builder SpecialService() {
    Column() {
      // 参数
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Start
      }) {
        Text($r('app.string.attribute'))
          .fontColor(Color.Black)
          .fontSize($r('app.float.small_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
          .margin({ right: $r('app.float.vp_sixteen') })

        Scroll() {
          List() {
            ForEach(this.info.productAttributeList.filter((item => item.type === 1)), (item: ProductAttribute) => {
              ListItem() {
                Column() {
                  Text(this.info.productAttributeValueList.find(av => av.productAttributeId === item.id).value)
                    .fontColor(Color.Black)
                    .fontSize($r('app.float.small_font_size'))
                    .margin({ left: $r('app.float.vp_eight') })
                  Text(item.name)
                    .fontColor(Color.Gray)
                    .fontSize($r('app.float.small_font_size'))
                    .margin({ right: $r('app.float.vp_eight') })
                }
                .alignItems(HorizontalAlign.Center)
              }
            }, (item) => JSON.stringify(item))
          }
          .width(StyleConstants.FULL_WIDTH)
          .listDirection(Axis.Horizontal)
        }
        .margin({ bottom: $r('app.float.vp_sixteen') })
        .layoutWeight(StyleConstants.LAYOUT_WEIGHT)
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
      }

      Divider()
        .margin({
          left: $r('app.float.vp_fifty_six'),
          right: $r('app.float.vp_twelve'),
          bottom: $r('app.float.vp_twelve')
        })
        .height($r('app.float.service_divide_height'))
        .backgroundColor($r('app.color.twenty_alpha_black'))

      //todo: 地址选择
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Start
      }) {
        Text($r('app.string.send'))
          .fontColor(Color.Black)
          .fontSize($r('app.float.small_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
          .margin({ right: $r('app.float.vp_sixteen') })
        Flex({
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center
        }) {
          Row() {
            Image($r('app.media.ic_send'))
              .width($r('app.float.vp_sixteen'))
              .height($r('app.float.vp_sixteen'))
            Text($r('app.string.send_hint'))
              .fontColor($r('app.color.sixty_alpha_black'))
              .fontSize($r('app.float.small_font_size'))
              .margin({ left: $r('app.float.vp_eight') })
          }

          Image($r('app.media.ic_point'))
            .height($r('app.float.vp_twelve'))
            .width($r('app.float.vp_six'))
        }
        .layoutWeight(StyleConstants.LAYOUT_WEIGHT)
        .height($r('app.float.vp_twenty'))
        .margin({ bottom: $r('app.float.vp_sixteen') })
      }

      Divider()
        .margin({
          left: $r('app.float.vp_fifty_six'),
          right: $r('app.float.vp_twelve'),
          bottom: $r('app.float.vp_twelve')
        })
        .height($r('app.float.service_divide_height'))
        .backgroundColor($r('app.color.twenty_alpha_black'))

      // 服务
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Start
      }) {
        Text($r('app.string.service'))
          .fontColor(Color.Black)
          .fontSize($r('app.float.small_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
          .margin({ right: $r('app.float.vp_sixteen') })
        Flex({ direction: FlexDirection.Column }) {
          ForEach(this.serviceList, (item: ProductService, index?: number) => {
            Flex({ alignItems: ItemAlign.Center }) {
              Image($r('app.media.ic_supplying'))
                .width($r('app.float.vp_sixteen'))
                .height($r('app.float.vp_sixteen'))
              Text(item.name)
                .fontColor(Color.Black)
                .fontSize($r('app.float.vp_fourteen'))
                .margin({ left: $r('app.float.vp_eight') })
            }
            .height($r('app.float.vp_twenty'))
            .margin({
              bottom: index === serviceList.length - 1 ? 0 : $r('app.float.vp_sixteen')
            })
          }, (item: ProductService) => JSON.stringify(item))
        }
        .layoutWeight(StyleConstants.LAYOUT_WEIGHT)
      }
    }
    .backgroundStyle()
  }

  //todo: 用户评价
  @Builder UserEvaluate() {
    Column({ space: StyleConstants.TWELVE_SPACE }) {
      Row() {
        Text(userEvaluate.title)
          .fontSize($r('app.float.middle_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
          .fontColor(Color.Black)
        Blank()
        Text(userEvaluate.favorable)
          .fontSize($r('app.float.small_font_size'))
          .fontColor($r('app.color.focus_color'))
        Text($r('app.string.evaluate_favorable'))
          .fontSize($r('app.float.small_font_size'))
          .fontColor($r('app.color.sixty_alpha_black'))
        Image($r('app.media.ic_right_arrow'))
          .objectFit(ImageFit.Contain)
          .height($r('app.float.vp_twenty_four'))
          .width($r('app.float.vp_twelve'))
      }
      .width(StyleConstants.FULL_WIDTH)

      LazyForEach(this.data, (item: Evaluate) => {
        this.Evaluate(item);
      }, (item: Evaluate, index?: number) => JSON.stringify(item) + index)
      Text($r('app.string.evaluate_show_more'))
        .fontSize($r('app.float.small_font_size'))
        .width($r('app.float.evaluate_text_width'))
        .height($r('app.float.evaluate_text_height'))
        .textAlign(TextAlign.Center)
        .border({
          width: $r('app.float.vp_one'),
          color: $r('app.color.twenty_alpha_black'),
          radius: $r('app.float.evaluate_text_radius')
        })
        .onClick(() => {
          if (this.data !== undefined) {
            this.data.addData(this.data.totalCount(), moreEvaluate);
          }
        })
    }
    .backgroundStyle()
  }

  @Builder Evaluate(evaluate: Evaluate) {
    Column({ space: StyleConstants.TWELVE_SPACE }) {
      Row() {
        Image(evaluate.userIcon !== undefined ? $rawfile(evaluate.userIcon) : '')
          .objectFit(ImageFit.Contain)
          .width($r('app.float.evaluate_icon_size'))
          .height($r('app.float.evaluate_icon_size'))
        Column({ space: StyleConstants.FOUR_SPACE }) {
          Text(evaluate.userNumber)
            .fontSize($r('app.float.small_font_size'))
            .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
            .fontColor(Color.Black)
          Rating({ rating: Number(evaluate.rating) })
            .hitTestBehavior(HitTestMode.None)
            .size({
              width: $r('app.float.evaluate_rating_width'),
              height: $r('app.float.vp_twelve')
            })
            .stars(CommodityConstants.RATING_STARS)
        }
        .alignItems(HorizontalAlign.Start)
        .width(StyleConstants.FULL_WIDTH)
        .margin({ left: $r('app.float.vp_twelve') })
      }
      .width(StyleConstants.FULL_WIDTH)

      Text(evaluate.desc)
        .fontSize($r('app.float.small_font_size'))
        .fontColor($r('app.color.eighty_alpha_black'))
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder DetailList() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center
    }) {
      RichText(this.info.product.detailMobileHtml) // FIXME: 富文本加载
        .width(StyleConstants.FULL_WIDTH)
      // ForEach(images, (image: string) => {
      //   Image($rawfile(image))
      //     .width(StyleConstants.FULL_WIDTH)
      //     .constraintSize({ maxWidth: $r('app.float.detail_image_max_width') })
      //     .objectFit(ImageFit.Cover)
      // }, (image: string) => JSON.stringify(image))
    }
    .width(StyleConstants.FULL_WIDTH)
    .backgroundStyle()
  }

  // todo:调整button事件
  @Builder BottomMenu() {
    Flex({ alignItems: ItemAlign.Center }) {
      Row() {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center }) {
          Image($r('app.media.ic_home'))
            .height($r('app.float.button_image_size'))
            .width($r('app.float.button_image_size'))
          Text($r('app.string.index'))
            .fontSize($r('app.float.micro_font_size'))
            .fontColor($r('app.color.sixty_alpha_black'))
            .margin({ top: $r('app.float.vp_four') })
        }
        .onClick(() => {
          AppStorage.Set('IndexPage', CommodityConstants.INDEX_HOME);
          router.back();
        })
        .height(StyleConstants.FULL_HEIGHT)
        .width($r('app.float.button_flex_width'))

        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center
        }) {
          Image($r('app.media.ic_shopping_cart'))
            .height($r('app.float.button_image_size'))
            .width($r('app.float.button_image_size'))
          Text($r('app.string.cart'))
            .fontSize($r('app.float.micro_font_size'))
            .fontColor($r('app.color.sixty_alpha_black'))
            .margin({ top: $r('app.float.vp_four') })
        }.onClick(() => {
          AppStorage.Set('IndexPage', CommodityConstants.INDEX_SHOPPING_CART);
          router.back();
        })
        .height(StyleConstants.FULL_HEIGHT)
        .width($r('app.float.button_flex_width'))
      }
      .height(StyleConstants.FULL_HEIGHT)
      .margin({ right: $r('app.float.vp_eight') })

      CapsuleGroupButton({
        configs: [{
          text: $r('app.string.insert_cart'),
          onClick: () => this.bottomBtnClick(FinishType.JOIN_SHOPPING_CART)
        }, {
          text: $r('app.string.buy_now'),
          onClick: () => this.bottomBtnClick(FinishType.BUY_NOW)
        }]
      })
    }
    .height($r('app.float.vp_fifty_six'))
    .width(StyleConstants.FULL_WIDTH)
    .padding({ right: $r('app.float.vp_sixteen') })
    .backgroundColor($r('app.color.page_background'))
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Flex({ direction: FlexDirection.Column }) {
        Scroll() {
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
                sm: GridConstants.SPAN_FOUR,
                md: GridConstants.SPAN_EIGHT,
                lg: GridConstants.SPAN_TWELVE }
            }) {
              if (this.info !== undefined) {
                this.CustomSwiper(this.productImgList)
              }
            }

            GridCol({
              span: {
                sm: GridConstants.SPAN_FOUR,
                md: GridConstants.SPAN_EIGHT,
                lg: GridConstants.SPAN_EIGHT
              },
              offset: { lg: GridConstants.OFFSET_TWO }
            }) {
              Column() {
                if (this.info) {
                  this.TitleBar(this.info)
                  this.Preferential()
                  this.Specification()
                  this.SpecialService()
                  this.UserEvaluate()
                  this.DetailList()
                }
              }
            }
          }
        }
        .flexGrow(StyleConstants.FLEX_GROW)

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
              sm: GridConstants.SPAN_FOUR,
              md: GridConstants.SPAN_EIGHT,
              lg: GridConstants.SPAN_EIGHT
            },
            offset: { lg: GridConstants.OFFSET_TWO } }) {
            this.BottomMenu()
          }
        }
      }

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Button() {
          Image($r('app.media.ic_back'))
            .height(StyleConstants.FULL_HEIGHT)
            .aspectRatio(1)
        }
        .titleButton()
        .onClick(() => router.back())

        Button() {
          Image($r('app.media.ic_share'))
            .height(StyleConstants.FULL_HEIGHT)
            .aspectRatio(1)
        }
        .titleButton()
      }
      .margin({
        left: $r('app.float.vp_sixteen'),
        top: $r('app.float.vp_sixteen'),
        right: $r('app.float.vp_sixteen')
      })
    }
  }
}