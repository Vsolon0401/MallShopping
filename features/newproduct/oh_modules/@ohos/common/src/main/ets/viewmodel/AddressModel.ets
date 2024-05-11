
export class UserAddress {
  id?: number;
  memberId?: number;
  name: string = '';
  phoneNumber: string;
  defaultStatus?: number;
  postCode: string;
  province: string;
  city: string;
  region: string;
  detailAddress: string;
}