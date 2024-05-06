
import { Request } from '../utils/Request'
class ProductService {

  // 获取商品详情
  async fetchProductDetail(productId: number | string) {
    return Request.get(`/product/detail/${productId}`)
  }
}

export const productService = new ProductService()