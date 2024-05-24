import { Request } from '../utils/Request'
import { UserAddress } from '../viewmodel/AddressModel'

export class AddressService {
  async fetchAddressDetail(id: number) {
    return Request.get(`/member/address/${id}`)
  }

  async addAddress(userAddress: UserAddress) {
    return Request.post('/member/address/add', userAddress)
  }

  async delAddress(id: number) {
    return Request.post(`/member/address/delete/${id}`)
  }

  async fetchAddressList() {
    return Request.get('/member/address/list')
  }

  async updateAddress(userAddress: UserAddress) {
    return Request.post(`/member/address/update/${userAddress.id}`, userAddress)
  }
}

export const addressService = new AddressService();