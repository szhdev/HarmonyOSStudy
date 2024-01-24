import { Header } from './Header'
@Entry//----------标记当前组件是入口组件
@Component//------标记自定义组件
struct ImagePage {//--------自定义组件：可复用的UI单元
  @State message: string = 'Hello'
  @State times:number = 0
  @State imageWidth:number = 150
//构建页面
  build() {
    Column() {//列布局
      Header({title:'图片查看案例'})
      Row(){
        Image($r('app.media.icon'))
          .width(this.imageWidth)
          .interpolation(ImageInterpolation.High)
      }.width('100%').height(300).justifyContent(FlexAlign.Center)

      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Red)
      Text(`点我${this.times}次`)
        .fontSize(20)
        .fontColor(Color.Red)
      Row(){
        Text('图片宽度：')
          .fontSize(20)
        TextInput({text:this.imageWidth.toFixed(0)})
          .type(InputType.Number)
          .width(150)
          .fontSize(20)
      }.width('100%')
      .padding({left:30,right:30})
      .justifyContent(FlexAlign.SpaceBetween)
      Divider().width('90%')
      Row(){
        Button('放大')
          .fontSize(20)
          .onClick(()=>{
            if(this.imageWidth < 300){
              this.imageWidth += 10
            }
          })
        Button('缩小')
          .fontSize(20)
          .onClick(()=>{
            if(this.imageWidth >=10){
              this.imageWidth -= 10
            }
          })
      }.width('100%')
      .margin({top:30,bottom:30})
      .justifyContent(FlexAlign.SpaceEvenly)
      Slider({value:this.imageWidth,min:100,max:300,step:10})
        .width('100%')
        .blockColor('#36D')
        .showSteps(true)
        .showTips(true)
        .trackThickness(6)
        .onChange(value =>{
          this.imageWidth = value
        })


      Button('Click')
        .onClick( ()=>{
          this.message = 'ArkUI'
          this.times++
          console.info('我改变了')
        })
        .shadow({radius:20,color:'#FF00FF',offsetX:20,offsetY:20})
        .height(50)
        .width(100)
        .margin({ top:20})

    }
    .width('100%')
  }
}