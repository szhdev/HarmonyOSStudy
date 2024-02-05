import router from '@ohos.router';
import { CommonConstants } from '../common/constants/CommonConstants';
class PageBean{
  url:string
  name:string

  constructor(url:string,name:string) {
    this.url =url
    this.name = name
  }
}

/**
 * The MainPage that is routed as the SplashScreenPage.
 */
@Entry
@Component
struct MainPage {
  private page : PageBean[] = [
    new PageBean('pages/ImagePage','图片查看案例'),
    new PageBean('pages/ListPage','商品列表案例'),
    new PageBean('pages/StatePage','视图更新案例'),
    new PageBean('pages/TaskPage','任务列表案例'),
    new PageBean('pages/PropPage','单双向同步更新案例'),
    new PageBean('pages/AnimationPage','动画案例'),
    new PageBean('pages/YGAnimationPage','遥感动画案例')
  ]
  build() {
    Row() {
      Column() {
        Text($r('app.string.main_page_content'))
          .fontSize($r('app.float.hello_world_font_size'))
          .fontWeight(FontWeight.Bold)
        List({space:10}){
          ForEach(
            this.page,
            (item:PageBean,index)=>{
              ListItem(){
                this.itemPage(item,index+1)
              }

            }
          )
        }
        .width('100%')
        .alignListItem(ListItemAlign.Center)
        .padding({top:15,bottom:15})
        .layoutWeight(1)

      }
      .width(CommonConstants.MAIN_PAGE_COLUMN_WIDTH)
    }
    .height(CommonConstants.MAIN_PAGE_ROW_WIDTH)
  }

  @Builder itemPage(item:PageBean,index:number){
    Row(){
      Text(index+'.')
        .fontColor(Color.White)
      Blank()
      Text(item.name)
        .fontColor(Color.White)
    }
    .width('80%')
    .backgroundColor("#36A")
    .padding(15)
    .borderRadius(50)
    .shadow({radius:15,color:'#36D',offsetX:10,offsetY:10})
    .margin({left:15,right:15})
    .onClick(()=>{
      router.pushUrl(
        {
          url:item.url,
          params:{id:index,name:item.name}
        },
        router.RouterMode.Single,
        err=>{
          if(err){
            console.log(`路由错误 ：errcode:${err.code} errmsg${err.message}`)
          }
        }
      )
    })
  }
}