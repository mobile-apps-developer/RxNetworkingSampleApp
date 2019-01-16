# RxNetworkingSamle App
This sample app demostrate the use of RxSwift
# How to
  - Install RxSwift via CocoaPods
  - Clone or download the repo and add the folder `RxNetworking` to your project

Now you can all the APIs like this. At present `GET` and `POST` type request can be called.
```
RXHttpClient.getRequestObservable(urlString: "https://jsonplaceholder.typicode.com/posts/1/comments")
            .subscribe(onNext: { anyResponse in
                print(anyResponse)
            },
            onError: { error in
                print(error)
            }, onCompleted: {

            }, onDisposed: {

            }
        )```