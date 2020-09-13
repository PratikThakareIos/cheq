//
//  CommonEnums.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import Foundation

/// currency symbol enum for looking up pre-defined currency symbol character
enum CurrencySymbol: String {
    case dollar = "$"
}

/// enum of large category emoji icons
enum LargeCategoryEmoji: String {
    case benefits = "large/benefits"
    case billsUtilities = "large/billsUtilities"
    case employmentIncome = "large/employmentIncome"
    case entertainment = "large/entertainment"
    case financialServices = "large/financialServices"
    case fitness = "large/fitness"
    case groceries = "large/groceries"
    case health = "large/health"
    case homeFamily = "large/homeFamily"
    case ondemandIncome = "large/ondemandIncome"
    case other = "large/other"
    case otherDeposits = "large/otherDeposit"
    case restaurantsCafe = "large/restaurantsCafe"
    case secondaryIncome = "large/secondaryIncome"
    case shopping = "large/shopping"
    case tobaccoAlcohol = "large/tobaccoAlcohol"
    case transport = "large/transport"
    case travel = "large/travel"
    case work = "large/work"
}

/// enum of medium category emoji icons
enum MediumCategoryEmoji: String {
    case benefits = "medium/benefits"
    case billsUtilities = "medium/billsUtilities"
    case employmentIncome = "medium/employmentIncome"
    case entertainment = "medium/entertainment"
    case financialServices = "medium/financialServices"
    case fitness = "medium/fitness"
    case groceries = "medium/groceries"
    case health = "medium/health"
    case homeFamily = "medium/homeFamily"
    case ondemandIncome = "medium/ondemandIncome"
    case other = "medium/other"
    case otherDeposits = "medium/otherDeposit"
    case restaurantsCafe = "medium/restaurantsCafe"
    case secondaryIncome = "medium/secondaryIncome"
    case shopping = "medium/shopping"
    case tobaccoAlcohol = "medium/tobaccoAlcohol"
    case transport = "medium/transport"
    case travel = "medium/travel"
    case work = "medium/work"
}

/// enum of country code, add more country code here when needed 
enum CountryCode: String {
    case AU = "AU"
}

enum KycServiceProvider {
    case onfido
    case frankie
}

enum CashDirection {
    case debit
    case credit
}

enum cAgeRange: String {
    case age18to24 = "Aged 18 to 24"
    case age25to34 = "Aged 25 to 34"
    case age35to54 = "Aged 35 to 54"
    case age55To64 = "Aged 55 to 64"
    case over65 = "Aged 65 and over"
    
    init(fromRawValue: String) {
        self = cAgeRange(rawValue: fromRawValue) ?? .over65
    }
}

enum CountryState: String, CaseIterable {
    case NSW
    case ACT
    case QLD
    case TAS
    case NT
    case SA
    case VIC
    case WA
        
    var name: String {
        switch self {
        case .NSW:
            return "New South Wales (NSW)"
        case .ACT:
            return "Australian Capital Territory (ACT)"
        case .QLD:
            return "Queensland (NSW)"
        case .TAS:
            return "Tasmania (TAS)"
        case .NT:
            return "Northern Territory (NT)"
        case .SA:
            return "South Australia (SA)"
        case .VIC:
            return "Victoria (VIC)"
        case .WA:
            return "Western Australia (WA)"
        }
    }
    
    init(raw: String?) {
        self = CountryState(rawValue: raw ?? "") ?? .NSW
    }
}

enum Month: String, CaseIterable {
    
    case Jan
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dec
    
    var string: String {
        switch self {
        case .Jan: return "Jan"
        case .Feb: return "Feb"
        case .Mar: return "Mar"
        case .Apr: return "Apr"
        case .May: return "May"
        case .Jun: return "Jun"
        case .Jul: return "Jul"
        case .Aug: return "Aug"
        case .Sep: return "Sep"
        case .Oct: return "Oct"
        case .Nov: return "Nov"
        case .Dec: return "Dec"
        }
    }
    
    static let allStringValues = [Jan.string, Feb.string, Mar.string, Apr.string, May.string, Jun.string, Jul.string, Aug.string, Sep.string, Oct.string, Nov.string, Dec.string]
}

enum FinancialPeriod: CaseIterable {
    
    case month
    case quarterly
    case annually
    
    var string: String {
        switch self {
        case .month: return "Monthly"
        case .quarterly: return "Quarterly"
        case .annually: return "Annually"
        }
    }
    
    static let allStringValues = [month.string, quarterly.string, annually.string]
}



/// CONTENT_TYPE ///NNN

enum FirebaseEventContentType: String {
    case button = "Button"
    case screen = "Screen"
}


/// PassModuleScreen  ///NNN

enum PassModuleScreen: String {
    
    case Splash = "Splash"
    case Onboarding = "Onboarding"
    case Login = "Login"
    case PasswordRecovery = "Password recovery"
    case Spend = "Spend"
    case SpendingPredictedBills = "Spending - predicted bills"
    case SpendingMoneySpent = "Spending - Money spent"
    case SpendingActivity = "Spending - Activity"
    case SpendingMoneySpentDashboard = "Spending - Money spent dashboard"
    case SpendingMoneySpentCategoryClick = "Spending - Money spent category click"
    case SpendingMoneySpentCategoryDashboard = "Spending - Money spent category dashboard"
    case SpendingCategoryTransactionClick = "Spending - category transaction click"
    case BudgetSplash = "Budget splash"
    case BudgetSetupScreen1 = "Budget setup screen 1"
    case BudgetSetupScreen2 = "Budget setup screen 2"
    case Lending = "Lending"
    case Lend = "Lend"
    case Profile = "Profile"
    case Budget = "budget"
    case Menu = "Menu"
    
}


/// Firebase Event Key

enum FirebaseEventKey: String {
    
    case splash_budget = "splash_budget"
    case splash_spend = "splash_spend"
    case splash_lend = "splash_lend"
    case splash_lend_click = "splash_lend_click"
    
    case on_signup = "on_signup"
    case on_signup_fb_click = "on_signup_fb_click"
    case on_signup_click = "on_signup_click"
    case on_signup_TC = "on_signup_TC"
    case on_signup_PP = "on_signup_PP"
    case on_signup_login_click = "on_signup_login_click"
    case on_signup_everify = "on_signup_everify"
    case on_signup_everify_click = "on_signup_everify_click"
    case on_signup_everify_resend = "on_signup_everify_resend"
    case on_signup_passcode1 = "on_signup_passcode1"
    case on_signup_passcode2 = "on_signup_passcode2"
    case on_signup_name = "on_signup_name"
    case on_signup_name_click = "on_signup_name_click"
    case on_signup_mobile = "on_signup_mobile"
    case on_signup_mobile_click = "on_signup_mobile_click"
    case on_signup_bank = "on_signup_bank"
    case on_signup_bank_click = "on_signup_bank_click"
    case on_signup_bank_select = "on_signup_bank_select"
    case on_signup_bank_connect = "on_signup_bank_connect"
    
    case login_fb = "login_fb"
    case login_email = "login_email"
    case login_forgot_password_click = "login_forgot_password_click"
    case login_signup_click = "login_signup_click"
    
    case pass_home = "pass_home"
    case pass_email_click = "pass_email_click"
    case pass_reset_click = "pass_reset_click"
    case pass_reset_resend_click = "pass_reset_resend_click"
    case passcode_reset_click = "passcode_reset_click"
    
    case spend_dash = "spend_dash"
    case spend_bills_view = "spend_bills_view"
    case spend_bills_click = "spend_bills_click"
    case spend_spent_view = "spend_spent_view"
    case spend_spent_category = "spend_spent_category"
    case spend_activity_view = "spend_activity_view"
    case spend_activity_click = "spend_activity_click"
    case spend_spent_dash = "spend_spent_dash"
    case spend_spent_dash_category = "spend_spent_dash_category"
    case spend_spent_category_dash = "spend_spent_category_dash"
    case spend_spent_category_dash_click = "spend_spent_category_dash_click"
    
    case budget_splash = "budget_splash"
    case budget_splash_click = "budget_splash_click"
    case budget_setup1 = "budget_setup1"
    case budget_setup1_weekly = "budget_setup1_weekly"
    case budget_setup1_fortnightly = "budget_setup1_fortnightly"
    case budget_setup1_monthly = "budget_setup1_monthly"
    case budget_setup1_date = "budget_setup1_date"
    case budget_setup1_click = "budget_setup1_click"
    case budget_setup2 = "budget_setup2"
    case budget_setup2_toggle = "budget_setup2_toggle"
    case budget_setup2_amount = "budget_setup2_amount"
    case budget_setup2_complete = "budget_setup2_complete"
    case budget_dash = "budget_dash"
    case budget_dash_edit = "budget_dash_edit"
    case budget_edit_date = "budget_edit_date"
    case budget_edit_amounts = "budget_edit_amounts"
    case budget_dash_click = "budget_dash_click"
    
    case lend_dash_help = "lend_dash_help"
    case lend_dash_minus = "lend_dash_minus"
    case lend_dash_plus = "lend_dash_plus"
    
    case lend_workdetails_click = "lend_workdetails_click"
    case lend_workdetails_worktype = "lend_workdetails_worktype"
    case lend_workdetails_worktype_select = "lend_workdetails_worktype_select"
    case lend_workdetails_worktype_click = "lend_workdetails_worktype_click"
    case lend_workdetails_workname = "lend_workdetails_workname"
    case lend_workdetails_workname_click = "lend_workdetails_workname_click"
    case lend_workdetails_workaddress = "lend_workdetails_workaddress"
    case lend_workdetails_workaddress_click = "lend_workdetails_workaddress_click"
    case lend_workverify_screen_close = "lend_workverify_screen_close"
    
    
    case lend_bank_click = "lend_bank_click"
    case lend_bank_toggle = "lend_bank_toggle"
    case lend_bank_complete = "lend_bank_complete"
    case lend_KYC = "lend_KYC"
    case lend_KYC_name = "lend_KYC_name"
    case lend_KYC_name_click = "lend_KYC_name_click"
    case lend_KYC_addy = "lend_KYC_addy"
    case lend_KYC_addy_click = "lend_KYC_addy_click"
    case lend_KYC_ID = "lend_KYC_ID"
    case lend_KYC_ID_passport = "lend_KYC_ID_passport"
    case lend_KYC_ID_license = "lend_KYC_ID_license"
    case lend_KYC_ID_start = "lend_KYC_ID_start"
    case lend_KYC_ID_start_click = "lend_KYC_ID_start_click"
    case lend_KYC_addy_verify = "lend_KYC_addy_verify"
    case lend_dash_cashout = "lend_dash_cashout"
    case lend_cashout = "lend_cashout"
    
    case Lend_cashout_repayment_single = "Lend_cashout_repayment_single"
    case Lend_cashout_repayment_multiple = "Lend_cashout_repayment_multiple"
    case lend_cashout_TC = "lend_cashout_T&C"
    case lend_cashout_DD = "lend_cashout_DD"
    case lend_cashout_agree = "lend_cashout_agree"
    case lend_cashout_success_app = "lend_cashout_success_app"
    case lend_activity_cashout_tc = "lend_activity_cashout_t&c"
    case lend_activity_cashout_DD = "lend_activity_cashout_DD"
    
    case profile_home = "profile_home"
    case profile_help_click = "profile_help_click"
    case profile_help_tc = "profile_help_t&c"
    case profile_help_privacy = "profile_help_privacy"
    
    case menu_spend = "menu_spend"
    case menu_budget = "menu_budget"
    case menu_lend = "menu_lend"
    case menu_profile = "menu_profile"
    
}


enum FacebookEventConstants: String {
    
    case SOURCE = "SOURCE"
    case ITEM_ID = "ITEM_ID"
    case ITEM_NAME = "ITEM_NAME"
    case CONTENT_TYPE = "CONTENT_TYPE"
    case CHEQ_FB_EVENT = "CHEQ_FB_EVENT"
    
}


enum FacebookEventKey: String {
    
    case lend_cashout_agree = "lend_cashout_agree"
    case lend_cashout_success_app = "lend_cashout_success_app"
    
}


enum IDFA_FacebookAttributionKey: String {
    
    case fb_app_attribution = "fb_app_attribution"
    case IDFA = "IDFA"
    case IDFA_Facebook_Attribution = "IDFA_Facebook_Attribution"
}
