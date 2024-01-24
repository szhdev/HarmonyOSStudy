import {Header} from '../pages/Header'

/*//全局自定义构建函数
@Builder function ItemCard(item:Item){
  Row({space:30}) {
    Image(item.image).width(100)
    Column({space:4}) {
      if(item.discount){
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('原价：￥ '+item.price)
          .fontSize(20)
          .fontColor('#CCC')
          .decoration({type:TextDecorationType.LineThrough})
        Text('折扣价：￥ '+item.price)
          .fontSize(20)
          .fontColor('#F36')
        Text('补贴：￥ '+item.price)
          .fontSize(20)
          .fontColor('#F36')
      }else {
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('￥ '+item.price)
          .fontSize(20)
          .fontColor('#F36')
      }
    }
    .width('60%')
    .alignItems(HorizontalAlign.Start)
  }
  .width('100%')
  .borderRadius(20)
  .borderWidth(2)
  .borderColor('#F36A')
  .backgroundColor('#EFEFEF')
  .padding(20)
}*/

/*//全局自定义样式函数@Styles(公共属性)
@Styles function StyleText(){
  .width('100%')
  .borderRadius(20)
  .borderWidth(2)
  .borderColor('#F36A')
  .backgroundColor('#EFEFEF')
  .padding(20)
}*/
//@Extend 特有属性 注意：不能放在组件内部，只能放在全局位置
@Extend(Text) function priceText(){
  .fontSize(20)
  .fontColor('#F36')
}
class Item{
  public  name:string
  public image:ResourceStr
  public price:number
  public discount:number

  constructor(name:string,image:ResourceStr,price:number,discount?:number) {
    this.name = name
    this.image = image
    this.price= price
    this.discount = discount
  }
}

@Entry
@Component
struct ListPage {
  //商品数据
  private items :Array<Item> = [
    new Item('第一个',$r("app.media.icon"),1000,200),
    new Item('第二个',$r("app.media.icon"),2000),
    new Item('第三个',$r("app.media.icon"),3000),
    new Item('第四个',$r("app.media.icon"),4000),
    new Item('第五个',$r("app.media.icon"),5000),
    new Item('第六个',$r("app.media.icon"),6000),
    new Item('第七个',$r("app.media.icon"),7000),
  ]
  @State message: string = 'Hello World'

  build() {
    Column(){
      Header({title:'商品列表案例'})
      // .margin(20)
      List({space:10}){
        ForEach(
          this.items,
          (item:Item) =>{
            ListItem(){
              this.ItemCard(item)
            }
          }
        )
      }
      .width('100%')
      .layoutWeight(1)

    }.width('100%')
    .height('100%')
    .padding(20)
  }

  //局部自定义构建函数 不用加function
  @Builder ItemCard(item:Item){
  Row({space:30}) {
    Image(item.image).width(100)
    Column({space:4}) {
      //判断值0，null 等可作为为false判断
      if(item.discount){
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('原价：￥ '+item.price)
          .fontSize(20)
          .fontColor('#CCC')
          .decoration({type:TextDecorationType.LineThrough})
        Text('折扣价：￥ '+item.price)
          .priceText()
        Text('补贴：￥ '+item.price)
          .priceText()
      }else {
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('￥ '+item.price)
          .priceText()
      }
    }
    .width('60%')
    .alignItems(HorizontalAlign.Start)
  }
  .StyleText()
 }
  //局部自定义样式函数 不用加function
  @Styles StyleText(){
  .width('100%')
  .borderRadius(20)
  .borderWidth(2)
  .borderColor('#F36A')
  .backgroundColor('#EFEFEF')
  .padding(20)
}
}