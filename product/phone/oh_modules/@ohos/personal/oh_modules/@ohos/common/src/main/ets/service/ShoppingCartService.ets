import { Logger } from '../utils/Logger'
import { Request } from '../utils/Request'
import { CartItem } from '../viewmodel/CartModel'

export class ShoppingCartService {

  /**
   * 获取当前用户购物车列表
   * @returns
   */
  async fetchCartList() {
    return Request.get('/cart/list').then(res => {
      const data: CartItem[] = res.data
      // 格式化商品属性
      data.forEach(product => {
        const specificationList: any[] = JSON.parse(product.productAttr)
        let specification = specificationList.reduce((pre, cur) => {
          return pre + cur.value + ' '
        }, '')
        product.productAttr = specification
      })
      return data
    })
  }

  /**
   * 获取购物车指定商品的规格，用于重选规格
   * @param productId 商品id
   * @returns
   */
  async fetchCartItemSpecification(productId: number) {
    return Request.get(`/cart/getProduct/${productId}`)
  }

  /**
   * 添加商品到购物车
   * @param cartItem
   * @returns
   */
  async addCartItem(cartItem: CartItem) {
    return Request.post('/cart/add', cartItem)
  }

  /**
   *  清除购物车
   * @returns
   */
  async clearCartList() {
    return Request.post('/cart/clear')
  }

  /**
   * 购物车删除指定商品
   * @param idList
   * @returns
   */
  async delCartItem(id: number) {
    return Request.post('/cart/delete', {ids: id})
  }

  /**
   * 更新购物车中指定商品规格
   * @param cartItem
   * @returns
   */
  async updateCartItem(cartItem: CartItem) {
    return Request.post('/cart/update/attr', cartItem)
  }

  /**
   * 更新购物车商品数量
   * @param id
   * @param quantity
   * @returns
   */
  async updateItemQuantity(id: number, quantity: number) {
    return Request.get(`/cart/update/quantity`, {
      params: { id: id, quantity: quantity }
    })
  }
}

export const shoppingCartService = new ShoppingCartService()