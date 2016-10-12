//
//  ViewController.swift
//  Operation_practice_06
//
//  Created by yuichi.watanabe on 2016/10/12.
//  Copyright © 2016年 yuichi.watanabe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    override func viewDidAppear(_ animated: Bool)
    {
        let operation = TestOperationServiceA(sampleId: "A014536924")
            operation.start()
        
        let operation2 = TestOperationServiceA(sampleId: "B014536926")
            operation2.start()
    }

}

