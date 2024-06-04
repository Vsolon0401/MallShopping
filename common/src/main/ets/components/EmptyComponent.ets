
import { StyleConstants } from '../constants/StyleConstants';

@Component
export struct EmptyComponent {
  private emptyText?: string | undefined;
  private outerHeight?: number | string = StyleConstants.FULL_HEIGHT;

  build() {
    Flex({
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
      direction: FlexDirection.Column
    }) {
      Image($r('app.media.ic_empty'))
        .width($r('app.float.empty_image_size'))
        .height($r('app.float.empty_image_size'))
      Text(this.emptyText || $r('app.string.empty_text'))
        .fontSize($r('app.float.micro_font_size'))
        .margin({ top: $r('app.float.vp_ten') })
    }
    .width(StyleConstants.FULL_WIDTH)
    .height(this.outerHeight !== undefined ? this.outerHeight : StyleConstants.FULL_HEIGHT)
  }
}
