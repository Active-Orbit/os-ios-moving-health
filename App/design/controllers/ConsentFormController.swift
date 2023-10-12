//
//  ConsentFormController.swift
//  BaseApp
//
//  Created by Omar Brugna on 07/07/2023.
//

import UIKit
import CBPinEntryView
import Tracker
import WebKit

class ConsentFormController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var mainView: BaseView!
    @IBOutlet var bottomContainer: UIView!
    @IBOutlet var questionsCollectionView: QuestionsCollectionView!
    @IBOutlet var fullName: BaseTextField!
    @IBOutlet var btnDate: ButtonComponent!
    @IBOutlet var stepOne: UIView!
    @IBOutlet var stepTwo: UIView!
    @IBOutlet var stepThree: UIView!
    @IBOutlet var stepFour: UIView!
    @IBOutlet var backBtn: BaseButton!
    @IBOutlet var confirmBtn: BaseButton!
    // TODO
    // @IBOutlet var btnDownload: BaseButton!
    @IBOutlet var scrollView: BaseScrollView!
    @IBOutlet var stepsLayout: UIView!
    @IBOutlet var buttonsLayout: UIView!
    
    @IBOutlet var questionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bottomScrollVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var bottomSafeAreaVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet var nextButtonLeadingToBackButtonConstraint: NSLayoutConstraint!
    @IBOutlet var nextButtonLeadingToSafeAreaConstraint: NSLayoutConstraint!
    
    fileprivate var dateOfConsent: Date? = nil
    fileprivate var fromMenu = false
    fileprivate var fromHelp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        fromMenu = controllerBoundle.getBoolean(Extra.FROM_MENU.key)
        fromHelp = controllerBoundle.getBoolean(Extra.FROM_HELP.key)
        
        prepare()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForKeyboardNotifications()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if questionsCollectionView.isMisplaced() {
            // needed to fix collection misplaced frame
            questionsCollectionView.reloadAll()
        }
        questionsCollectionView.lastFrame = questionsCollectionView.frame
    }
    
    fileprivate func prepare() {
        
        bottomContainer.cornerRadius = 10
        
        btnDate.setIcon(ImageProvider.get("ic_calendar"))
        setTextFieldBackground(fullName)
        fullName.delegate = self
        
        stepOne.cornerRadius = 5
        stepTwo.cornerRadius = 5
        stepThree.cornerRadius = 5
        stepFour.cornerRadius = 5
        
        let htmlStringFixed = Preferences.user.consentFormText.replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
        var html = "<html>"
        html += "<head>"
        html += "</head>"
        html += "<body>"
        html += htmlStringFixed
        html += "</body>"
        html += "<html>"
        
        if fromMenu {
            
            if fromHelp {
                bottomContainer.removeFromSuperview()
            } else {
                questionsCollectionView.allAccepted = true
                showQuestions()
            }
            
            fullName.isEnabled = false
            fullName.text = Preferences.user.userFullName()
            
            dateOfConsent = Preferences.user.userConsentDate!
            btnDate.setText(TimeUtils.format(dateOfConsent!, Constants.DATE_FORMAT_YEAR_MONTH_DAY, convertToDefault: true))
            
            stepsLayout.visibility = .invisible
            buttonsLayout.visibility = .invisible
            
            backBtn.visibility = .visible
            nextButtonLeadingToSafeAreaConstraint.priority = UILayoutPriority(999)
            nextButtonLeadingToBackButtonConstraint.priority = UILayoutPriority(1000)
            backBtn.setOnClickListener {
                self.finish()
            }
            
            bottomScrollVerticalConstraint.priority = UILayoutPriority(999)
            bottomSafeAreaVerticalConstraint.constant = 20
            bottomSafeAreaVerticalConstraint.priority = UILayoutPriority(1000)
            
        } else {
            
            stepsLayout.visibility = .visible
            buttonsLayout.visibility = .visible
            // TODO
            // btnDownload.visibility = .invisible
            
            dateOfConsent = TimeUtils.getCurrent()
            btnDate.setText(TimeUtils.format(dateOfConsent!, Constants.DATE_FORMAT_YEAR_MONTH_DAY, convertToDefault: true))
            
            questionsCollectionView.allAccepted = false
            
            confirmBtn.setOnClickListener {
                if !TextUtils.isEmpty(self.fullName.textTrim) && self.dateOfConsent != nil && self.questionsCollectionView.allQuestionsAccepted() {
                    if !NotificationManager.shared.granted() {
                        NotificationManager.shared.request(completion: { success in
                            mainThread {
                                if success {
                                    self.scheduleNotification()
                                }
                                self.proceed()
                            }
                        })
                    } else {
                        self.proceed()
                    }
                } else {
                    Toast.showLongToast(self.view, StringProvider.get("accept_toc_please"))
                    self.scrollView.scrollToView(self.questionsCollectionView, true)
                }
            }
            
            nextButtonLeadingToBackButtonConstraint.priority = UILayoutPriority(999)
            nextButtonLeadingToSafeAreaConstraint.priority = UILayoutPriority(1000)
            backBtn.visibility = .invisible
            
            showQuestions()
        }
    }
    
    fileprivate func proceed() {
        let boundle = Boundle()
        boundle.putString(Extra.USER_CONSENT_NAME.key, self.fullName.textTrim)
        boundle.putDouble(Extra.USER_CONSENT_DATE.key, self.dateOfConsent!.timeInMillis)
        Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.ONBOARDING_LOCATION, boundle)
    }
    
    fileprivate func showQuestions() {
        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
        questionsCollectionView.flowLayout?.minimumLineSpacing = 0
        questionsCollectionView.flowLayout?.minimumInteritemSpacing = 0
        
        questionsCollectionView.fixIntrinsicContentSize = true
        questionsCollectionView.isScrollEnabled = false
        questionsCollectionView.refresh({ itemCount in
            var collectionViewHeight: CGFloat = 0
            for i in 0 ..< itemCount {
                collectionViewHeight += self.questionsCollectionView.getCellSize(self.questionsCollectionView.models[i] as! DBConsentQuestion).height
            }
            self.questionsHeightConstraint.constant = collectionViewHeight
        })
    }
    
    
    // MARK: keyboard methods
    
    public override func keyboardWillShow(_ keyboardFrame: CGRect) {
        bottomSafeAreaVerticalConstraint.constant = keyboardFrame.size.height
        bottomScrollVerticalConstraint.priority = UILayoutPriority(999)
        bottomSafeAreaVerticalConstraint.priority = UILayoutPriority(1000)
        if fullName.isFirstResponder {
            scrollView.scrollToView(fullName, false)
        }
    }
    
    public override func keyboardWillHide(_ keyboardFrame: CGRect) {
        bottomSafeAreaVerticalConstraint.priority = UILayoutPriority(999)
        bottomScrollVerticalConstraint.priority = UILayoutPriority(1000)
    }
    
    
    fileprivate func setSelectedTextField(_ textField: BaseTextField) {
        textField.borderColor =  ColorProvider.get("colorSecondaryAccent")
    }
    
    
    fileprivate func setTextFieldBackground(_ textField: BaseTextField) {
        textField.backgroundColor = ColorProvider.get("white")
        textField.borderColor =  ColorProvider.get("colorPrimaryDark")
        textField.borderWidth = 1
        textField.cornerRadius = 10
        textField.textColor = ColorProvider.get("textColorPrimaryDark")
        textField.colorPlaceholder = ColorProvider.get("textColorGray")!
    }
}


extension ConsentFormController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsCollectionView.getItemCount()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return questionsCollectionView.getCell(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let model = questionsCollectionView.models[indexPath.row] as! DBConsentQuestion
        model.checked = !model.checked
        questionsCollectionView.updateItem(model)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !fromMenu
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return !fromMenu
    }
}

extension ConsentFormController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = questionsCollectionView.models[indexPath.row] as! DBConsentQuestion
        return questionsCollectionView.getCellSize(model)
    }
}


extension ConsentFormController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        setSelectedTextField(textField as! BaseTextField)
        textField.setError(self.view, show: false)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setSelectedTextField(textField as! BaseTextField)
        checkTextField(textField, true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldBackground(textField as! BaseTextField)
        checkTextField(textField, true)
    }
    
    func checkTextField(_ textField: UITextField, _ show: Bool) {
        
        if textField == fullName {
            if !TextUtils.isEmpty(fullName.textTrim) {
                textField.setError(self.view, show: false)
            } else {
                textField.setError(self.view, message: StringProvider.get("value_not_set"), show: show)
            }
            return
        }
    }
    
    fileprivate func scheduleNotification() {
        // schedule notification only if it has not been scheduled before
        if TextUtils.isEmpty(Preferences.lifecycle.notificationScheduled) {
            let notificationToSchedule = NotificationType.HEALTH
            Preferences.lifecycle.notificationScheduled = notificationToSchedule.id
            let interval = Int((TimeUtils.ONE_DAY_MILLIS * 30) / TimeUtils.ONE_SECOND_MILLIS)
            NotificationManager.shared.scheduleNotification(interval: interval, notificationType: notificationToSchedule)
        }
    }
}
