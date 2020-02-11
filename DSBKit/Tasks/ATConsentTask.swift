//
//  ATConsentTask.swift
//  ATResearchKit
//
//  Created by Dejan on 06/12/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import ResearchKit

class ATConsentTask: ORKTaskFactory {
    func makeTask() -> ORKTask {
        
        let consentDocument = ORKConsentDocument()
        consentDocument.title = "Study Consent"
        consentDocument.sections = [
            ORKConsentSection(type: .overview,
                              summary: "Random study",
                              content: "Some general info about the study"
            ) ,
            
            ORKConsentSection(type: .custom,
                              summary: "",
                              content: "ddddd"
            ),
                              
            ORKConsentSection(type: .privacy,
                              summary: "Your privacy is important to us",
                              content: "We'll protect your privacy and won't sell your data"),
            ORKConsentSection(type: .dataUse,
                              summary: "We need some data",
                              content: "Your data will only be used for research purposes"),
            ORKConsentSection(type: .timeCommitment,
                              summary: "You'll spend some time",
                              content: "You will spend roughly 15 minutes a week"),
            ORKConsentSection(type: .studySurvey,
                              summary: "Study survey",
                              content: "You'll be filling out some surveys"),
            ORKConsentSection(type: .studyTasks,
                              summary: "Study tasks",
                              content: "Some of the tasks might require you to move around"),
            
            ORKConsentSection(type: .custom,
                              summary: "custom",
                              content: "Custom leave the survey"),
            
            ORKConsentSection(type: .withdrawing,
                              summary: "Withdrawing",
                              content: "You can always leave the survey")
        ]
        
        
        
        let newORK =  ORKConsentSection(type: .custom)
        newORK.summary = "New summary"
        newORK.htmlContent = "<h1> sgddgd </h1>"
        
        
        consentDocument.sections?.append(newORK)
        
        
        
        consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ParticipantSignature"))
        
        return ORKOrderedTask(identifier: "consentTaskID",
                              steps: [
                                ORKVisualConsentStep(identifier: "visualConsentStepID",
                                                     document: consentDocument),
                                ORKConsentReviewStep(identifier: "consentReviewStepID",
                                                     document: consentDocument,
                                                     text: "Review",
                                                     reason: "Review the consent")
            ])
    }
}

extension ORKConsentSection {
    public convenience init(type: ORKConsentSectionType, summary: String?, content: String?) {
        self.init(type: type)
        self.summary = summary
        self.content = content
    }
}

extension ORKConsentReviewStep {
    public convenience init(identifier: String, document: ORKConsentDocument, text: String?, reason: String?) {
        guard let signature = document.signatures?.first else {
            fatalError("Cannot create a review step without a signature")
        }
        self.init(identifier: identifier, signature: signature, in: document)
        self.text = text
        self.reasonForConsent = reason
    }
}
