import { Request } from '../utils/Request'

export class AddressService {
  async fetchAddressDetail(id: number) {
    return Request.get(`/member/address/${id}`)
  }

  async addAddress() {
    return Request.post('/member/address/add')
  }

  async delAddress(id: number) {
    return Request.post(`/member/address/delete/${id}`)
  }

  async fetchAddressList() {
    return Request.get('/member/address/list')
  }

  async updateAddress(id: number) {
    return Request.post(`/member/address/update/${id}`)
  }
}

export const addressService = new AddressService();