
import { Request } from '../utils/Request'
class CollectionService {

  fetchProductCollectionDetail(productId: number) {
    return Request.get(`/member/productCollection/detail?productId=${productId}`)
  }
}


export const collectionService = new CollectionService()