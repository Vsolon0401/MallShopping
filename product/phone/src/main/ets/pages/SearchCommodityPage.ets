
import { EsProduct, Logger, searchService, StyleConstants } from '@ohos/common'
import { SearchResponse } from '@ohos/common/src/main/ets/viewmodel/CategoryModel';

@Entry
@Component
export struct SearchCommodityPage {

  @State keyword: string = '';
  @State productList: EsProduct[] = []

  searchController = new SearchController();
  scrollController = new Scroller()

  async handleSearch(keyword: string) {
    searchService.searchSynthesis({ keyword }).then((res: SearchResponse) => {
      this.productList = res.data.list
    })
  }

  // 搜索框
  @Builder
  SearchBar() {
    Column() {
      Row() {
        Search({ value: this.keyword, placeholder: '', controller: this.searchController })
          .searchButton('搜索')
          .width(StyleConstants.FULL_WIDTH)
          .height($r('app.float.search_swiper_height'))
          .backgroundColor('#F5F5F5')
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onChange((value: string) => {
            this.keyword = value
          })
          .onSubmit((value: string) => this.handleSearch(value))
      }
      .height($r('app.float.search_swiper_height'))
      .width(StyleConstants.FULL_WIDTH)
      .borderRadius($r('app.float.vp_twenty'))
      .backgroundColor(Color.White)
    }
    .width(StyleConstants.FULL_WIDTH)
    .padding({ top: $r('app.float.vp_twenty'), bottom: $r('app.float.vp_twelve') })
  }



  //todo 筛选栏
  @Builder
  FilterBar() {
    Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center}) {



    }
  }

  //todo 商品列表
  @Builder
  ProductList() {

  }


  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.ic_app_background'))
        .width(StyleConstants.FULL_WIDTH)
        .height($r('app.float.search_background_height'))
        .objectFit(ImageFit.Auto)
      Flex({ direction: FlexDirection.Column }) {
        this.SearchBar()
      }
      .padding({ left: $r('app.float.vp_twelve'), right: $r('app.float.vp_twelve') })
    }
  }
}