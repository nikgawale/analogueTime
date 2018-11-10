//
//  ModeViewModel.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 23/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

enum ModeType {
    case DEMO
    case WE_DRIVE
    case YOU_DRIVE
    case COUNT_BY_5
    case COUNT_BY_15
}

class ModeViewModel {
    var type: ModeType = .DEMO
}
