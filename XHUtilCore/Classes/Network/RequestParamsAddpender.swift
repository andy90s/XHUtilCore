//
//  RequestParamsAddpender.swift
//  XHUtilCore
//
//  Created by 梁先华 on 2022/9/10.
//

import Foundation
import Alamofire

open class RequestParamsAppender: NSObject {
    var url: URL
    var params:Dictionary = [String: Any]()
    
    private init(url: String){
        self.url = URL(string: url)!
    }
    
    public func interface(url: String) -> RequestParamsAppender {
        self.url.appendPathComponent(url)
        return self
    }
    
    @discardableResult
    public func append(key: String,value: String) -> RequestParamsAppender {
        //        if value == ""{
        //            return self
        //        }else{
        params += ["\(key)":"\(value)"]
        return self
    }
    
    @discardableResult
    public func append(key: String,value: String?) -> RequestParamsAppender {
        if  value?.isEmpty ?? true ||  value == ""  { return self }
        params += ["\(key)":"\(value ?? "")"]
        return self
    }
    
    @discardableResult
    public func append(key: String, value: Int?) -> RequestParamsAppender {
        if value == nil  { return self }
        params += ["\(key)":"\(value ?? 0)"]
        return self
    }
    
    @discardableResult
    public func append(key: String, value: Int) -> RequestParamsAppender {
        params += ["\(key)":"\(value )"]
        return self
    }
    
    @discardableResult
    public func append(key: String, value: Int64) -> RequestParamsAppender {
        params += ["\(key)":"\(value)"]
        return self
    }
    
    @discardableResult
    public func append(key: String, value: Double) -> RequestParamsAppender {
        params += ["\(key)":"\(value)"]
        return self
    }

    @discardableResult
    public func append(key: String, value: Double?) -> RequestParamsAppender {
        if value == nil  { return self }
        params += ["\(key)":"\(value ?? 0)"]
        return self
    }
    
    @discardableResult
    public func append(key: String,data: Data) -> RequestParamsAppender {
        params += ["\(key)": data]
        return self
    }
    
    @discardableResult
    public func append(key: String,url: URL) -> RequestParamsAppender {
        params += ["\(key)":"\(url)"]
        return self
    }

    @discardableResult
    public func append(key:String,array:[Any]) -> RequestParamsAppender {
        params += ["\(key)":array]
        return self
    }
    
    @discardableResult
    public func append(key:String,array:[String]) -> RequestParamsAppender {
        params += ["\(key)":array]
        return self
    }

    /// 参数加密 预留
    func done() -> Parameters {
//        append(key: "languageId", value: app.localLanguage.rawValue)
        return self.params
    }
//
//    func doneB() -> Parameters {
//        //append(key: "languageId", value: app.localLanguage.rawValue)
//        return self.params
//    }
    
    public class func build(url: String) -> RequestParamsAppender {
        return RequestParamsAppender(url: url)
    }
}

func += <K,V> ( left: inout Dictionary<K,V>, right: Dictionary<K,V>?) {
    guard let right = right else { return }
    right.forEach { key, value in
        left.updateValue(value, forKey: key)
    }
}
