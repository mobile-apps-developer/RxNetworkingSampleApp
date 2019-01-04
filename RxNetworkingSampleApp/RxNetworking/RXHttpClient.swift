
import Foundation
// import NSObject_Rx
import RxSwift

private var defaultSession: URLSession {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)

    return session
}

private func request(url theURL: URL, method theMethod: HttpMethods) -> URLRequest {
    var request = URLRequest(url: theURL)
    request.httpMethod = theMethod.rawValue
    return request
}

public class RXHttpClient {
    private init() {}
    @discardableResult
    public class func getRequestObservable(urlString: String) -> Observable<Any> {
        return Observable.create { anObservable in

            let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus

            if reachabilityStatus == Reachability.NetworkStatus.notReachable {
                anObservable.onError(
                    NSError(
                        domain: "Network",
                        code: 400,
                        userInfo: [
                            "details": "No internet connection",
                        ]
                    )
                )
            }

            guard let percentEnoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
                fatalError("URL Error")
            }

            guard let url = URL(string: percentEnoded) else {
                fatalError("URL Error")
            }

            var theRequest = request(
                url: url,
                method: .get
            )

            theRequest.addValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )

            theRequest.addValue(
                "application/json",
                forHTTPHeaderField: "Accept"
            )

            let downloadTask = defaultSession.dataTask(with: theRequest) { (responseData: Data?, _: URLResponse?, error: Error?) in

                OperationQueue.main.addOperation {
                    if let anError = error {
                        anObservable.onError(anError)
                    } else if let d = responseData, let jsonObject = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) {
                        anObservable.onNext(jsonObject)
                        anObservable.onCompleted()
                    } else {
                        anObservable.onError(
                            NSError(
                                domain: "Parser",
                                code: 400,
                                userInfo: ["details": "JSON parse error"]
                            )
                        )
                    }
                }
            }

            downloadTask.resume()

            return Disposables.create {
                downloadTask.cancel()
            }
        }
    }

    public class func postRequestObservable(urlString: String, postPameters params: JSONDictionary) -> Observable<Any> {
        return Observable.create { anObservable in

            let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus

            if reachabilityStatus == Reachability.NetworkStatus.notReachable {
                anObservable.onError(
                    NSError(
                        domain: "Network",
                        code: 400,
                        userInfo: [
                            "details": "No internet connection",
                        ] as JSONDictionary
                    )
                )
            }

            guard
                let percentEnoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            else {
                fatalError("URL Error")
            }

            guard let url = URL(string: percentEnoded) else {
                fatalError("URL Error")
            }

            var theRequest = request(
                url: url,
                method: HttpMethods.post
            )

            theRequest.addValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )

            theRequest.addValue(
                "application/json",
                forHTTPHeaderField: "Accept"
            )

            var postBody = params
            postBody["api_key"] = "UB@P1K8Y"

            debugPrint(postBody)

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: postBody)

                let uploadTask = defaultSession.uploadTask(with: theRequest, from: jsonData) { (responseData: Data?, _: URLResponse?, error: Error?) in

                    let str = String(data: responseData ?? Data(), encoding: String.Encoding.utf8)
                    debugPrint(str ?? "")

                    OperationQueue.main.addOperation {
                        if let anError = error {
                            let _error = NSError(
                                domain: "Parser",
                                code: 400,
                                userInfo: [
                                    "details": anError.localizedDescription,
                                ]
                            )
                            anObservable.onError(_error)
                        } else if let d = responseData, let jsonObject = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) {
                            anObservable.onNext(jsonObject)
                            anObservable.onCompleted()
                        } else {
                            print("urlString = ", urlString)
                            let error = NSError(
                                domain: "Parser",
                                code: 400,
                                userInfo: [
                                    "details": "JSON parse error",
                                ]
                            )
                            anObservable.onError(error)
                        }
                    }
                }

                uploadTask.resume()

                return Disposables.create {
                    uploadTask.cancel()
                }

            } catch {
                anObservable.onError(
                    NSError(
                        domain: "JSON",
                        code: 400,
                        userInfo: [
                            "details": "JSON parse error",
                        ]
                    )
                )
                return Disposables.create {}
            }
        }
    }
}
