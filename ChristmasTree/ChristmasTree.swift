#!/usr/bin/swift

func treeLine(number: Int,spaceNum: Int) -> String {
    var line = "*"
    var num = number
    
    while num > 1 {
        line = line + "**"
        num = num - 1                      // 每次循环 num - 1
    }
    
    var space = spaceNum
    
    while space > 0 {
        line = " "+line
        space = space - 1
    }
    
    return line+"\n"
}

func treeInsertSpace(number: String) -> String {
    var num = Int(number)!
    var tree = String()
    var pole = String()
    
    while num > 0{
        let line = treeLine(number: num,spaceNum: Int(number)! - num)
        let poleLine = treeLine(number: 1,spaceNum: Int(number)! - 1)
        
        tree = line + tree
        if num > 1 {
            pole = poleLine + pole
        }
        
        num = num - 1
    }
    
    return tree+pole
}

let input = CommandLine.arguments[1]
var tree  = treeInsertSpace(number: input)
print("\(tree)")



