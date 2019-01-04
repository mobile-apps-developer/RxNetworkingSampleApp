//
//  ViewController.swift
//  RxNetworkingSampleApp
//
//  Created by rails gr4 on 27/12/19.
//  Copyright © 2019 Deqode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        RXHttpClient.getRequestObservable(urlString: "https://jsonplaceholder.typicode.com/posts/1/comments")
            .subscribe(onNext: { anyResponse in
                print(anyResponse)
            },
            onError: { error in
                print(error)
            }
        )
    }
}
