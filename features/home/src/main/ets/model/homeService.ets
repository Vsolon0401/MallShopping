
import { Request } from '@ohos/common'

export class HomeService {
  // 首页内容信息展示
  async fetchContent() {
    return Request.get('/home/content')
  }
  // 分页获取推荐商品
  async fetchRecommendProductList(params) {
    return Request.get('/home/recommendProductList', {
      params: params
    })
  }
  // 获取首页商品分类
  async fetchProductCateList(parentId) {
    return Request.get('/home/productCateList/'+parentId)
  }
  // 根据分类获取专题
  async fetchNewProductList(params) {
    return Request.get('/home/newProductList', {
      params: params
    })
  }
  // 分页获取人气推荐商品
  async fetchHotProductList(params) {
    return Request.get('/home/hotProductList', {
      params:params
    })
  }

  // 按id取分类
  async fetchClassify(parentId: number) {
    return Request.get(`/home/productCateList/${parentId}`)
  }

  // 分类信息tree
  async fetchClassifyTree() {
    return Request.get('/product/categoryTreeList')
  }
}

export const homeService = new HomeService()