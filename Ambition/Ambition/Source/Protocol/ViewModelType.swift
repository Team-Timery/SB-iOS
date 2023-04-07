//
//  ViewModelType.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/18.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposedBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
