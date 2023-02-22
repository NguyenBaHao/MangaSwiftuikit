//
//  ReadModeManager.swift
//  MangaTopReader
//
//  Created by mac on 19/07/2022.
//

import UIKit

open class ReadModeManager: NSObject {
    
    public static let shared = ReadModeManager()
        
    public func saveReadingMode(mode: MangaReaderMode){
        UserDefaults.standard.setValue(mode.rawValue, forKeyPath: "ReadModeManager")
    }
    
    public func getReadingMode() -> Int?{
        return UserDefaults.standard.integer(forKey: "ReadModeManager") ?? 1
    }
    
}
