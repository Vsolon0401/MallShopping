
import { CommonDataSource, EsProduct, Logger, ProductWaterFlow, RecommendScroll, searchService, StyleConstants } from '@ohos/common'
import { ProductSort, SearchResponse } from '@ohos/common/src/main/ets/viewmodel/CategoryModel';
import router from '@ohos.router';
import { PageConstants } from '../constants/PageConstants';
import { PageOption } from '@ohos/home/src/main/ets/viewmodel/HomeData';

@Entry
@Component
struct SearchCommodityPage {
  // 搜索值
  @State keyword: string = '';
  // 分页查询状态
  @State pageOption: PageOption = new PageOption(0, 20);
  // 商品列表
  @State productList: CommonDataSource<EsProduct> = new CommonDataSource([])
  // 筛选值
  @State sort:ProductSort = ProductSort.RELEVANCE
  // f -> down; t -> up
  @State priceSort: boolean = false

  searchController = new SearchController();
  scrollController = new Scroller()

  onPageShow() {
    const params = router.getParams() as Record<string, string>
    const searchKey = params?.searchKey
    if (searchKey !== undefined && searchKey !== '') {
      this.keyword = searchKey
      this.handleSearch(searchKey)
    }
  }

  routerDetailPage<T>(productId: T) {
    router.pushUrl({
      url: PageConstants.COMMODITY_DETAIL_PAGE_URL,
      params: { data: productId }
    }).catch((err: Error) => {
      Logger.error(JSON.stringify(err));
    });
  }

  async handleSearch(keyword: string, sort: ProductSort = ProductSort.RELEVANCE) {
    const { pageSize, pageNum } = this.pageOption
    searchService.searchSynthesis({ keyword, sort, pageSize, pageNum })
      .then((res: SearchResponse) => {
      this.productList.reloadData(res.data.list)
    })
  }

  async handleSort(sortType: ProductSort, priceType?: boolean) {
    if (sortType === this.sort) return;
    this.scrollController.scrollEdge(Edge.Top)
    if (priceType !== undefined) {
      this.priceSort = !this.priceSort
      const sort = priceType ? ProductSort.PRICE_UP : ProductSort.PRICE_DOWN
      this.sort = sort;
      await this.handleSearch(this.keyword, sort)
    } else {
      this.sort = sortType;
      await this.handleSearch(this.keyword, sortType)
    }
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



  @Builder
  FilterBar() {
    Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center}) {
      Text('综合')
        .fontSize($r('app.float.middle_font_size'))
        .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
        .fontColor(this.sort === ProductSort.RELEVANCE ? $r("app.color.theme_color") : Color.Gray)
        .onClick(() => this.handleSort(ProductSort.RELEVANCE))

      Divider()
        .vertical(true)
        .height($r('app.float.vp_eighteen'))
        .backgroundColor($r("app.color.five_alpha_black"))
        .margin({
          left: $r('app.float.vp_ten'),
          right: $r('app.float.vp_ten')
        })

      Text('新品')
        .fontSize($r('app.float.middle_font_size'))
        .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
        .fontColor(this.sort === ProductSort.NEW ? $r("app.color.theme_color") : Color.Gray)
        .onClick(() => this.handleSort(ProductSort.NEW))

      Divider()
        .vertical(true)
        .height($r('app.float.vp_eighteen'))
        .backgroundColor($r("app.color.five_alpha_black"))
        .margin({
          left: $r('app.float.vp_ten'),
          right: $r('app.float.vp_ten')
        })

      Text('销量')
        .fontSize($r('app.float.middle_font_size'))
        .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
        .fontColor(this.sort === ProductSort.SALES ? $r("app.color.theme_color") : Color.Gray)
        .onClick(() => this.handleSort(ProductSort.SALES))

      Divider()
        .vertical(true)
        .height($r('app.float.vp_eighteen'))
        .backgroundColor($r("app.color.five_alpha_black"))
        .margin({
          left: $r('app.float.vp_ten'),
          right: $r('app.float.vp_ten')
        })

      Row() {
        Text('价格')
          .fontSize($r('app.float.middle_font_size'))
          .fontWeight(StyleConstants.FONT_WEIGHT_FIVE)
          .fontColor(this.sort === ProductSort.PRICE_UP || this.sort === ProductSort.PRICE_DOWN
            ? $r("app.color.theme_color")
            : Color.Gray)

        Column() {
          Image(this.sort === ProductSort.PRICE_DOWN
            ? $r('app.media.ic_up_arrow_on')
            : $r('app.media.ic_up_arrow'))
            .width($r("app.float.vp_eight"))
            .objectFit(ImageFit.Contain)
          Image(this.sort === ProductSort.PRICE_UP
            ? $r('app.media.ic_down_arrow_on')
            : $r('app.media.ic_down_arrow'))
            .width($r("app.float.vp_eight"))
            .objectFit(ImageFit.Contain)
        }
        .margin({
          left: $r("app.float.vp_four")
        })
      }
      .onClick(() => this.handleSort(this.priceSort
        ? ProductSort.PRICE_UP
        : ProductSort.PRICE_DOWN, this.priceSort))
    }
    .height("65vp")
    .width(StyleConstants.FULL_WIDTH)
    .padding({
      top: $r('app.float.vp_ten'),
      bottom: $r("app.float.vp_four")
    })
    .margin({
      top: $r('app.float.vp_twenty')
    })
    .border({
      width: {
        bottom: $r('app.float.vp_one')
      },
      color: $r("app.color.five_alpha_black"),
    })
  }


  @Builder
  ProductList() {
    Column() {
      ProductWaterFlow({
        recommendList: $productList,
        onClickItem: (data: EsProduct): void => this.routerDetailPage(data.id)
      })
    }
    .width(StyleConstants.FULL_WIDTH)
    .margin({
      top: $r("app.float.vp_sixteen")
    })
  }


  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.ic_app_background'))
        .width(StyleConstants.FULL_WIDTH)
        .height($r('app.float.search_background_height'))
        .objectFit(ImageFit.Auto)
      Flex({ direction: FlexDirection.Column }) {
        this.SearchBar()
        if (this.productList.totalCount() !== 0) {
          this.FilterBar()
          this.ProductList()
        }
      }
      .padding({ left: $r('app.float.vp_twelve'), right: $r('app.float.vp_twelve') })
    }
    .backgroundColor($r('app.color.page_background'))
  }
}