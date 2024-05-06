import { Category } from './CategoryModel';


export class FlashProduct extends Category {
  flashPromotionPrice: string;
  flashPromotionCount: number;
  flashPromotionLimit: number;
}

export class FlashPromotion {
  startTime: string = '';
  endTime: string = '';
  nextStartTime: string = '';
  nextEndTime: string = '';
  productList: FlashProduct[] = [];
}