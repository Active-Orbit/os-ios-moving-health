//
//  HelpController.swift
//  App
//
//  Created by George Stavrou on 05/07/2023.
//

import UIKit

class HelpController: BaseController {

    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var screenTitle: BaseLabel!
    @IBOutlet var menuWhatWeOffer: HelpComponent!
    @IBOutlet var menuFaqs: HelpComponent!
    @IBOutlet var menuAbout: HelpComponent!
    @IBOutlet var menuUploadData: HelpComponent!
    @IBOutlet var menuContactUs: HelpComponent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        prepare()
        setClickListeners()
                
    }
    
    
    func prepare() {
        
        menuUploadData.visibility = .invisible
        
        menuWhatWeOffer.setTitle(StringProvider.get("participant_information_and_policy"))
        menuFaqs.setTitle(StringProvider.get("frequently_asked_questions"))
        menuAbout.setTitle(StringProvider.get("about_the_app"))
        menuUploadData.setTitle(StringProvider.get("upload_phone_data"))
        menuContactUs.setTitle(StringProvider.get("contact_us"))
    }
    
    
    func setClickListeners() {
        
        menuWhatWeOffer.setOnClickListener {
            let boundle = Boundle()
            boundle.putBoolean(Extra.FROM_MENU.key, true)
            boundle.putBoolean(Extra.FROM_HELP.key, true)
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.CONSENT_PRIVACY, boundle)
        }
        
        menuFaqs.setOnClickListener {
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.FAQ)
        }
        
        menuAbout.setOnClickListener {
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.ABOUT)
        }
        
        menuUploadData.setOnClickListener {
            //TODO upload data
           
        }
        
        menuContactUs.setOnClickListener {
            //TODO change controller to CONTACTUS
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.CONTACT_US)
        }
    }
    
    
}
