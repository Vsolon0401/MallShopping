
@Observed
export class Category {
  id: number;
  brandId: number;
  productCategoryId: number;
  feightTemplateId: number;
  productAttributeCategoryId: number;
  name: string;
  pic: string;
  productSn: string;
  deleteStatus: number;
  publishStatus: number;
  newStatus: number;
  recommandStatus: Number;
  verifyStatus: number;
  sort: number;
  sale: number;
  price: number;
  promotionPrice: number;
  giftGrowth: number;
  giftPoint: number;
  usePointLimit: number;
  subTitle: string;
  originalPrice: number;
  stock: number;
  lowStock: number;
  unit: string;
  weight: number;
  previewStatus: number;
  /** 以逗号分割的产品服务：1->无忧退货；2->快速退款；3->免费包邮 **/
  serviceIds: string;
  keywords: string;
  note: string;
  /** 画册图片，连产品图片限制为5张，以逗号分割 **/
  albumPics: string;
  detailTitle: string;
  promotionStartTime: Date;
  promotionEndTime: Date;
  promotionPerLimit: number;
  promotionType: number;
  brandName: string;
  productCategoryName: string;
  description: string;
  detailDesc: string;
  detailHtml: string;
  detailMobileHtml: string;
}


export class Brand {
  id: number;
  name: string;
  firstLetter: string;
  sort: number;
  factoryStatus: number;
  showStatus: number;
  productCount: number;
  productCommentCount: number;
  logo: string;
  bigPic: string;
  brandStory: string;
}

export class Classify {
  id: number = 0;
  parentId: number = 0;
  name: string= '';
  level: number = 0;
  productCount: number = 0;
  productUnit: string = '';
  navStatus: number = 0;
  showStatus: number = 0;
  sort: number = 0;
  icon?: string = '';
  keywords: string = '';
  children?: Classify[] = [];

  constructor(title: string) {
    this.name = title
  }
}