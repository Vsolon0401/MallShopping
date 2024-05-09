import router from '@ohos.router';
import { ConfirmOrder } from '@ohos/orderdetail';
import { Order, Logger, orderService } from '@ohos/common';
import { PageConstants } from '../constants/PageConstants';
import { ConfirmOrderType } from '@ohos/common/src/main/ets/viewmodel/OrderModel';
import { UserAddress } from '@ohos/common/src/main/ets/viewmodel/AddressModel';

@Entry
@Component
struct ConfirmPageOrder {
  @State isAddressSelected: boolean = false;
  @State cartIdList: number[] = []
  @Provide('confirmOrder') confirmOrder: ConfirmOrderType = new ConfirmOrderType()
  @Provide('selectedAddress') selectedAddress: UserAddress = new UserAddress()


  onPageShow() {
    let params = router.getParams() as Record<string, number[]>;
    orderService.generateConfirmOrder(params.cartIdList).then(res => {
      this.confirmOrder = res.data
      this.cartIdList = params.cartIdList
      // 初始化默认地址
      this.selectedAddress = res.data.memberReceiveAddressList
        .find(address => address.defaultStatus === 1)
    })
    // this.orderList.push(orderData);
    // this.amount = this.orderList.reduce((s: number, item: Order) => s + item.price * item.count, 0);
  }

  onSelectAddress() {
    this.isAddressSelected = !this.isAddressSelected
  }

  build() {
    Column() {
      if (!this.isAddressSelected) {
        ConfirmOrder({
          cartIdList: $cartIdList,
          onSelectAddress: this.onSelectAddress
        })
      } else {

      }

    }
  }
}