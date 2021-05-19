//
//  ErrorMessages.swift
//  User
//
//  Created by CSS on 11/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct ErrorMessage {
    
    static let list = ErrorMessage()
    
    let serverError = "Server Could not be reached. \n Try Again"
    let notReachable = "The Internet connection appears to be offline."
    let enterEmail = "Enter Email Id"
    let enterValidEmail = "Enter Valid Email Id"
    let enterPassword = "Enter Password"
    let enterConfirmPassword = "Enter Confirm Password"
    let correctPassowrd = "Please Enter correct password"
    let enterName = "Enter Name"
    let enterLastName = "Enter Last Name"
    let enterPhoneNumber = "Enter Phone Number"
    let vehiclePhotoIsEmpty = "Attach vehicle Photo"
    let enterDriverLicence = "Attach Drriver License"
    let enterVehicleMake = "Enter vehicle Make"
    let enterVehicleModel = "Enter vehicle Model"
    let enterVehicleColor = "Enter vehicle Color"
    let enterPlateNumber = "Enter License plate Number"
    let enterCity = "Enter city"
    let enterCarCategory = "Enter Car Category"
    let selectTriptype = "Select Trip Type"
    let selectOutStationType  = "Select Out Station Type"
    let agreeTheTerms = "Agree The Terms and Condition"
    let enterOTP = "Enter OTP"
    let enterNewPwd = "Enter New Password"
    let enterOldPassword = "Enter Old Password"
    let enterConfirmPwd = "Enter Confirm Password"
    let EnterCountry = "Enter Country code"
    let enterAreaCode = "Enter Area Code"
    let enterTimeZone = "Enter Time Zone"
    let enterReferralCode = "Enter referral Code"
    
    let enterCurrentPassword = "Enter Current Password"
    let enterNewPassword = "Enter New Password"
    let misMatch = "Password Mismatch"
    let gtwoError = "Please check the otp, and try again..."
    let wrongPinMessage = "Pin didn't match. Try again."
    let enterAmount = "Enter Amount"
    let enterpaymentMode = "Enter payment mode"
    let enterAddress = "Enter Address"
    
}

struct SuccessMessage {

static let string = SuccessMessage()
  let loginSucess = "Login Successfully"
  let emailVerifySuccess = "Verification Mail Sent. Please verify to login"
  let logoutMsg = "Logout Successfully"
    let gTwoEnable = "G2F enabled"
}
