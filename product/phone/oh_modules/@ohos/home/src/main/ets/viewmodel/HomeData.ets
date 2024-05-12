
/**
 * static mock
 */
const searchSwiper: Resource[] = [
  $r('app.string.swiper_model_mate'),
  $r('app.string.swiper_model_chang'),
  $r('app.string.swiper_model_mate_book'),
  $r('app.string.swiper_model_Nova')
]

const classifyTitle: Resource[] = [
  $r('app.string.title_bar_homepage'),
  $r('app.string.title_bar_phone'),
  $r('app.string.title_bar_computer'),
  $r('app.string.title_bar_foods'),
  $r('app.string.title_bar_men_wear'),
  $r('app.string.title_bar_fresh'),
  $r('app.string.title_bar_furniture_kitchenware')
]

const swiperImage: Resource[] = [
  $r('app.media.ic_banner01'),
  $r('app.media.ic_banner02'),
  $r('app.media.ic_banner03'),
  $r('app.media.ic_banner04')
]

class ActivityTitleModel {
  title?: Resource
  desc?: Resource
}

const activityTitle: ActivityTitleModel[] = [
  {
    title: $r('app.string.activity_title_all'),
    desc: $r('app.string.activity_title_all_desc')
  },
  {
    title: $r('app.string.activity_title_selected'),
    desc: $r('app.string.activity_title_selected_desc')
  },
  {
    title: $r('app.string.activity_title_new_products'),
    desc: $r('app.string.activity_title_new_products_desc')
  },
  {
    title: $r('app.string.activity_title_affordable'),
    desc: $r('app.string.activity_title_affordable_desc')
  }
]


class Advertise {
  id: number;
  name: string;
  type: string;
  // 图片地址
  pic: string;
  status: number;
  clickCount: number;
  orderCount: number;
  url: string;
  note: string;
  sort: number
}

export class HotProduct {
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
  serviceIds: string;
  keywords: string;
  note: string;
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

export class HomeContent {
  // 轮播广告
  advertiseList: Advertise[];
  // 推荐品牌
  brandList: any[];
  // 当前秒杀场次
  homeFlashPromotion: any;
  // 新品推荐
  newProductList: any[];
  // 人气推荐
  hotProductList: HotProduct[];
  // 推荐专题
  subjectList: any[];
}

export class PageOption {
  pageNum?: number = 1;
  pageSize?: number = 4;

  constructor(pageNum: number = 1, pageSize: number = 4) {
    this.pageNum = pageNum;
    this.pageSize = pageSize
  }
}


export {
  searchSwiper,
  classifyTitle,
  swiperImage,
  activityTitle,
  ActivityTitleModel,
  Advertise
}

/**
 * service api
 */

