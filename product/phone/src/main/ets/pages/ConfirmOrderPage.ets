import router from '@ohos.router';
import { ConfirmOrder } from '@ohos/orderdetail';
import { Order, Logger } from '@ohos/common';
import { PageConstants } from '../constants/PageConstants';

@Entry
@Component
struct ConfirmPageOrder {
  @Provide('amount') amount: number = 0;
  @Provide('orderList') orderList: Order[] = [];

  onPageShow() {
    let params = router.getParams() as Record<string, Order[]>;
    const orderList = params.orderList
    for (let index = 0; index < orderList.length; index++) {
      let orderData: Order = {
        orderId: orderList[index].orderId,
        commodityId: orderList[index].commodityId,
        price: orderList[index].price,
        count: orderList[index].count,
        specifications: orderList[index].specifications,
        image: orderList[index].image,
        description: orderList[index].description,
        title: orderList[index].title
      };
      this.orderList.push(orderData);
    }
    Logger.info('onPageShow orderList length: ' + this.orderList.length);
    this.amount = this.orderList.reduce((s: number, item: Order) => s + item.price * item.count, 0);
  }

  build() {
    Column() {
      ConfirmOrder()
    }
  }
}