//
//  TestOperationsService.swift
//  Operation_practice_06
//
//  Created by yuichi.watanabe on 2016/10/12.
//  Copyright © 2016年 yuichi.watanabe. All rights reserved.
//
/* queueを使わず、複数のOperationを実行させようとすると複雑になった
 * Operation一つでどこまで可能か検証する
 * 結論としては、addするのは１回に限定して、その中で条件に応じてprivateを呼び分ければ可能
 * GCDのDispatchQueue.mainは使わない
 */
/* 通信が入る非同期の処理を含んだ場合が気になる
 * NSURLRequestなどのAPI処理 -> 一般的よくあるパターンで検証したい
 */

import Foundation


class TestOperationServiceA : BlockOperation
{
    let sampleId : String
    
    init( sampleId s : String )
    {
        self.sampleId = s
        super.init()


        //        // 1
        //        self.addExecutionBlock {
        //            DispatchQueue.main.async {
        //                self.testOperation(operationNumber: 1, timeInterval: 1.5)
        //            }
        //        }
        //
        //        // 2
        //        self.addExecutionBlock {
        //            DispatchQueue.main.async {
        //                self.testOperation(operationNumber: 2, timeInterval: 0.5)
        //            }
        //        }
        //
        //        // 3
        //        self.addExecutionBlock {
        //            DispatchQueue.main.async {
        //                self.testOperation(operationNumber: 3, timeInterval: 0.3)
        //            }
        //        }
        
        
        // 1 2 3
        self.addExecutionBlock {
            self.testOperation(operationNumber: 1, timeInterval: 1.5)
            self.testOperation(operationNumber: 2, timeInterval: 0.5)
            self.testOperation(operationNumber: 3, timeInterval: 0.3)
        }
        
        
    }
    
// operation内容だけを書いて実行したら、順番がバラバラになった
//Operation3::  <NSThread: 0x618000079d80>{number = 3, name = (null)}
//Operation2::  <NSThread: 0x60800007a980>{number = 4, name = (null)}
//Operation1::  <NSThread: 0x608000078bc0>{number = 1, name = main}
    
// 一つのblockにまとめて書いてみた、やはり順番は守られた((成功)メインスレッドに統一された)
//Operation1:: <NSThread: 0x608000073340>{number = 1, name = main}
//Operation3:: <NSThread: 0x608000073340>{number = 1, name = main}
//Operation2:: <NSThread: 0x608000073340>{number = 1, name = main}
    
//self.waitUntilFinished() はシングルOperation内なので、使えない
    
//DispatchQueue.main.async を使用した結果、順番はバラバラだった(メインスレッドに統一されたが、)
// ただ問題がある、スレッドを意識しないコンセプトが意味なくなっている
// operationの皮を被ったGCD
//Operation1:: <NSThread: 0x608000263fc0>{number = 1, name = main}
//Operation2:: <NSThread: 0x608000263fc0>{number = 1, name = main}
//Operation3:: <NSThread: 0x608000263fc0>{number = 1, name = main}
    
    
    fileprivate func testOperation(operationNumber o: Int, timeInterval t: TimeInterval)
    {
        print( "Operation\(o):: \(Thread.current)" )
        Thread.sleep( forTimeInterval: t )
    }
    
    
}
