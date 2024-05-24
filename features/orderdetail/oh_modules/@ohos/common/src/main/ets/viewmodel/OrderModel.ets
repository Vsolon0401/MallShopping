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
import { UserAddress } from './AddressModel';
import { CartPromotionItem } from './CartModel';
import { CouponHistoryDetail } from './HistoryModel';
import { ProductSpecification } from './ProductModel';

export enum OrderType {
  All = 'all',
  PAYMENT = 'payment',
  SHIP = 'ship',
  RECEIPT = 'receipt',
  /** 已完成 **/
  EVALUATION = 'evaluation',
  SALE = 'sale'
}

export enum OrderOperationStatus {
  UN_PAY = 0,
  DELIVERED = 1,
  RECEIPT = 2,
  CONSIGNMENT = 3,
  CLOSED = 4,
  ALLStatus = -1
}

@Observed
export class Order {
  uid?: string = '';
  orderId: string = '';
  image: string = '';
  title: string = '';
  description: string = '';
  payTime?: string = '';
  orderTime?: string = '';
  createTime?: string = '';
  updateTime?: string = '';
  price: number = 0;
  count: number = 0;
  amount?: number = 0;
  status?: number = 0;
  commodityId: number = 0;
  specifications: ProductSpecification[] = [];
}

export class DateFormatting {
  y: string = '';
  m: string = '';
  d: string = '';
  H: string = '';
  M: string = '';
  S: string = '';
}


export class InsertOrderProps {
  order: Order | undefined = undefined;
  status: number = 0;
  createTime?: string = '';
}

export class updateOrderProps {
  orderId: string = '';
  status: number = 0;
  amount?: number;
}

// export class OrderStatus {
//   order?: Order;
//   status?: number;
// }

@Observed
export class ConfirmOrderType {
  cartPromotionItemList: CartPromotionItem[];
  memberReceiveAddressList: UserAddress[];
  couponHistoryDetailList: CouponHistoryDetail[];
  integrationConsumeSetting?: IntegrationConsumeSetting;
  memberIntegration?: number;
  calcAmount: CalcAmount;
}

export class CalcAmount {
  totalAmount: number;
  freightAmount: number;
  promotionAmount: number;
  payAmount: number;
}

export class IntegrationConsumeSetting {
  id: number;
  deductionPerAmount: number;
  maxPercentPerOrder: number;
  useUnit: number;
  couponStatus: number;
}

export enum PayType {
  NoPay,
  Alipay,
  WechatPay
}

export enum OrderStatus {
  PendingPayment,
  ToBeShipped,
  Shipped,
  Completed,
  Closed,
  InvalidOrder
}

export class OrderDetail {
  id: number;
  memberId: number;
  couponId: number;
  orderSn: string;
  createTime?: string;
  memberUsername: string;
  totalAmount: number;
  payAmount: number;
  freightAmount: number;
  promotionAmount: number;
  integrationAmount: number;
  couponAmount: number;
  discountAmount: number;
  // "支付方式：0->未支付；1->支付宝；2->微信"
  payType: PayType;
  sourceType: number;
  status: OrderStatus;
  orderType: number;
  deliveryCompany: string;
  deliverySn: string;
  autoConfirmDay: number;
  integration: number;
  growth: number;
  promotionInfo: number;
  billType: number;
  billHeader: string;
  billContent: string;
  billReceiverPhone: string;
  billReceiverEmail: string;
  receiverName: string;
  receiverPhone: string;
  receiverPostCode: string;
  receiverProvince: string;
  receiverCity: string;
  receiverRegion: string;
  receiverDetailAddress: string;
  note: string;
  confirmStatus: number;
  deleteStatus: number;
  useIntegration: number;
  paymentTime: string | Date;
  deliveryTime: string | Date;
  receiveTime: string | Date;
  commentTime: string | Date;
  modifyTime: string | Date;
}

export class OrderItem {
  id: number;
  orderId: number;
  orderSn: string;
  productId: number;
  productPic: string;
  productName: string;
  productBrand: string;
  productSn: string;
  productPrice: number;
  productQuantity: number;
  productSkuId: number;
  productSkuCode: string;
  productCategoryId: number;
  promotionName: string;
  promotionAmount: number;
  couponAmount: number;
  integrationAmount: number;
  realAmount: number;
  giftIntegration: number;
  giftGrowth: number;
  productAttr: string;
}


export class OrderInfo extends OrderDetail {
  orderItemList: OrderItem[]
}