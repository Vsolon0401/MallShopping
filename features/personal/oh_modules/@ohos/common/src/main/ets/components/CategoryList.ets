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

import { Category } from '../viewmodel/CategoryModel'
import { EmptyComponent } from './EmptyComponent';
import { StyleConstants } from '../constants/StyleConstants';
import { CommonDataSource } from '../utils/CommonDataSource';
import { formatLocalhost } from '../utils/Utils';

/**
 * Commodity list component.
 */
@Component
export struct CategoryList {
  @Link categoryList: Category[];
  private onClickItem? = (Category: Category) => {};

  @Builder
  CategoryItem(info: Category) {
    Row() {
      Image(formatLocalhost(info.pic))
        .width($r('app.float.commodity_item_image_size'))
        .height($r('app.float.commodity_item_image_size'))
        .objectFit(ImageFit.Contain)
        .margin({
          // top: $r('app.float.vp_sixteen'),
          right: $r('app.float.vp_eight')
        })
      Column() {
        Text(info.name)
          .fontColor(Color.Black)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(StyleConstants.ONE_TEXT_LINE)
          .fontSize($r('app.float.middle_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
          .lineHeight($r('app.float.commodity_desc_height'))
          .layoutWeight(1)
        Text(info.subTitle)
          .fontColor(Color.Grey)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(StyleConstants.TWO_TEXT_LINE)
          .fontSize($r('app.float.smaller_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FOUR)
          .lineHeight($r('app.float.commodity_desc_height'))
          .layoutWeight(1)

        Text($r('app.string.commodity_piece', info.price))
          .fontColor($r('app.color.focus_color'))
          .fontSize($r('app.float.middle_font_size'))
          .margin({
            top: $r('app.float.vp_eight'),
            bottom: $r('app.float.vp_eight')
          })
      }
      .width(StyleConstants.FULL_WIDTH)
      .alignItems(HorizontalAlign.Start)
      .constraintSize({
        maxWidth: '200vp'
      })
    }
    .padding($r('app.float.vp_twelve'))
    .height($r('app.float.category_item_height'))
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.vp_eight'))
  }

  build() {
    if (this.categoryList.length > 0) {
      List({ space: StyleConstants.TWELVE_SPACE }) {
        LazyForEach(new CommonDataSource<Category>(this.categoryList), (item: Category) => {
          ListItem() {
            this.CategoryItem(item)
          }
          // .margin({ left: $r('app.float.vp_six'), right: $r('app.float.vp_six') })
          .onClick(() => {
            if (this.onClickItem !== undefined) {
              this.onClickItem(item);
            }
          })
        }, (item: Category) => JSON.stringify(item))
      }
      .width(StyleConstants.FULL_WIDTH)
      .margin({ left: $r('app.float.commodity_list_margin'), right: $r('app.float.commodity_list_margin') })
      .listDirection(Axis.Vertical)
    } else {
      EmptyComponent({ outerHeight: StyleConstants.FIFTY_HEIGHT })
    }
  }
}