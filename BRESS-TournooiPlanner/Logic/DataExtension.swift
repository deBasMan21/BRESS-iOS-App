//
//  DataExtension.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import Foundation



extension Data {
    init<T>(from value: T){
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes{$0.pointee}
    }
}
