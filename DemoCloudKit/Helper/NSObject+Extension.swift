//
//  NSObject+Extension.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 24/02/22.
//
import Foundation
import ObjectiveC.NSObjCRuntime

typealias BlockVoid  = () -> Void
typealias BlockChangesResult = (_ result: NSArray, _ type: NSManagedObjectChangeType) -> Void

enum NSManagedObjectChangeType: Int {
    case insert
    case update
    case delete
    case all
}

/// NSObject associated object
public extension NSObject {
    
    /// keys
    private struct AssociatedKeys {
        static var descriptiveName = "associatedObject"
    }
    
    /// set associated object
    @objc func setAssociated(object: Any) {
        objc_setAssociatedObject(self, &AssociatedKeys.descriptiveName, object, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// get associated object
    @objc func associatedObject() -> Any? {
        return objc_getAssociatedObject(self, &AssociatedKeys.descriptiveName)
    }
}


class MultiCastDelegate: NSObject {
    
    var _delegates = NSMutableArray()
    
    func add(delegate: AnyObject) -> Void {
        
        if (!_delegates.contains(delegate)) {
            _delegates.add(delegate)
        }
    }
    
    func remove(delegate: AnyObject) -> Void {
        if (_delegates.contains(delegate)) {
            _delegates.remove(delegate)
        }
    }
    
    override func responds(to aSelector: Selector) -> Bool {
        
        if (super.responds(to: aSelector)) {
            return true
        }
        
        for delegate in _delegates {
            if ((delegate as AnyObject).responds(to: aSelector)) {
                return true
            }
        }
        return false
    }
}

extension NSObject {
    
    // MARK:- Property -
    
    func isNull() -> Bool {
        
        if (self.isEqual(NSNull()) || self is NSNull) {
            return true
        }
        
        if (self is String) {
            if ((self as! String).count == 0) {
                return true
            }
        }
        
        if (self is NSArray) {
            if ((self as! NSArray).count == 0) {
                return true
            }
        }
        
        if (self is NSDictionary) {
            if ((self as! NSDictionary).count == 0) {
                return true
            }
        }
        
        return false
    }
    
    func performBlock(block: @escaping BlockVoid) -> Void {
        DispatchQueue.main.async {
            block()
        }
    }
    
    func performBlockOnMainThread(block: @escaping BlockVoid) -> Void {
        DispatchQueue.main.async {
            block()
        }
    }
    
    /**
     Method from NSObject Extension
     */
    
    func set(object anObj: AnyObject?, forKey: UnsafeRawPointer) -> Void {
        objc_setAssociatedObject(self, forKey, anObj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /**
     Method from NSObject Extension
     */
    
    func object(forKey key: UnsafeRawPointer) -> AnyObject? {
        return objc_getAssociatedObject(self, key) as AnyObject
    }
    
    // (Int)integer
    
    func set(Int integerValue: Int, key: UnsafeRawPointer) -> Void {
        self.set(object: NSNumber(value: integerValue as Int), forKey: key)
    }
    
    func int(forKey key: String) -> Int {
        return self.object(forKey: key)!.intValue
    }
    
    // (float)floatValue
    
    func set(Float floatValue:Float, key:UnsafeRawPointer) -> Void {
        self.set(object: NSNumber(value: floatValue as Float), forKey: key)
    }
    
    func float(forKey key: String) -> Float {
        return self.object(forKey: key)!.floatValue
    }
    
    // (double)doubleValue
    
    func set(Double doubleValue: Double, key: UnsafeRawPointer) -> Void {
        self.set(object: NSNumber(value: doubleValue as Double), forKey: key)
    }
    
    func double(forKey key: String) -> Double {
        return self.object(forKey: key)!.doubleValue
    }
    
    // (BOOL)boolean
    
    func set(Bool boolValue: Bool, key: UnsafeRawPointer) -> Void {
        self.set(object: NSNumber(value: boolValue as Bool), forKey: key)
    }
    
    func boolean(forKey key: String) -> Bool {
        return self.object(forKey: key)!.boolValue
    }
}
