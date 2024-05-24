
import { Request } from '@ohos/common'
export class NewProductService {
  // 分页获取推荐商品
  async fetchRecommendProductList(params) {
    return Request.get('/home/recommendProductList', {
      params: params
    })
  }
}

export const newProductService = new NewProductService()