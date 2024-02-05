import router from '@ohos.router'
import App from '@system.app'
import curves from '@ohos.curves'
/**
 * 遥感 跟随手指控制小猪移动（屏幕范围未做限制处理）
 */
@Entry
@Component
struct YGAnimationPage {
  //小猪坐标
  @State fishX:number = 200
  @State fishY:number = 120
  //小猪角度
  @State angle:number = 0
  //小猪图片
  @State src:Resource = $r('app.media.icon_right')
  //是否开始游戏
  @State isBegin: boolean = false

  //遥控中心区域坐标
  private centerX :number = 120
  private centerY :number = 120

  //大、小圆半径
  private maxRadius:number = 100
  private radius:number = 20

  //遥感小圆球初始位置
  @State positionX :number = this.centerX
  @State positionY :number = this.centerY

  //角度正玄和余弦
  sin: number = 0
  cos: number = 0

  //小猪移动速度
  speed : number = 0
  //任务id
  taskId : number = -1

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

        //遥感
        Row(){
          Circle({width:this.maxRadius*2,height:this.maxRadius*2})
            .fill('#20101010')
            .position({x:this.centerX-this.maxRadius, y:this.centerY-this.maxRadius})

          Circle({width:this.radius*2,height:this.radius*2})
            .fill('#403A3A3A')
            .position({x:this.positionX-this.radius, y:this.positionY-this.radius})
        }
        .width(240)
        .height(240)
        .justifyContent(FlexAlign.Center)
        .position({x:0,y:120})
        .onTouch(this.handleTouchEvent.bind(this))

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
  //处理手指移动事件
  handleTouchEvent(event: TouchEvent){
    switch (event.type) {
      case TouchType.Down:
      //开始定时任务 小猪持续移动
       this.taskId =  setInterval(()=>{
          //修改小猪的坐标
          this.fishX += this.speed * this.cos
          this.fishY += this.speed * this.sin
        },40)
        break;
      case TouchType.Up:
        //还原小猪的速度
        this.speed = 0

        animateTo(
          {curve:curves.springMotion()},
          ()=>{
            //还原遥感小球的坐标
            this.positionX = this.centerX
            this.positionY = this.centerY
            //还原小猪的角度
            this.angle = 0
          }
        )
        //取消定时任务
        clearInterval(this.taskId)
        break;
      case TouchType.Move:
      //1.获取手指位置坐标
        let x= event.touches[0].x
        let y = event.touches[0].y
      //2.计算手指与中心点的坐标差值
        let vx = x- this.centerX
        let vy = y- this.centerY
      //3.计算手指与中心点连线和x轴正半轴的夹角,单位是弧度
        let angle =  Math.atan2(vy,vx)
      //4.计算手指与中线点的距离
        let distance = this.getDistance(vx,vy)
      //5.计算遥感小球的坐标
        this.sin = Math.sin(angle)
        this.cos = Math.cos(angle)
        animateTo(
          //持续跟手动画
          {curve:curves.responsiveSpringMotion()},
          ()=>{
            this.positionX = this.centerX +distance * this.cos
            this.positionY = this.centerY +distance * this.sin

            //6.修改小猪朝向和跟随手指的角度
            if(Math.abs(angle * 2) < Math.PI){
              this.src = $r('app.media.icon_right')
            }else {
              this.src = $r('app.media.icon_left')
              //解决朝左方向的时候 小猪翻转
              angle = angle < 0? angle +Math.PI: angle -Math.PI
            }

            //弧度转角度 度 = 弧度 * 180 / π    弧度= 度 * π / 180
            this.angle = angle*180 /Math.PI
            this.speed = 5


          })
        break;

      default:
        break;
    }

  }
  getDistance(x:number,y:number){
    let d =Math.sqrt(x*x + y*y)
    return Math.min(d,this.maxRadius)
  }
}