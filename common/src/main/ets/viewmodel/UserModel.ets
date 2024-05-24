export class UserInfo {
  id?: number;
  // 会员等级
  memberLevelId?: number;
  username?: string;
  password?: string;s
  // 注册时使用telephone, 信息使用phone
  nickname?: string;
  status?: number = 1;
  phone?: string;
  authCode?: string;
  icon?: string;
  // 注册时间
  createTime?: Date;
  // 性别：0->未知；1->男；2->女
  gender?: number = 1;
  birthday?: string;
  city?: string;
  job?: string;
  // 个性签名
  personalizedSignature?: string;
  // 用户来源
  sourceType?: number;
  // 积分
  integration?: number;
  // 成长值
  growth?: number;
  // 剩余抽奖次数
  luckeyCount?: number;
  // 历史积分数量
  historyIntegration?: number;

}

export enum UserFunctionType {
  Collection = "collection",
  Address = "address",
  History = "history",
  Evaluate = "evaluate"
}