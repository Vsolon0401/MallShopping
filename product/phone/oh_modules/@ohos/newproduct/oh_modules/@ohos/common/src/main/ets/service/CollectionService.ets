
import { Request } from '../utils/Request'
import { Collection } from '../viewmodel/CollectionModel'
class CollectionService {

  async fetchCollectionDetail(productId: number) {
    return Request.get(`/member/productCollection/detail?productId=${productId}`)
  }

  async fetchCollectionList(pageNum: number, pageSize: number) {
    return Request.get(`/member/productCollection/list?pageNum=${pageNum}&pageSize=${pageSize}`)
  }

  async addCollection(collection: Collection) {
    return Request.post('/member/productCollection/add', { ...collection })
  }

  async clearCollection() {
    return Request.post('/member/productCollection/clear')
  }

  async delCollection(productId: number) {
    return Request.post(`/member/productCollection/delete?productId=${productId}`)
  }

}


export const collectionService = new CollectionService()