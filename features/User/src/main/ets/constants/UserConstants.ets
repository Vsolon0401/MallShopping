type RouterWithTagType = {
  router: string
  tag: string | Resource
  icon?: Resource
}

export class UserConstants {
  /**
   * 用户功能列表常量
   */
  static readonly MANAGER_LIST_ROUTER: RouterWithTagType[] = [
    {
      router: '/',
      tag: '地址管理',
    },
    {
      router: '/',
      tag: '我的足迹'
    },
    {
      router: '/',
      tag: '我的关注',
    },
    {
      router: '/',
      tag: '我的收藏',
    },
    {
      router: '/',
      tag: '我的评价'
    },
    {
      router: '/',
      tag: '设置'
    }

  ]
  /**
   * 用户订单管理常量
   */
  static readonly ORDER_LIST_ROUTER: RouterWithTagType[] = [
    {
      router: '/',
      tag: '全部订单'
    },
    {
      router: '/',
      tag: '待付款'
    },
    {
      router: '/',
      tag: '待收货'
    },
    {
      router: '/',
      tag: '退款/售后'
    }
  ]

  /**
   * Live list item image aspect ration of sm.
   */
  static readonly ASPECT_RATIO_SM: number = 1.09;

  /**
   * Live list item image aspect ration of md.
   */
  static readonly ASPECT_RATIO_MD: number = 1.51;

  /**
   * Live list item image aspect ration of lg.
   */
  static readonly ASPECT_RATIO_LG: number = 1.63;
}