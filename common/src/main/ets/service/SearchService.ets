
import { Request } from '../utils/Request';
import { EsProduct } from '../viewmodel/CategoryModel';
export class SearchService {

  async searchSynthesis(params: SearchParams) {
    return Request.searchGet('/esProduct/search', {
      params: params
    })
  }
  async fetchRecommendById(productId: number): Promise<EsProduct[]> {
    return Request.searchGet(`/esProduct/recommend/${productId}`).then(res => {
      return res.data.list
    })
  }
}


export const searchService = new SearchService();

export type SearchParams = {
  /**
   * brandId
   */
  brandId?: number;
  /**
   * keyword
   */
  keyword?: string;
  /**
   * pageNum
   */
  pageNum?: number;
  /**
   * pageSize
   */
  pageSize?: number;
  /**
   * productCategoryId
   */
  productCategoryId?: number;
  /**
   * 排序字段:0->按相关度；1->按新品；2->按销量；3->价格从低到高；4->价格从高到低
   */
  sort?: number;
  [property: string]: any;
}