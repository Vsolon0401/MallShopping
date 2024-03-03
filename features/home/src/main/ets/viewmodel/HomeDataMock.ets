const searchSwiper: Resource[] = [
$r('app.string.swiper_model_mate'),
$r('app.string.swiper_model_chang'),
$r('app.string.swiper_model_mate_book'),
$r('app.string.swiper_model_Nova')
]

const classifyTitle: Resource[] = [
$r('app.string.title_bar_homepage'),
$r('app.string.title_bar_phone'),
$r('app.string.title_bar_computer'),
$r('app.string.title_bar_foods'),
$r('app.string.title_bar_men_wear'),
$r('app.string.title_bar_fresh'),
$r('app.string.title_bar_furniture_kitchenware')
]

const swiperImage: Resource[] = [
$r('app.media.ic_banner01'),
$r('app.media.ic_banner02'),
$r('app.media.ic_banner03'),
$r('app.media.ic_banner04')
]

class ActivityTitleModel {
  title?: Resource
  desc?: Resource
}

const activityTitle: ActivityTitleModel[] = [
  {
    title: $r('app.string.activity_title_all'),
    desc: $r('app.string.activity_title_all_desc')
  },
  {
    title: $r('app.string.activity_title_selected'),
    desc: $r('app.string.activity_title_selected_desc')
  },
  {
    title: $r('app.string.activity_title_new_products'),
    desc: $r('app.string.activity_title_new_products_desc')
  },
  {
    title: $r('app.string.activity_title_affordable'),
    desc: $r('app.string.activity_title_affordable_desc')
  }
]

export { searchSwiper, classifyTitle, swiperImage, activityTitle, ActivityTitleModel }