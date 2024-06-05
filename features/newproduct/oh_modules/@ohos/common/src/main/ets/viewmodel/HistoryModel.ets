import { Collection } from './CollectionModel';
import { Coupon } from './ProductModel';
export class CouponHistory {
  id?: number;
  couponId: number;
  memberId: number;
  couponCode: string;
  memberNickname: string;
  getType: number;
  createTime?: string;
  useStatus: number;
  useTime: string | Date;
  orderId: number;
  orderSn: string;
}

export class CouponHistoryDetail extends CouponHistory {
  coupon: Coupon;
  productRelationList: any[];
  categoryRelationList: any[]
}

export class MemberHistory extends Collection {}
