import { Header } from './Header'
@Observed
class Person{
  name: string
  age: number
  gf:Person

  constructor(name: string,age: number,gf?:Person) {
    this.name = name
    this.age =age
    this.gf =gf
  }
}
@Entry
@Component
struct StatePage {
  //(状态)@State：驱动视图更新的数据，被标记的变量必须初始化，不能能为空值，
  // 支持Object、class、string、number、boolean、enum类型以及这些类型的数组
  //嵌套类型以及数组中的对象属性无法触发视图更新

  @State message: string = 'Hello World'
  @State person:Person = new Person('Jack',21)
  //嵌套类型
  @State person1:Person = new Person('Jack',21,new Person("Rose",20))
  //数组
  @State person2:Person []=[
    new Person("Rose",20),
    new Person("Lily",18)
  ]
  idx: number = 1

  build() {
    Row() {
      Column({space:10}) {
        Header({title:'视图更新案例'})
        Text(this.message)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            this.message = 'Hello ArhTs!'
          })
        Text(`${this.person.name} : ${this.person.age}`)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            this.person.age++
          })
        Text(`嵌套类型 > ${this.person1.gf.name} : ${this.person1.gf.age}`)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            //无法触发视图更新
            this.person1.gf.age++
          })
        Child({name:'嵌套类型',person1:this.person1.gf})
          .onClick(()=>{
            //可以触发视图更新
            this.person1.gf.age++
          })
        Text('-----女有列表-----')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        ForEach(
          this.person2,
          (item:Person,index)=>{
            Row({space:10}){
             /* Text(`${item.name} : ${item.age}`)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .onClick(()=>{
                  //无法触发视图更新
                  // item.age++
                  //重新赋值（不是很友好）
                  this.person2[index] = new Person(item.name,item.age+1)
                })*/
              Child({name:'数组类型',person1:item})
                .onClick(()=>{
                  //可以触发视图更新
                  item.age++

                })
              Button('删除')
                .width(100)
                .onClick(()=>{
                  this.person2.splice(index,1)
                })
            }.padding({top:10,bottom:10})

          }
        )

        Button('添加')
          .width(150)
          .onClick(()=>{
            this.person2.push(new Person("女友"+this.idx++,20))
          })


      }
      .width('100%')
      .height('100%')

    }
    .height('100%')
  }
}

@Component
struct Child {
  @State name:string = '嵌套类型'
  @ObjectLink person1:Person
  build() {
    Column(){
      Text(`${this.name} > ${this.person1.name} : ${this.person1.age}`)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
    }
  }
}
