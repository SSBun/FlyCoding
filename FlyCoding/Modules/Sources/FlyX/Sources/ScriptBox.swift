//
//  ScriptBox.swift
//  BZCodeX
//
//  Created by caishilin on 2021/12/28.
//  Copyright © 2021 SSBun. All rights reserved.
//

import Foundation

public final class ScriptMagicBox {
    func execute(commands: String..., in root: String? = nil) throws -> String? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        if let root = root {
            task.currentDirectoryURL = URL(fileURLWithPath: root)
        }
        task.arguments = commands
        let pipe = Pipe()
        task.standardOutput = pipe
        try task.run()
        let resultData = pipe.fileHandleForReading.readDataToEndOfFile()
        let resultString = String(data: resultData, encoding: .utf8)
        return resultString
    }
}
