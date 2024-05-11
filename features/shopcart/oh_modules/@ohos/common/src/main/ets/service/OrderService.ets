
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

  async fetchOrderList(status: number = -1, pageNum: number = 1, pageSize: number = 10) {
    return Request.get(`/order/list?pageNum=${pageNum}&pageSize=${pageSize}&status=${status}`)
  }

  async payOrderSuccess(orderId: number, payType: number) {
    return Request.post(`/order/paySuccess?orderId=${orderId}&payType=${payType}`, {

    }, {
      header: {
        'content-type': 'application/x-www-form-urlencoded;charset=utf-8'
      }
    })
  }

  async fetchOrderDetail(orderId: number) {
    return Request.get(`/order/detail/${orderId.toString()}`)
  }

  async cancelUserOrder(orderId: number) {
    return Request.post(`/order/cancelUserOrder?orderId=${orderId}`, {

    }, {
      header: {
        'content-type': 'application/x-www-form-urlencoded;charset=utf-8'
      }
    })
  }

  async confirmReceiveOrder(orderId: number) {
    return Request.post(`/order/confirmReceiveOrder?orderId=${orderId}`, {

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