//
//  GlobalConstants.swift
//  HZGaugeView
//
//  Created by zz go on 2017/6/22.
//  Copyright © 2017年 ZenonHuang. All rights reserved.
//

import UIKit

/**
 * iOS-swift常用常量以及通用函数小总结
 *****************************************************************
 ***|
 ***| 1. APP屏幕(UIScreen)大小相关
 ***| 2. App Version / Info Plist  系统版本比较等
 ***| 3. catch缓存文件夹和Documents文件夹
 ***| 4. 图片  UIImage
 ***| 5. rgb颜色转换 UIColor
 ***| 6. 字体 UIFont  只列举一种，其他的换名称自己可定义
 ***| 7. 角度转弧度 弧度转角度
 ***| 8. 系统内部常用(暂空缺)
 ***| 9. 时间格式
 ***
 ******************************************************************
 */



///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  1. App 屏幕相关   Frame   Bounds
//
///////////////////////////////////////////////////////////////////////////////////////////////////

//MARK: - App 屏幕相关 

let kScreenBounds                         = UIScreen.main.bounds                    /* 屏幕Bounds */
let kScreenSize                           = kScreenBounds.size                      /* 屏幕大小 */
let kScreenWidth:CGFloat                  = kScreenSize.width                       /* 屏幕宽度 */
let kScreenHeight:CGFloat                 = kScreenSize.height                      /* 屏幕高度 */
let kNavigationHeight :CGFloat            = UINavigationBar.appearance().frame.size.height  /* 导航条高度 44 */
let kStatuBarHeight   :CGFloat            = UIApplication.shared.statusBarFrame.size.height  /* 状态栏高度  20*/
let kNavigationHeightAndStatuBarHeight    = kNavigationHeight + kStatuBarHeight      //64

//屏幕分辨率比例
let screenScale:CGFloat = UIScreen.main.responds(to: #selector(getter: UIScreen.main.scale)) ? UIScreen.main.scale : 1.0

//不同屏幕尺寸字体适配（375，667是因为目前苹果开发一般用IPHONE6做中间层 如果不是则根据实际情况修改）
//相对于iPhone6的宽度比例
let screenWidthRatio:CGFloat =  kScreenWidth / 375;
let screenHeightRatio:CGFloat = kScreenHeight / 667;

//根据传入的值算出乘以比例之后的值
func adaptedWidth(width:CGFloat) ->CGFloat {
    return CGFloat(ceil(Float(width))) * screenWidthRatio
}

func adaptedHeight(height:CGFloat) ->CGFloat {
    return CGFloat(ceil(Float(height))) * screenHeightRatio
}

//判断是那种设备

/*
 4  4s
 */
func iPhone4() ->Bool {
    return UIScreen.main.bounds.size.height == 480.0
}

/*
 5  5s
 */
func iPhone5() ->Bool {
    return UIScreen.main.bounds.size.height == 568.0
}

/*
 6  6s  7
 */
func iPhone6() ->Bool {
    return UIScreen.main.bounds.size.height == 667.0
}

/*
 6plus  6splus  7plus
 */
func iPhone6plus() ->Bool {
    return UIScreen.main.bounds.size.height == 736.0
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  2. App Version / Info Plist  设备系统版本
//
///////////////////////////////////////////////////////////////////////////////////////////////////

//MARK:  -  App 系统版本

/* 设备系统相关  */
let kiOSVersion:String        = UIDevice.current.systemVersion         /* iOS系统版本 */
let osType:String             = UIDevice.current.systemName + UIDevice.current.systemVersion




/* app版本  以及设备系统版本 */
let infoDictionary            = Bundle.main.infoDictionary
let kAppName: String?         = infoDictionary!["CFBundleDisplayName"] as? String        /* App名称 */
let kAppVersion: String?      = infoDictionary!["CFBundleShortVersionString"] as? String /* App版本号 */
let kAppBuildVersion: String? = infoDictionary!["CFBundleVersion"] as? String            /* Appbuild版本号 */
let kAppBundleId: String?     = infoDictionary!["CFBundleIdentifier"] as? String                 /* app bundleId */
let platformName: String?     = infoDictionary!["DTPlatformName"] as? String  //平台名称（iphonesimulator 、 iphone）


/* 检查系统版本 */

//版本号相同
func systemVersionEqual(version:String) ->Bool {
    return UIDevice.current.systemVersion == version
}

//系统版本高于等于该version  测试发现只能传入带一位小数点的版本号  不然会报错    具体原因待探究
func systemVersionGreaterThan(version:String) ->Bool{
    return UIDevice.current.systemVersion.compare(version, options: .numeric, range: version.startIndex..<version.endIndex, locale: Locale(identifier:version)) != ComparisonResult.orderedAscending
}


//系统版本低于等于该version  测试发现只能传入带一位小数点的版本号  不然会报错    具体原因待探究
func systemVersionLessThan(version:String) ->Bool{
    return UIDevice.current.systemVersion.compare(version, options: .numeric, range: version.startIndex..<version.endIndex, locale: Locale(identifier:version)) != ComparisonResult.orderedDescending
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  3. cache缓存文件夹和Documents文件夹
//
///////////////////////////////////////////////////////////////////////////////////////////////////

//MARK:  - cache缓存文件夹和Documents文件夹

let XHUserDefault = UserDefaults.standard


/// Cache缓存文件夹
let cacheDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last

/// Documents文件夹
let documentsDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  4. 图片  UIImage 加载本地  以及初始化
//
///////////////////////////////////////////////////////////////////////////////////////////////////

//MARK:  - 图片

//读取本地图片 （文件名，后缀名）
func loadImage(imageName __imgName__:String,imgExtension __imgExt__:String) -> UIImage {
    return UIImage.init(contentsOfFile: Bundle.main.path(forResource: __imgName__, ofType: __imgExt__)!)!
}

//定义UIImage对象 （文件名）  png格式

func loadPNGImage(imageName __imgName__:String) -> UIImage {
    return UIImage.init(contentsOfFile: Bundle.main.path(forResource: __imgName__, ofType: "png")!)!
}





///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  6. 字体 UIFont  只列举一种，其他的换名称自己可定义
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
//MARK: -  字体

/// 方正黑体简体字体定义
///
/// - Parameter __SIZE__: 字体大小
/// - Returns: UIFont
func XH_Font_FZHT(size __SIZE__:CGFloat) ->UIFont {
    return UIFont.init(name: "FZHTJW--GB1-0", size: __SIZE__)!
}

//此处只列举一种  其它的查询名字后直接使用


///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  7. 角度转弧度 弧度转角度
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

// MARK: -  角度／弧度 转化

/// 角度转弧度
///
/// - Parameter __ANGLE__: 角度
/// - Returns: 弧度值
func XH_Angle_To_Radian(__ANGLE__:CGFloat) ->CGFloat {
//    return (CGFloat(M_PI) * __ANGLE__ / 180.0)
    
        return (CGFloat(Double.pi) * __ANGLE__ / 180.0)
}


/// 弧度转角度
///
/// - Parameter __RADIAN__: 弧度
/// - Returns: 角度
func XH_Radian_To_Angle(__RADIAN__:CGFloat) ->CGFloat {
//    return (CGFloat(__RADIAN__ * 180 / CGFloat(M_PI)))
     return (CGFloat(__RADIAN__ * 180 / CGFloat(Double.pi)))
  
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  8. 系统内部常用
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

// TODO: 系统内部常用

/**
 *  对于函数，类，协议等设定可用性
 *  使用 @available 声明这些类型的生命周期依赖于特定的平台和操作系统版本
 *  必须包含至少2个特性参数
 *  @available(iOS 10, *)是简写形式，全写形式是@available(iOS, introduced=10.0)
 *  @available(iOS 8.0, OSX 10.10, *) 也是可以的，表示多平台的支持
 *  
 *  @available还有一些其它参数：
 * deprecated=版本号 ：从指定平台某个版本开始过期该声明
 * message=信息内容 ：给出一些附加信息
 * unavailable ：指定平台上是无效的
 * renamed=新名字 ：重命名声明
 
 * 具体见：http://wiki.jikexueyuan.com/project/swift/chapter3/06_Attributes.html
 */



//@available(iOS 10, *)
//func myTEST() {
//    
//}


/**
 *    #available 用在条件语句代码块中，判断不同的平台下，做不同的逻辑处理
 *
 */

//if #available(iOS 10, *) {
//    //iOS10及以上系统
//}

//func test() {
//    guard #available(iOS 10, *) else {
//        //iOS10以下系统
//        return
//    }
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  9. 常用枚举
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

// MARK: -  常用枚举

enum TimeFormat : String {
    case format_default = "yyyy-MM-dd HH:mm:ss"
    case format_yyMdHm  = "yy-MM-dd HH:mm"
    case format_yyMd    = "yy-MM-dd"
    case format_yMdWithSlash = "yyyy/MM/dd"
    case format_yMdChangeSeparator = "yyyy.MM.dd"
    // FIXME: 补充其他格式
}
