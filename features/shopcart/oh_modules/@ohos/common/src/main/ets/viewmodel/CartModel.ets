
export class CartItem {
  id?: number;
  productId?: number;
  productSkuId?: number;
  memberId?: number;
  selected?: boolean;
  quantity: number;
  price: number;
  productPic: string;
  productName: string;
  productSubTitle: string;
  productSkuCode: string;
  memberNickname: string;
  createDate?: Date;
  modifyDate?: Date;
  deleteStatus: number;
  productCategoryId: number;
  productBrand: string;
  productSn: string;
  /** 商品销售属性:[{'key':'颜色','value':'颜色'},{'key':'容量','value':'4G'}] **/
  productAttr: string;
  
}