import { Header } from './Header'
@Observed
class ItemTasks{
  static id:number = 1
  name : string = `任务${ItemTasks.id++}`
  finished:boolean = false
}

@Styles
function cardStyle(){
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({color:'#36A',offsetX:5,offsetY:5,radius:8})
}
//任务完成样式
@Extend(Text)function finished(){
  .decoration({type:TextDecorationType.LineThrough,color:'#36A'})
  .fontColor('#B1B2B1')
}

class StateInfo{
  finishTask:number = 0
  totalTask:number = 0
}

@Entry
@Component
struct PropPage {
  //一种写法
  @State finishTask:number = 0
  @State totalTask:number = 0
  //第二种写法 对象
  @State stateInfo:StateInfo = new StateInfo()
  //@Provide和@Consume可以跨组件提供类似于@State 和@Link的双向同步 （不需要传参，内部会实现会消耗资源）
  @Provide stateInfoConsume:StateInfo = new StateInfo()
  //@ObjectLink 和 @Observed 用于在涉及在 嵌套对象 或 数组元素为对象的场景中进行双向数据同步

  build() {
    Column({space:10}){
      Header({title:'单双向同步更新案例'})
      //1.任务进度卡片
      // ProgressHint({finishTask:this.finishTask,totalTask:this.totalTask})
      //或者
      // ProgressHint({finishTask:this.stateInfo.finishTask,totalTask:this.stateInfo.totalTask})
      //或者
      ProgressConsume()
      //2.任务列表
      // TaskList({finishTask:$finishTask, totalTask:$totalTask})
      //或者
      // TaskListObject({stateInfo:$stateInfo})
      //或者
      TaskListConsume()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F2F3')


  }


}


@Component
struct ProgressHint {
 //@Prop（单向同步，相当于拷贝了父组件数据传递给子组件） 父子组件之间需要数据同步
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
    .cardStyle()
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({top:20,bottom:20})
  }
}
@Component
struct ProgressConsume {
  @Consume stateInfoConsume:StateInfo

  build() {
    Row(){
      Text('任务进度：')
        .borderStyle(BorderStyle.Solid)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Stack(){
        Progress({
          type:ProgressType.Ring,
          value:this.stateInfoConsume.finishTask,
          total:this.stateInfoConsume.totalTask
        }).width(100)
        Row(){
          Text(this.stateInfoConsume.finishTask.toString())
            .fontSize(24)
            .fontColor('#36D')
          Text(' / '+this.stateInfoConsume.totalTask.toString())
            .fontSize(24)
        }
      }
    }
    .cardStyle()
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({top:20,bottom:20})
  }
}


@Component
struct  TaskList{
  //@Link（双向同步，相当于传递了引用） 父子组件之间需要数据同步
  @Link finishTask:number
  @Link totalTask:number

  @State tasks:ItemTasks[] = []

  handleTaskChange(){
    this.totalTask = this.tasks.length
    this.finishTask = this.tasks.filter(item=>item.finished).length
  }
  build() {
    Column(){
      Button('新增任务')
        .width(150)
        .onClick(()=>{
          this.tasks.push(new ItemTasks())
          this.handleTaskChange()
        })
      List({space:10}){
        ForEach(
          this.tasks,
          (item:ItemTasks,index) =>{
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
              .cardStyle()
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
struct  TaskListObject{
  //@Link 对象（双向同步，相当于传递了引用） 父子组件之间需要数据同步
  @Link stateInfo:StateInfo
  @State tasks:ItemTasks[] = []

  handleTaskChange(){
    this.stateInfo.totalTask = this.tasks.length
    this.stateInfo.finishTask = this.tasks.filter(item=>item.finished).length
  }
  build() {
    Column(){
      Button('新增任务')
        .width(150)
        .onClick(()=>{
          this.tasks.push(new ItemTasks())
          this.handleTaskChange()
        })
      List({space:10}){
        ForEach(
          this.tasks,
          (item:ItemTasks,index) =>{
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
              .cardStyle()
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
struct  TaskListConsume{
  //@Link 对象（双向同步，相当于传递了引用） 父子组件之间需要数据同步
  @Consume stateInfoConsume:StateInfo
  @State tasks:ItemTasks[] = []

  handleTaskChange(){
    this.stateInfoConsume.totalTask = this.tasks.length
    this.stateInfoConsume.finishTask = this.tasks.filter(item=>item.finished).length
  }
  build() {
    Column(){
      Button('新增任务')
        .width(150)
        .onClick(()=>{
          this.tasks.push(new ItemTasks())
          this.handleTaskChange()
        })
      List({space:10}){
        ForEach(
          this.tasks,
          (item:ItemTasks,index) =>{
            ListItem(){
              //注意： 方法传递 不需要（）  绑定父组件类this
              Item({item:item,onTaskChange:this.handleTaskChange.bind(this)})
            }
            .swipeAction({end:this.DeleteButton(index)})
          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .alignListItem(ListItemAlign.Center)
    }

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
struct Item {
  @ObjectLink item:ItemTasks
  //方法传递 无参无返回值
  onTaskChange: ()=> void
  build() {
    Row(){
      if(this.item.finished){
        Text(this.item.name)
          .finished()
      }else {
        Text(this.item.name)
      }

      Checkbox()
        .select(this.item.finished)
        .onChange(check =>{
          this.item.finished =check
          // this.handleTaskChange()
          this.onTaskChange()
        })
    }
    .cardStyle()
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

