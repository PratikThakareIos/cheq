//
//  ConnectingToBankViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 28/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

/// ViewModel for **ConnectingToBankViewController**. Add more variables when needed 
class ConnectingToBankViewModel {
    
    var jobId : String = ""
    var dynamicTimeInterval: Double = 15.0
    var count = 0
    
    func checkConnectionJobStatus() -> Promise<GetConnectionJobResponse> {
        return Promise<GetConnectionJobResponse>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser -> Promise<GetConnectionJobResponse> in
                return  CheqAPIManager.shared.getBasiqConnectionJobStatus(jobId: self.jobId)
            }.done { getConnectionJobResponse  in
                LoggingUtil.shared.cPrint("getConnectionJobResponse = \(getConnectionJobResponse)")
                resolver.fulfill(getConnectionJobResponse)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func nextViewController(){
        var vcInfo = [String: String]()
        vcInfo[NotificationUserInfoKey.storyboardName.rawValue] = StoryboardName.main.rawValue
        vcInfo[NotificationUserInfoKey.storyboardId.rawValue] = MainStoryboardId.tab.rawValue
        NotificationUtil.shared.notify(UINotificationEvent.switchRoot.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: vcInfo)
    }
    
      //getJobConnectionStatus
      func checkJobStatus(_ completion: @escaping (Result<Bool>)->Void) {
          
          if AppData.shared.connectionJobStatusReady {
              completion(.success(true))
          } else {
              
              if self.count == 0 {
                  self.dynamicTimeInterval = 1.0
              }
             
              if self.count == 1 || self.count == 2 {
                  self.dynamicTimeInterval = 15.0
              }
              
              if self.count == 3 || self.count == 4 {
                  self.dynamicTimeInterval = 10.0
              }else{
                  self.dynamicTimeInterval = 5.0
              }
    
              DispatchQueue.main.asyncAfter(deadline: .now() + self.dynamicTimeInterval) {

                   self.checkConnectionJobStatus().done { getConnectionJobResponse in
                     
                      LoggingUtil.shared.cPrint("\n getConnectionJobResponse = \(getConnectionJobResponse)")
                      
                      guard getConnectionJobResponse.stepStatus != GetConnectionJobResponse.StepStatus.failed  else {
                         let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey:  getConnectionJobResponse.errorDetail]) as Error
                         completion(.failure(error))
                         return
                      }
                    AppData.shared.connectionJobStatusReady = self.manageConectionJobStatus(res: getConnectionJobResponse)
                      self.checkJobStatus(completion)
                  }.catch { err in
                      LoggingUtil.shared.cPrint(err)
                      completion(.failure(err))
                  }
              }
          }
      }
    

    func manageConectionJobStatus(res: GetConnectionJobResponse) -> Bool {
                 LoggingUtil.shared.cPrint("\n manageConectionJobStatus Called")
                /*
                ConnectionStep

                VerifyingCredentials: logging into user’s internet bank
                RetrievingAccounts: getting financial account info
                RetrievingTransactions: getting financial transactions info
                Categorisation: processing financial transactions

                ConnectionStepStatus

                checkSpendingStatus API
                Pending
                InProgress
                Failed: failed, ask users to try again, show the error message based on

                ErrorTitle
                ErrorDetail

                Success: can look at the Categorisation status now.

                CategorizingTransactionStatus = Ready, you can navigating to spending dashboard page.
         
                */
                
        //        public enum Step: String, Codable {
        //            case verifyingCredentials = "VerifyingCredentials"
        //            case retrievingAccounts = "RetrievingAccounts"
        //            case retrievingTransactions = "RetrievingTransactions"
        //            case categorisation = "Categorisation"
        //        }
        //        public enum StepStatus: String, Codable {
        //            case pending = "Pending"
        //            case inProgress = "InProgress"
        //            case failed = "Failed"
        //            case success = "Success"
        //        }
        //        public enum ModelError: String, Codable {
        //            case invalidCredentials = "InvalidCredentials"
        //            case actionRequiredByBank = "ActionRequiredByBank"
        //            case maintenanceError = "MaintenanceError"
        //            case temporaryUnavailable = "TemporaryUnavailable"
        //        }
        //        public var institutionId: String?
        //        public var step: Step?
        //        public var stepStatus: StepStatus?
        //        public var error: ModelError?
        //        public var errorTitle: String?
        //        public var errorDetail: String?
                
                
    //            guard res.stepStatus != GetConnectionJobResponse.StepStatus.failed  else {
    //                LoggingUtil.shared.cPrint("\n manageConectionJobStatus GetConnectionJobResponse.StepStatus.failed")
    //                LoggingUtil.shared.cPrint("\n res.errorTitle = \(res.errorTitle)")
    //                LoggingUtil.shared.cPrint("\n res.errorDetail = \(res.errorDetail)")
    //                return false
    //            }

            
                NotificationUtil.shared.notify(UINotificationEvent.basiqEvent.rawValue, key: NotificationUserInfoKey.basiqProgress.rawValue, object: res.step)
        
                switch res.step {
                case .verifyingCredentials:
                        LoggingUtil.shared.cPrint("Connecting to <bank name> ...") //25%
                        return false
                case .retrievingAccounts:
                        LoggingUtil.shared.cPrint("Retrieving statements from bank...") //50%
                        return false
                case .retrievingTransactions:
                        LoggingUtil.shared.cPrint("Analysing your bank statement...") //70
                        return false
                case .categorisation:
                        LoggingUtil.shared.cPrint("Categorising your transactions...") //80
                        if (res.stepStatus == GetConnectionJobResponse.StepStatus.success){
                            return true
                        }else{
                            return false
                        }
                default:
                       LoggingUtil.shared.cPrint("manageConectionJobStatus - Something went wrong")
                       return false
                }
                        
      }
    
}
