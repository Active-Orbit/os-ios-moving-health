//
//  PatientDetailsController.swift
//  BaseApp
//
//  Created by Omar Brugna on 04/07/2023.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import CBPinEntryView
import Tracker

class PatientDetailsController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var mainView: BaseView!
    @IBOutlet var nhsNumberTitle: BaseLabel!
    @IBOutlet var insertIdEntryView: CBPinEntryView!
    @IBOutlet var btnNhsUrl: BaseButton!
    @IBOutlet var firstName: BaseTextField!
    @IBOutlet var lastName: BaseTextField!
    @IBOutlet var btnDateBirth: ButtonComponent!
    @IBOutlet var btnSexSelection: ButtonComponent!
    @IBOutlet var postcode: BaseTextField!
    @IBOutlet var email: BaseTextField!
    @IBOutlet var phone: BaseTextField!
    @IBOutlet var stepOne: BaseView!
    @IBOutlet var stepTwo: BaseView!
    @IBOutlet var stepThree: BaseView!
    @IBOutlet var stepFour: BaseView!
    @IBOutlet var backBtn: BaseButton!
    @IBOutlet var nextBtn: BaseButton!
    @IBOutlet var saveBtn: BaseButton!
    @IBOutlet var scrollView: BaseScrollView!
    @IBOutlet var stepsLayout: UIView!
    @IBOutlet var buttonsLayout: UIView!
    
    @IBOutlet var bottomLayout: BaseView!
    @IBOutlet var bottomScrollVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var bottomSafeAreaVerticalConstraint: NSLayoutConstraint!
    
    fileprivate var nhsNumber: String?
    fileprivate var sex: SexModel?
    fileprivate var dateOfBirth: Date?
    fileprivate var userConsentName = Constants.EMPTY
    fileprivate var userConsentDate = Double(Constants.INVALID)
    
    
    fileprivate var fromMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        fromMenu = controllerBoundle.getBoolean(Extra.FROM_MENU.key)
        
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
    
    fileprivate func prepare() {
        
        mainView.cornerRadius = 16
        stepOne.cornerRadius = 5
        stepTwo.cornerRadius = 5
        stepThree.cornerRadius = 5
        stepFour.cornerRadius = 5
        
        insertIdEntryView.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        postcode.delegate = self
        email.delegate = self
        phone.delegate = self
        
        setTextFieldBackground(firstName)
        setTextFieldBackground(lastName)
        setTextFieldBackground(postcode)
        setTextFieldBackground(email)
        setTextFieldBackground(phone)
        
        
        btnSexSelection.setText(StringProvider.get("select"))
        btnDateBirth.setText(StringProvider.get("select"))
        
        
        
        
        if fromMenu {
            nhsNumberTitle.text = StringProvider.get("patient_id")
            insertIdEntryView.disableEntries()
            insertIdEntryView.setPin(Preferences.user.userNhsNumber ?? Constants.EMPTY)
            insertIdEntryView.setOnClickListener(target: self, listener: #selector(onInsertIdEntryViewClicked))
            let sexModel = SexModel(Preferences.user.userSex!)
            self.sex = sexModel
            btnSexSelection.setText(Preferences.user.userSex)
            
            firstName.isEnabled = false
            lastName.isEnabled = false
            postcode.isEnabled = false
            email.isEnabled = false
            phone.isEnabled = false
            
            firstName.text = Preferences.user.userFirstName
            lastName.text = Preferences.user.userLastName
            postcode.text = Preferences.user.userPostcode
            
            if Preferences.user.userEmail != Constants.EMPTY {
                email.text = Preferences.user.userEmail
            } else {
                email.localizedPlaceholder = "email_address_hint"
            }
            
            if Preferences.user.userPhone != Constants.EMPTY {
                phone.text = Preferences.user.userPhone
            } else {
                phone.localizedPlaceholder = "email_address_hint"
            }
            
            
            dateOfBirth = Preferences.user.userDateOfBirth
            btnDateBirth.label.text = TimeUtils.format(dateOfBirth!, Constants.DATE_FORMAT_DAY_MONTH_YEAR, convertToDefault: false)
            
            btnNhsUrl.visibility = .gone
            stepsLayout.visibility = .gone
            buttonsLayout.visibility = .gone
            backBtn.visibility = .gone
            nextBtn.visibility = .gone
            saveBtn.visibility = .gone
            
            saveBtn.setOnClickListener {
                self.hideKeyboard()
                if !TextUtils.isEmpty(self.firstName.textTrim)
                    && !TextUtils.isEmpty(self.lastName.textTrim)
                    && self.dateOfBirth != nil
                    && self.sex != nil
                    && Validator.validatePostcode(self.postcode.textTrim)
                    && (Validator.validateMail(self.email.textTrim) || Validator.validatePhone(self.phone.textTrim)) {
                    
                    Preferences.user.userFirstName = self.firstName.textTrim
                    Preferences.user.userLastName = self.lastName.textTrim
                    Preferences.user.userDateOfBirth = self.dateOfBirth
                    Preferences.user.userSex = self.sex!.sex
                    Preferences.user.userPostcode = self.postcode.textTrim
                    Preferences.user.userEmail = self.email.textTrim
                    Preferences.user.userPhone = self.phone.textTrim
                    
                    Toast.showShortToast(self.view, StringProvider.get("success"))
                    
                    self.finish()
                    
                } else {
                    Toast.showShortToast(self.view, StringProvider.get("error_patient_details"))
                }
            }
            
        } else {
            
            userConsentName = controllerBoundle.getString(Extra.USER_CONSENT_NAME.key)!
            userConsentDate = controllerBoundle.getDouble(Extra.USER_CONSENT_DATE.key)
            
            
            btnNhsUrl.visibility = .visible
            stepsLayout.visibility = .visible
            buttonsLayout.visibility = .visible
            
            backBtn.visibility = .visible
            nextBtn.visibility = .visible
            saveBtn.visibility = .invisible
            
            btnNhsUrl.setOnClickListener {
                Router.instance
                    .controllerTransition(.BOTTOM_TO_TOP)
                    .startWebView(self, StringProvider.get("find_nhs_number_link_default"), self.btnNhsUrl.mTitle.text!)
            }
            
            backBtn.setOnClickListener {
                self.finish()
            }
            
            nextBtn.setOnClickListener {
                if !TextUtils.isEmpty(self.nhsNumber)
                    && !TextUtils.isEmpty(self.firstName.textTrim)
                    && !TextUtils.isEmpty(self.lastName.textTrim)
                    && self.dateOfBirth != nil && self.sex != nil
                    && Validator.validatePostcode(self.postcode.textTrim)
                    && (Validator.validateMail(self.email.textTrim) || Validator.validatePhone(self.phone.textTrim)) {
                    
                    if !Validator.validateNhsNumber(self.nhsNumber) {
                        Toast.showShortToast(self.view, "NHS number is not valid")
                    } else {
                        self.register()
                    }
                } else {
                    Toast.showShortToast(self.view, StringProvider.get("error_patient_details"))
                }
            }
            
            btnDateBirth.setOnClickListener {
                let dialog = DatePickerDialog()
                if self.dateOfBirth != nil {
                    dialog.setDate(date: self.dateOfBirth!)
                }
                dialog.setCancelable(true)
                dialog.setConfirmListener { date in
                    Logger.d("Selected birthday is \(date)")
                    
                    let ageInMillis = TimeUtils.getCurrent().timeInMillis - date.timeInMillis
                    let age = ageInMillis / Double(TimeUtils.ONE_DAY_MILLIS) / 365
                    
                    
                    if age >= 18 {
                        self.btnDateBirth.label.text = TimeUtils.format(date, Constants.DATE_FORMAT_DAY_MONTH_YEAR, convertToDefault: true)
                        self.dateOfBirth = date
                    } else {
                        self.dateOfBirth = nil
                        Toast.showLongToast(self.view, "Age of 18 and above is required")
                    }
                }
                dialog.show()
            }
            
            btnSexSelection.setOnClickListener {
                let dialog = SelectSexDialog()
                dialog.setCancelable(true)
                dialog.setConfirmListener { sex in
                    Logger.d("Selected sex is \(sex)")
                    self.btnSexSelection.label.text = sex
                    self.sex = SexModel(sex)
                }
                dialog.show()
            }
        }
    }
    
    
    // MARK: keyboard methods
    
    public override func keyboardWillShow(_ keyboardFrame: CGRect) {
        bottomSafeAreaVerticalConstraint.constant = keyboardFrame.size.height
        bottomScrollVerticalConstraint.priority = UILayoutPriority(999)
        bottomSafeAreaVerticalConstraint.priority = UILayoutPriority(1000)
        if firstName.isFirstResponder {
            scrollView.scrollToView(firstName, false)
        } else if lastName.isFirstResponder {
            scrollView.scrollToView(lastName, false)
        } else if postcode.isFirstResponder {
            scrollView.scrollToView(postcode, false)
        } else if email.isFirstResponder {
            scrollView.scrollToView(email, false)
        } else if phone.isFirstResponder {
            scrollView.scrollToView(phone, false)
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
    
    fileprivate func register() {
        showProgressView()
        
        let request = UserRegistrationRequest()
        request.phoneModel = Utils.getPhoneModel()
        request.appVersion = Utils.getAppVersion()
        request.androidVersion = Utils.getIosVersion()
        request.userNhsNumber = Int(nhsNumber!)
        request.userFirstName = firstName.textTrim
        request.userLastName = lastName.textTrim
        request.userSex = sex?.sex
        request.userPostcode = postcode.textTrim
        request.userEmail = email.textTrim
        request.userPhoneNumber = phone.textTrim
        request.userDob = dateOfBirth?.timeInMillis
        request.registrationTimestamp = TimeUtils.getCurrent().timeInMillis
        request.userConsentName = userConsentName
        request.userConsentDate = userConsentDate
        request.userIPAddress = "123.123.123.123"
        
//        let ipAddress = Utils.getLocalIPAddress() ?? "123.123.123.123"
//        if Utils.validateIpAddress(ipAddress) {
//            request.userIPAddress = ipAddress
//        } else {
//            request.userIPAddress = "123.123.123.123"
//        }
        
        UserManager.registerUser(self, request, self)
    }
    
    @objc fileprivate func onInsertIdEntryViewClicked() {
        Toast.showShortToast(self.view, "NHS number cannot change")
    }
}


extension PatientDetailsController: UserRegistrationListener {
    
    func onSuccess(_ request: UserRegistrationRequest, _ map: UserRegistrationMap) {
        completeRegistration(map)
        
        // Use this if needed
        /*
        if Int(map.dataItem!.participantIdCounter!.counter)! > 1 {
            Logger.d("Already existing user with patient id \(nhsNumber!), ask for confirmation")
            let dialog = ConfirmRegistrationDialog()
            dialog.setCancelable(false)
            dialog.setConfirmListener {
                self.completeRegistration(map)
            }
            dialog.setCancelListener {
                self.finish()
            }
            dialog.show()
        } else {
            completeRegistration(map)
        }
        */
    }
    
    func onError(message: String) {
        hideProgressView()
        Toast.showShortToast(self.view, message)
    }
    
    fileprivate func completeRegistration(_ map: UserRegistrationMap) {
        hideProgressView()
        Logger.d("User successfully registered with id \(map.dataItem!.userId!.id)")
        Preferences.user.idUser = map.dataItem!.userId!.id
        Preferences.user.userNhsNumber = nhsNumber
        Preferences.user.userFirstName = firstName.textTrim
        Preferences.user.userLastName = lastName.textTrim
        Preferences.user.userDateOfBirth = dateOfBirth
        Preferences.user.userSex = sex?.sex
        Preferences.user.userPostcode = postcode.textTrim
        Preferences.user.userEmail = email.textTrim
        Preferences.user.userPhone = phone.textTrim
        Preferences.user.userConsentDate = Date(timeInMillis: userConsentDate)
        Preferences.user.userConsentName = userConsentName
        
        // automatically start the study
        Preferences.user.studyStarted = true
        Preferences.user.dateStudyStarted = TimeUtils.getCurrent()
        
        // check registration with the server
        TrackerManager.instance.saveUserRegistrationId(map.dataItem!.userId!.id, overrideFirstInstall: true)
        
        let boundle = Boundle()
        boundle.putInt(Extra.SUCCESS_MESSAGE.key, SuccessMessageType.REGISTRATION.id)
        Router.instance
            .controllerTransition(.BOTTOM_TO_TOP)
            .startBaseController(self, Controllers.SUCCESS_MESSAGE, boundle)
    }
}

extension PatientDetailsController: CBPinEntryViewDelegate {
    
    func entryChanged(_ completed: Bool) {
        if !completed { nhsNumber = nil }
    }
    
    func entryCompleted(with entry: String?) {
        nhsNumber = entry
    }
}

extension PatientDetailsController: UITextFieldDelegate {
    
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
        
        if textField == firstName {
            if !TextUtils.isEmpty(firstName.textTrim) {
                textField.setError(self.view, show: false)
            } else {
                textField.setError(self.view, message: StringProvider.get("value_not_set"), show: show)
            }
            return
        }
        
        if textField == lastName {
            if !TextUtils.isEmpty(lastName.textTrim) {
                textField.setError(self.view, show: false)
            } else {
                textField.setError(self.view, message: StringProvider.get("value_not_set"), show: show)
            }
            return
        }
        
        if textField == postcode {
            if !TextUtils.isEmpty(postcode.textTrim) {
                if !Validator.validatePostcode(postcode.textTrim) {
                    textField.setError(self.view, message: StringProvider.get("value_not_admissible_postcode"), show: show)
                } else {
                    textField.setError(self.view, show: false)
                }
            } else {
                textField.setError(self.view, message: StringProvider.get("value_not_set"), show: show)
            }
            return
        }
        
        if textField == email {
            if !TextUtils.isEmpty(email.textTrim) {
                if !Validator.validateMail(email.textTrim) {
                    textField.setError(self.view, message: StringProvider.get("value_not_admissible_email"), show: show)
                } else {
                    textField.setError(self.view, show: false)
                }
            }
            return
        }
        
        if textField == phone {
            if !TextUtils.isEmpty(phone.textTrim) {
                if !Validator.validatePhone(phone.textTrim) {
                    textField.setError(self.view, message: StringProvider.get("value_not_admissible_phone"), show: show)
                } else {
                    textField.setError(self.view, show: false)
                }
            }
            return
        }
        
        
    }
}

