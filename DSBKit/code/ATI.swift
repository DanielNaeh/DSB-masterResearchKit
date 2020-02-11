//
//  ATSurveyTask.swift
//  ATResearchKit
//
//  Created by Dejan on 06/12/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import ResearchKit

protocol ORKTaskFactory {
    func makeTask() -> ORKTask
}


class ATSurveyTask: ORKTaskFactory {
    func makeTask() -> ORKTask {
        
        let instructions = ORKInstructionStep(identifier: "surveyInsteuctions")
        instructions.title = "We'll ask you a few questions"
        instructions.text = "Here are the instructions on how to answer them"
        
        let heightQuestion = ORKQuestionStep(identifier: "heightQuestionStep",
                                             title: "Your Height",
                                             text: "How tall are  you",
                                             answer: ORKHeightAnswerFormat(measurementSystem: .metric))
        
        let happyQuestion = ORKQuestionStep(identifier: "happyQuestionStep",
                                            title: "Stay Positive",
                                            text: "Are you happy about that?",
                                            answer: ORKTextChoiceAnswerFormat(style: .singleChoice,
                                                                              textChoices: [
                                                                                ORKTextChoice(text: "Yes", value: NSNumber(integerLiteral: 0)),
                                                                                ORKTextChoice(text: "Not really", value: NSNumber(integerLiteral: 1))]))
        
        let explanationStep = ORKQuestionStep(identifier: "explanationStep",
                                              title: "Why?",
                                              text: "Explain why in a few words...",
                                              answer: ORKTextAnswerFormat(maxLength: 288, multiLine: true))
        
           let answerFormat = ORKBooleanAnswerFormat()
           // We attach an answer format to a question step to specify what controls the user sees.
       let questionStep1 = ORKQuestionStep(identifier: String(describing: ORKQuestionStep.self), title: NSLocalizedString("Custom Boolean", comment: ""), text: NSLocalizedString("Your question goes here.", comment: ""), answer: answerFormat)
       
       
        
        let completion = ORKCompletionStep(identifier: "completionStep",
                                           title: "Thanks",
                                           text: "Thanks for taking part in this really important survey.")
        
        return ORKOrderedTask.init(identifier: "surveyTaskID",
                                   steps: [
                                    
                                    instructions,
                                    questionStep1,
                                    heightQuestion,
                                    happyQuestion,
                                    explanationStep,
                                    completion])
    }
}






extension ORKTextAnswerFormat {
    public convenience init(maxLength: Int, multiLine: Bool) {
        self.init(maximumLength: maxLength)
        self.multipleLines = multiLine
    }
}

extension ORKCompletionStep {
    public convenience init(identifier: String, title: String, text: String) {
        self.init(identifier: identifier)
        self.title = title
        self.text = text
    }
}
