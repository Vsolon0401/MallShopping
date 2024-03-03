export class ButtonInfoModel {
  index: number = 0;
  img: Resource = $r('app.media.ic_home_normal');
  selectImg: Resource = $r('app.media.ic_home_focus');
  title: Resource = $r('app.string.home');
}

const buttonInfo: ButtonInfoModel[] = [
  {
    index: 0,
    img: $r('app.media.ic_home_normal'),
    selectImg: $r('app.media.ic_home_focus'),
    title: $r('app.string.home')
  },
  {
    index: 1,
    img: $r('app.media.ic_product_normal'),
    selectImg: $r('app.media.ic_product_focus'),
    title: $r('app.string.new_product')
  },
  {
    index: 2,
    img: $r('app.media.ic_cart_normal'),
    selectImg: $r('app.media.ic_cart_focus'),
    title: $r('app.string.cart')
  },
  {
    index: 3,
    img: $r('app.media.ic_personal_normal'),
    selectImg: $r('app.media.ic_personal_focus'),
    title: $r('app.string.mine')
  }
]

export { buttonInfo }