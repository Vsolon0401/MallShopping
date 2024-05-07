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

@Observed
export class Product {
  id: string = '';
  name: string = '';
  img: string[] = [];
  commodityId: string = '';
  description: string = '';
  price: number = 0;
  count: number = 0;
  selected: boolean = false;
  specifications: ProductSpecification[] = [];
  update_time?: string = '';
  create_time?: string = '';
  uid?: string = '';
}

export class ProductSpecification {
  key: string = '';
  value: string = '';
}

export class ShopProps {
  id: string = '';
  commodityId: string = '';
  count: number = 0;
  specifications: ProductSpecification[] = [];
}

export class UpdateShopProps {
  id: string = '';
  count?: number = 0;
  selected?: boolean = false;
  specifications?: ProductSpecification[] = [];
}

export class SelectProducts {
  selected: boolean = false;
  key: string = '';
}

export class ProductAttribute {
  id: number;
  productAttributeCategoryId: number;
  name: string;
  /** 属性选择类型：0->唯一；1->单选；2->多选 **/
  selectType: number;
  /** 属性录入方式：0->手工录入；1->从列表中选取 **/
  inputType: number;
  /** 可选值列表，以逗号隔开 **/
  inputList: string;
  /** 排序字段：最高的可以单独上传图片 **/
  sort: number;
  /** 分类筛选样式：1->普通；1->颜色 **/
  filterType: number;
  /** 检索类型；0->不需要进行检索；1->关键字检索；2->范围检索 **/
  searchType: number;
  /** 相同属性产品是否关联；0->不关联；1->关联 **/
  relatedStatus: number;
  /** 是否支持手动新增；0->不支持；1->支持 **/
  handAddStatus: number;
  /** 属性的类型；0->规格；1->参数 **/
  type: number;
}

export class ProductAttributeValue {
  id: number;
  productId: number;
  productAttributeId: number;
  value: string;
}

export class Selected {
  tagName?: string;
  isSelected?: boolean;
}


export class SkuStock {
  id: number;
  productId: number;
  skuCode: number;
  price: number | string;
  stock: number;
  lowStock: number;
  pic: string;
  sale: number;
  promotionPrice: string | number;
  lockStock: number;
  spData: string;
}

export class ProductLadder {
  id: number;
  productId: number;
  count: number;
  discount: string;
  price: string;
}

export class ProductFullReduction {
  id: number;
  productId: number;
  fullPrice: string;
  reducePrice: string;
}

export class Coupon {
  id: number;
  type: number;
  name: string;
  platform: number;
  count: number;
  amount: number | string;
  perLimit: number;
  minPoint: string;
  startTime: string;
  endTime: string;
  useType: number;
  note: string;
  publishCount: number;
  useCount: number;
  receiveCount: number;
  enableTime: string;
  code: string;
  memberLevel: number;
}