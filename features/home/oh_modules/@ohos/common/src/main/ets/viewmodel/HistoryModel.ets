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

// todo: 类型补充
export class CouponHistoryDetail extends CouponHistory {
  coupon: Coupon;
  productRelationList: any[];
  categoryRelationList: any[]
}