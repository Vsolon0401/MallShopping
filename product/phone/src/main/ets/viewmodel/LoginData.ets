export class UserInfo {
  id: number = NaN;
  // 会员等级
  memberLevelId: number = NaN;
  username: string = '';
  password: string = '';
  // 注册时使用telephone, 信息使用phone
  phone: string = '';
  authCode: string = '';
  icon: string = '';
  // 注册时间
  createTime: Date = new Date();
  // 性别：0->未知；1->男；2->女
  gender: number = NaN;
  birthday: Date = new Date();
  city: string = '';
  job: string = '';
  // 个性签名
  personalizedSignature: string = '';
  // 用户来源
  sourceType: number = NaN;
  // 积分
  integration: number = NaN;
  // 成长值
  growth: number = NaN;
  // 剩余抽奖次数
  luckeyCount: number = NaN;
  // 历史积分数量
  historyIntegration: number = NaN;

}