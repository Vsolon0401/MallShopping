
import { Request } from '../utils/Request'

type OrderParam = {
  memberReceiveAddressId: number;
  couponId?: number;
  useIntegration?: number;
  payType: number;
  cartIds: number[];
}

export class OrderService {

  async generateConfirmOrder(cartIds: number[]) {
    return Request.post('/order/generateConfirmOrder', cartIds)
  }

  async generateOrder(params: OrderParam) {
    return Request.post('/order/generateOrder', params)
  }

  async fetchOrderList() {
    return Request.get(`/order/list`)
  }

  async payOrderSuccess() {
    return Request.post('/order/paySuccess', {

    }, {
      header: {
        'content-type': 'application/x-www-form-urlencoded;charset=utf-8'
      }
    })
  }

  async fetchOrderDetail(orderId: number) {
    return Request.get(`/order/detail/${orderId}`)
  }

  async cancelUserOrder() {
    return Request.post('/order/cancelUserOrder', {

    }, {
      header: {
        'content-type': 'application/x-www-form-urlencoded;charset=utf-8'
      }
    })
  }

  async confirmReceiveOrder() {
    return Request.post('/order/confirmReceiveOrder', {

    }, {
      header: {
        'content-type': 'application/x-www-form-urlencoded;charset=utf-8'
      }
    })
  }

  async delUserOrder() {
    return Request.post('/order/deleteOrder', {

    }, {
      header: {
        'content-type': 'application/x-www-form-urlencoded;charset=utf-8'
      }
    })
  }

  async fetchAliapyStatus() {
    return Request.get('/alipay/query')
  }
}

export const orderService = new OrderService()