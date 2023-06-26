//
//  Bundle+dl.swift
//  DLCommon
//
//  Created by marshal on 2023/4/5.
//

import Foundation

public extension Bundle{
    
    /// 获取指定bundle
    /// - Parameters:
    ///   - name: 库名称,如：ZLCommon -> ZLCommon.framework，nil返回 mainBundle
    ///   - bundleName: bundle名，如：ZLCommon.bundle
    /// - Returns: 返回指定bundle
    class func dl_buldle(forModule name:String? = nil,bundleName:String? = nil) -> Bundle? {
        guard let name = name else { return Bundle.main }
        var bundlePath:String?
       if let path = Bundle.main.path(forResource: name, ofType: "bundle") {
           bundlePath = path
       }else{
        var path1 = name
        if path1.contains("-") {
            path1 = path1.replacingOccurrences(of: "-", with: "_")
        }
       
        let fullPath = "Frameworks/" + path1 + ".framework/" + (bundleName ?? name)
           bundlePath = Bundle.main.path(forResource: fullPath, ofType: "bundle")
       }
        if let bundle = Bundle(path: bundlePath ?? "") {
            return bundle
        }
        //找不到，默认返回main
        return Bundle.main
    }
}
