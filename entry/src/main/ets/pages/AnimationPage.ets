import router from '@ohos.router'
import App from '@system.app'
@Entry
@Component
struct AnimationPage {
  @State message: string = 'Hello World'
  //小猪坐标
  @State fishX:number = 200
  @State fishY:number = 180
  //小猪角度
  @State angle:number = 0
  //小猪图片
  @State src:Resource = $r('app.media.icon_right')
  //是否开始游戏
  @State isBegin: boolean = false

  @Styles style(){
    .padding(10)
    .backgroundColor('#20101010')
}
  build() {
    Row() {
      Stack(){
        //返回按钮
        Button('返回')
          .position({x:10,y:10})
          .backgroundColor('#20101010')
          .onClick(()=>{
            //返回上一页
            router.back()
          })
        //操作按钮
        Row() {
          Button("←").style()
            .onClick(()=>{
              //第一种属性动画操作 小猪 .animation({duration:500})
              // this.fishX-=20
              // this.src=$r('app.media.icon_left')

              //第二种显示动画 更加灵活单独配置
              animateTo(
                {duration:500 },
                ()=>{
                  this.fishX-=20
                  this.src=$r('app.media.icon_left')
                })
            })

          Column({space:50}){
            Button("↑").style()
              .onClick(()=>{
                this.fishY-=20
              })
            Button("↓").style()
              .onClick(()=>{
                this.fishY+=20
              })
          }
          Button("→").style()
            .onClick(()=>{
              animateTo(
                {duration:500 },
                ()=>{
                  this.fishX+=20
                  this.src=$r('app.media.icon_right')
                })

            })
        }
        .width(240)
        .height(240)
        .justifyContent(FlexAlign.Center)
        .position({x:0,y:120})


        if(!this.isBegin){
          Row(){
            //开始按钮
            Button('开始游戏')
              .onClick(()=>{
                //转场动画生效第二步
                animateTo(
                  { duration:2000},
                  ()=>{
                    //点击后显示小猪动画
                    this.isBegin = true
                  })
              })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#20101010')
          .justifyContent(FlexAlign.Center)

        }else {
          //展示小猪图片
          Image(this.src)
          .position({x:this.fishX-20,y:this.fishY-20})
          .rotate({angle:this.angle,centerX:'50%',centerY:'50%'})
            //转场动画
            //生效第一步 centerX:'50%',centerY:'50%' 默认值：50%
            .transition(
              {
                type:TransitionType.Insert,
                opacity:0,//不透明度 0-1
                translate:{x:-250},
                rotate:{angle:360,centerX:'50%',centerY:'50%'},
                scale:{x:0,y:0}
              }
            )
          .width(40)
          .height(40)
            //第一种属性动画 要放在所有属性最后才有效果
          // .animation({duration:500})

        }

      }
      .width('100%')
      .height('100%')
    }
    .backgroundImage($r('app.media.ic_splash_page_background'),ImageRepeat.XY)
    .width('100%')
    .height('100%')
  }
}