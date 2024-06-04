import { Request } from '../utils/Request'

/**
 * MemberReadHistory
 */
export interface HistoryParams {
  id?: string;
  memberIcon?: string;
  memberId?: number;
  memberNickname?: string;
  productId?: number;
  productName?: string;
  productPic?: string;
  productPrice?: string;
  productSubTitle?: string;
  [property: string]: any;
}

class HistoryService {
  createReadHistory(params: HistoryParams) {
    Request.post('/member/readHistory/create', params)
  }

  fetchHistory(params) {
    Request.get('/member/readHistory/list', {
      params: params
    })
  }
}

export const historyService = new HistoryService()