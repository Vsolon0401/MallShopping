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

import { Specification, CounterProduct, Commodity, KV, GridConstants, StyleConstants, CommodityInfo, formatLocalhost, ProductAttribute, Logger,ProductAttributeValue } from '@ohos/common';
import { CapsuleGroupButton } from './CapsuleGroupButton';
import { ColorChange, FinishType } from '../viewmodel/TypeModel';
import { CommodityConstants } from '../constants/CommodityConstants';
import { ProductSpecification, Selected } from '@ohos/common/src/main/ets/viewmodel/ProductModel';


@CustomDialog
export struct SpecificationDialog {

  @State specificationChange: any[] = [];
  @State productAttributeList: ProductAttribute[] = [];
  @State productAttributeValueList: Selected[] = [];
  @Link data: CommodityInfo;
  @Link count: number;
  @Link selectTags: ProductSpecification[];
  @Link productOptions: string;
  @State isSelected: boolean = false;
  controller?: CustomDialogController;
  private onFinish?: (type: FinishType, count: number, selectKeys: ProductSpecification[]) => void;
  aboutToAppear(){
    this.productAttributeList = this.data?.productAttributeList.filter(item => item.type === 0)
    const commonAttributeList = []
    this.productAttributeList.forEach(attr => {
      if (attr.inputType === 1) {
        commonAttributeList.concat(attr.inputList.split(','))
      } else {
        const temp = this.data.productAttributeValueList.find(av => av.productAttributeId === attr.id).value.split(',')
        commonAttributeList.concat(temp)
      }
    })

    this.productAttributeValueList = commonAttributeList.map(common => {
      return { tagName: common, isSelected: false }
    })
    if (this.selectTags.length === 0) {
      this.productAttributeList.forEach((item) => {
        const defaultSelectedTag: ProductSpecification = item.inputType === 1
          ? { key: item.name, value: item.inputList.split(',')[0] }
          : { key: item.name,
              value: this.data.productAttributeValueList.find(
                av => av.productAttributeId === item.id
              ).value.split(',')[0] }
        this.selectTags.push(defaultSelectedTag)
      })
    }
  }

  onTagSelect(tagValue: string, tagKey: string) {
    const selectedTag: ProductSpecification = { key: tagKey, value: tagValue }
    this.selectTags.forEach((item) => {
      if (item.key === tagKey) {
        item.value = tagValue
      }
    })
    const check = this.selectTags.some(item => item.key === selectedTag.key)
    if (!check) {
      this.selectTags.push(selectedTag)
    }
    this.onColorChange(tagKey)
    this.onSelectKeysChange()
  }

  onSelectKeysChange(){
    this.productOptions = '';
    this.selectTags.forEach((item)=>{
      this.productOptions += item.value+' ';
    })
  }

  onColorChange(key: string) {
    let temp: string = ''
    this.selectTags.forEach((tag) => {
      if (tag.key === key) {
        temp = tag.value
      }
    })
    return temp
  }

  @Builder ButtonGroup() {
    Flex() {
      CapsuleGroupButton({
        configs: [{
          text: $r('app.string.insert_cart'),
          onClick: () => {
            this.controller?.close();
            if (this.onFinish) {
              this.onFinish(FinishType.JOIN_SHOPPING_CART, this.count, this.selectTags);
            }
          }
        }, {
          text: $r('app.string.buy_now'),
          onClick: () => {
            this.controller?.close();
            if (this.onFinish) {
              this.onFinish(FinishType.BUY_NOW, this.count, this.selectTags);
            }
          }
        }]
      })
    }
    .width(StyleConstants.FULL_WIDTH)
    .height($r('app.float.vp_fifty_six'))
    .padding($r('app.float.vp_twelve'))
  }

  @Builder Specification(
   $$: {
     productAttribute: string,
     productAttributeValue: string[],
   }
  ) {
    Column() {
      Text($$.productAttribute)
        .fontSize($r('app.float.small_font_size'))
        .margin({ bottom: $r('app.float.vp_twelve') })
        .fontColor($r('app.color.sixty_alpha_black'))
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach($$.productAttributeValue, (item: string) => {
          Text(item)
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(this.onColorChange($$.productAttribute) === item ?
            $r('app.color.focus_color') : Color.Black)
            .height($r('app.float.vp_twenty_four'))
            .padding({
              top: $r('app.float.vp_six'),
              bottom: $r('app.float.vp_six'),
              left: $r('app.float.vp_ten'),
              right: $r('app.float.vp_ten')
            })
              .backgroundColor(this.onColorChange($$.productAttribute) === item?
                $r('app.color.dialog_select_tag') : $r('app.color.five_alpha_black'))
            .margin({ bottom: $r('app.float.vp_ten'), right: $r('app.float.vp_twelve') })
            .borderRadius($r('app.float.vp_twelve'))
            .onClick(() => this.onTagSelect(item, $$.productAttribute))
        }, (item: string) => item)
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width(StyleConstants.FULL_WIDTH)
    .margin({ bottom: $r('app.float.vp_fourteen') })
  }

  build() {
    GridRow({ columns: { sm: GridConstants.COLUMN_FOUR, md: GridConstants.COLUMN_EIGHT,
      lg: GridConstants.COLUMN_TWELVE }, gutter: GridConstants.GUTTER_TWELVE }) {
      GridCol({ span: { sm: GridConstants.SPAN_FOUR, md: GridConstants.SPAN_EIGHT, lg: GridConstants.SPAN_EIGHT },
        offset: { lg: GridConstants.OFFSET_TWO } }) {
        Column() {
          Row() {
            Image(formatLocalhost(this.data.product.pic))
              .width($r('app.float.dialog_commodity_image_size'))
              .height($r('app.float.dialog_commodity_image_size'))
              .objectFit(ImageFit.Cover)
              .margin({
                left: $r('app.float.vp_sixteen'),
                right: $r('app.float.vp_sixteen')
              })
            Column() {
              Text() {
                Span($r('app.string.rmb'))
                  .fontSize($r('app.float.middle_font_size'))
                  .fontColor($r('app.color.focus_color'))
                Span(`${this.data.product.price}`)
                  .fontSize($r('app.float.bigger_font_size'))
                  .fontColor($r('app.color.focus_color'))
              }
              .margin({ bottom: $r('app.float.vp_twelve') })

              Text(`${CommodityConstants.SPECIAL_CHOOSE} ：${this.productOptions} ${this.count ? `X${this.count}` : ''}`)
                .fontSize($r('app.float.smaller_font_size'))
                .fontColor(Color.Black)
                .maxLines(CommodityConstants.MAX_LINE)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .layoutWeight(StyleConstants.LAYOUT_WEIGHT)
            .alignItems(HorizontalAlign.Start)
          }
          .margin({
            top: $r('app.float.vp_twenty_four'),
            bottom: $r('app.float.vp_twenty_four'),
            left: $r('app.float.vp_twelve'),
            right: $r('app.float.vp_twelve')
          })

          Scroll() {
            Column() {
              ForEach(this.productAttributeList, (item: ProductAttribute) => {
                this.Specification({
                  productAttribute:item.name,
                  productAttributeValue: item.inputType === 1
                    ? item.inputList.split(',')
                    : this.data.productAttributeValueList.find(av => av.productAttributeId === item.id).value.split(','),
                })
              })
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text($r('app.string.quantity'))
                  .fontSize($r('app.float.small_font_size'))
                  .fontColor($r('app.color.sixty_alpha_black'))
                CounterProduct({
                  count: this.count,
                  onNumberChange: (num: number) => this.count = num
                })
              }
              .margin({ right: $r('app.float.vp_twenty_four') })
            }
          }
          .margin({ left: $r('app.float.vp_sixteen') })

          this.ButtonGroup()
        }
        .border({
          radius: {
            topRight: $r('app.float.dialog_radius'),
            topLeft: $r('app.float.dialog_radius')
          }
        })
        .backgroundColor($r('app.color.page_background'))
        .width(StyleConstants.FULL_WIDTH)
      }
    }
  }
}