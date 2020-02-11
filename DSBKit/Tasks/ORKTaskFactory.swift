//
//  ORKTaskFactory.swift
//  ATResearchKit
//
//  Created by Dejan on 06/12/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import ResearchKit

protocol ORKTaskFactory {
    func makeTask() -> ORKTask
}
