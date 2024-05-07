
export class ButtonType {
  text?: string | Resource;
  color?: string | Resource;
  onClick = (event?: ClickEvent) => {};
}

export enum FinishType {
  JOIN_SHOPPING_CART,
  BUY_NOW,
  CONFIRM,
  CANCEL
}
export class ColorChange {
  颜色: string = '';
  版本: string = '';
  网络制式: string = '';
  类型: string = '';
}

export class OrderCount {
  payment: number = 0;
  ship: number = 0;
  receipt: number = 0;
  evaluation: number = 0;
  sale: number = 0;
}

export type ProductService = {
  id: number;
  name: string;
}