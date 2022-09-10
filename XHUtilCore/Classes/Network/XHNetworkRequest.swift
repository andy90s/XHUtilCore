//
//  XHNetworkRequest.swift
//  XHUtilCore
//
//  Created by 梁先华 on 2022/9/10.
//

import Foundation
import HandyJSON
import Alamofire
import RxSwift

struct BaseResponse<T: HandyJSON>: HandyJSON {
    var code : Int = -1
    var msg : String = ""
    var data : T? = nil
    
    func valid() -> Bool {
        return true
    }
}

class XHNetworkRequest {
    
    enum NetRequestError: Error {
        case URLNotFound
        case DownloadFailed
        case ServerError(Int,String)
        case ResponseDataEmpty
    }
    
    enum EncodingType{
        case `default`
        case json
    }
    
    static let sharedSessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        return Alamofire.Session(configuration: configuration)
    }()
    
    class func request<T: HandyJSON>(params: RequestParamsAppender,method: HTTPMethod,progress: Bool = true,ignoreError:Bool = false,encodingType:EncodingType = .default,isHead:Bool = false,header:[String:String] = [:]) -> Observable<BaseResponse<T>>{
        return Observable<BaseResponse<T>>.create{ ob in
//            var header = [String:String]()
//            if app.localLanguage == .ZH {
//                header.append(dict: ["accept-language":"zh"])
//            }else if app.localLanguage == .EN {
//                header.append(dict: ["accept-language":"en"])
//            }else{
//                header.append(dict: ["accept-language":"en"])
//            }
            
            var encoding:ParameterEncoding = URLEncoding.queryString
            switch encodingType{
                case .`default`:
                    break
                case .json:
                    encoding = JSONEncoding.default
            }
            
            request(params:params, method: method, encodingType: encoding, header: header) { response in
                
                print("******请求参数->>>>\(params.params)")
                if response.error != nil {
                    
                    if let data = response.data,let jsonString = String(data: data, encoding: String.Encoding.utf8){
                        debuglog("\n请求参数地址->>>>\(params.url)\n请求失败->>>>\(response.error.debugDescription)\n******错误信息->>>>\n" + jsonString)
                    }else{
                        debuglog("\n请求参数地址->>>>\(params.url)\n请求失败->>>>\(response.error.debugDescription)")
                    }
                    ob.onError(response.error!)
                    
                } else if let data = response.data,let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                    
                    let Json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary
                    if Json != nil {
                        debuglog("\n请求参数地址->>>>\(params.url)\n******返回数据->>>>")
                        debuglog("请求结果", Json as Any)
                    }else{
                        debuglog("\n请求参数地址->>>>\(params.url)\n******返回数据->>>>\n" + jsonString)
                    }
                    
                    if let next = BaseResponse<T>.deserialize(from: jsonString){
                    
                        if next.code == SuccessCode.0 {
                            ob.onNext(next)
                        }
//                        else if next.code == tokenOverdue {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                                LD_ShowError(errorStr: next.msg)
//                            }
//                            app.needLogin()
//                        }
                    else {
                            ob.onError(NetRequestError.ServerError(next.code, next.msg))
//                          if !ignoreError && next.code != 500{
//                            if !ignoreError {
//                                loginError(code: next.code)
//                                LD_ShowError(errorStr: next.msg)
//                            }
                        }
                    }else{
//                        if !ignoreError {
//                            LD_ShowError(errorStr:localized("数据解析错误"))
//                        }
                    }
                }else{
//                    if !ignoreError {
//                        LD_ShowError(errorStr:localized("网络错误，请稍后重试"))
//                    }
                }
                ob.onCompleted()
            }
            
            return Disposables.create{}
        }
    }
    
    class func request(params: RequestParamsAppender,method: HTTPMethod,progress: Bool = true, encodingType:ParameterEncoding = URLEncoding.default, header: [String:String], completionHandler:@escaping (AFDataResponse<Data>) -> Void) {
        
        let req: DataRequest = sharedSessionManager.request(params.url, method: method, parameters: params.done(), encoding: encodingType ,headers:HTTPHeaders(header))
        
        req.validate().responseData { response in
            if response.error != nil {
                //处理错误代码400、405的问题
                if response.error?.responseCode == 400 {
                    debuglog("\n=============请求报错400,再次请求===========\n url=\(params.url)");
                    //再次请求
                    sharedSessionManager.request(params.url, method: method, parameters: params.done(), encoding: encodingType ,headers:HTTPHeaders(header)).validate().responseData(completionHandler: completionHandler)
                }else if (response.error?.responseCode == 405){
                    debuglog("\n=============请求报错405,再次请求===========\n url=\(params.url)");
                    //再次请求
                    sharedSessionManager.request(params.url, method: method, parameters: params.done(), encoding: encodingType ,headers:HTTPHeaders(header)).validate().responseData(completionHandler: completionHandler)
                }else{
                    completionHandler(response)
                }
                
            }else{
                completionHandler(response)
            }
        }
    }
}

