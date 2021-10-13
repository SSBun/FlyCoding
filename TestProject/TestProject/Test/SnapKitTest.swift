//
//  SnapKitTest.swift
//  TestProject
//
//  Created by caishilin on 2021/10/13.
//

import UIKit
import SnapKit

class SnapKitTestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func test_toSuperView() {
        let label = UILabel()
//        #snpm(label, c=super)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
