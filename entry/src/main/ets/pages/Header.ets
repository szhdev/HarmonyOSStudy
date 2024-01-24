//自定义组件
import router from '@ohos.router'
@Component
export  struct Header {
  private  title: ResourceStr
  @State params: any =router.getParams()
  build() {
    Row() {
      Image($r('app.media.icon_back'))
        .width(30)
        .height(30)
        .onClick(()=>{

          router.showAlertBeforeBackPage({
            message:'确认返回？'
          })
          router.back()
        })
      if(this.params && this.title){
        Text(this.params.id+'.'+this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }

    }
    .padding(15)
    .width('100%')
  }
}