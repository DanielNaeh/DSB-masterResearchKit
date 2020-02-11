//
//  ViewController.swift
//  ATResearchKit
//
//  Created by Dejan on 09/11/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
    
    @IBAction func getConsent(_ sender: Any) {
        let task = ATConsentTask().makeTask()
        showTask(task)
    }
    
    @IBAction func startSurvey(_ sender: Any) {
        let survey = ATSurveyTask().makeTask()
        showTask(survey)
    }

    @IBAction func startActiveTask(_ sender: Any) {
        let activeTask = ORKOrderedTask.towerOfHanoiTask(withIdentifier: "towerOfHanoi",
                                                         intendedUseDescription: "We'll test your problem solving skills",
                                                         numberOfDisks: 3,
                                                         options: [])
        showTask(activeTask)
    }

    private func showTask(_ task: ORKTask) {
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
}

extension ViewController: ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        print("Got the results: \(taskViewController.result)")
        
        dismiss(animated: true, completion: nil)
    }
}
