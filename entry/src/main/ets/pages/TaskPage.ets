import { Header } from './Header'
class ItemTask{
  static id:number = 1
  name : string = `任务${ItemTask.id++}`
  finished:boolean = false
}

@Styles
function card(){
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({color:'#36A',offsetX:5,offsetY:5,radius:8})
}
//任务完成样式
@Extend(Text)function finishedTask(){
  .decoration({type:TextDecorationType.LineThrough,color:'#36B'})
  .fontColor('#B1B2B1')
}

@Entry
@Component
struct TaskPage {
  @State finishTask:number = 0
  @State totalTask:number = 0
  @State tasks:ItemTask[] = []

  handleTaskChange(){
    this.totalTask = this.tasks.length
    this.finishTask = this.tasks.filter(item=>item.finished).length
  }
  build() {
    Column({space:10}){
      Header({title:'任务列表案例'})
      //1.任务进度卡片
      TaskProgress({finishTask:this.finishTask,totalTask:this.totalTask})
      Button('新增任务')
        .width(150)
        .onClick(()=>{
          this.tasks.push(new ItemTask())
          this.handleTaskChange()
        })
      List({space:10}){
        ForEach(
          this.tasks,
          (item:ItemTask,index) =>{
            ListItem(){
              Row(){
                Text(item.name)
                Checkbox()
                  .select(item.finished)
                  .onChange(check =>{
                    item.finished =check
                    this.handleTaskChange()
                  })
              }
              .card()
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .swipeAction({end:this.DeleteButton(index)})
          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .alignListItem(ListItemAlign.Center)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F2F3')


  }

  @Builder DeleteButton(index:number){
    Button(){
      Image($r('app.media.app_icon'))
        .width(20)
    }
    .width(40)
    .height(40)
    .type(ButtonType.Circle)
    .margin(5)
    .onClick(()=>{
      console.info(`我被删除了${index}`)
      this.tasks.splice(index,1)
      this.handleTaskChange()
    })


  }
}


@Component
struct TaskProgress {

  @Prop finishTask:number
  @Prop totalTask:number

  build() {
    Row(){
      Text('任务进度：')
        .borderStyle(BorderStyle.Solid)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Stack(){
        Progress({
          type:ProgressType.Ring,
          value:this.finishTask,
          total:this.totalTask
        }).width(100)
        Row(){
          Text(this.finishTask.toString())
            .fontSize(24)
            .fontColor('#36D')
          Text(' / '+this.totalTask.toString())
            .fontSize(24)
        }
      }
    }
    .card()
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({top:20,bottom:20})
  }
}
