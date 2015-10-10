//
//  Contact.swift
//  HandoffDemo
//
//  Created by Gabriel Theodoropoulos on 17/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit
import Foundation


class Contact: NSObject {
    
    var firstname: String?
    var lastname: String?
    var phoneNumber: String?
    var email: String?
    let documentsDirectory: String?
    
    override init() {
        let pathsArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        documentsDirectory = pathsArray[0] as String
    }
    
    func loadContacts() -> NSMutableArray {
//        let contactsFilePath = documentsDirectory?.stringByAppendingPathComponent("contacts")
        let contactsFilePath = documentsDirectory?.stringByAppendingString("contacts")
        
        let allContacts = NSMutableArray()
        
        if NSFileManager.defaultManager().fileExistsAtPath(contactsFilePath!) {
            let savedContactsArray = NSMutableArray(contentsOfFile: contactsFilePath!)

            for var i=0; i<savedContactsArray?.count; ++i{
                let tempContact = Contact()
                tempContact.getContactDataFromDictionary(savedContactsArray?.objectAtIndex(i) as! Dictionary<NSObject, AnyObject>)
                allContacts.addObject(tempContact)
            }
        }
        
        return allContacts
    }
    
    
    func saveContact() {
        let contactsFilePath = documentsDirectory?.stringByAppendingString("contacts")

        let allContacts = loadContacts()
        
        allContacts.addObject(self)
        
        let allContactsConverted = NSMutableArray()
        
        for var i=0; i<allContacts.count; ++i{
            allContactsConverted.addObject(allContacts.objectAtIndex(i).getDictionaryFromContactData())
        }
        
        allContactsConverted.writeToFile(contactsFilePath!, atomically: false)
    }
    
    
    class func updateSavedContacts(contacts: NSMutableArray) {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        let contactsFilePath = documentsDirectory.stringByAppendingString("contacts")
        
        let contactsConverted = NSMutableArray()
        
        for var i=0; i<contacts.count; ++i{
            contactsConverted.addObject(contacts.objectAtIndex(i).getDictionaryFromContactData())
        }
        
        contactsConverted.writeToFile(contactsFilePath, atomically: true)
    }
    
    
    func getDictionaryFromContactData() -> Dictionary<String, String> {
        let dictionary: [String: String] = ["firstname": firstname!, "lastname": lastname!, "phonenumber": phoneNumber!, "email": email!]
        
        return dictionary
    }
    
    
    func getContactDataFromDictionary(dictionary: Dictionary<NSObject, AnyObject>) {
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
        phoneNumber = dictionary["phonenumber"] as? String
        email = dictionary["email"] as? String
    }
    
}
