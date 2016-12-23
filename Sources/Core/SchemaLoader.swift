//
//  SchemaLoader.swift
//  pinmodel
//
//  Created by Andrew Chun on 6/17/16.
//  Copyright © 2016 Rahul Malik. All rights reserved.
//

import Foundation

protocol SchemaLoader {
    func loadSchema(_ schemaUrl: URL) -> Schema?
}

class RemoteSchemaLoader: SchemaLoader {
    static let sharedInstance = RemoteSchemaLoader()
    static let sharedPropertyLoader = Schema.propertyFunctionForType(loader: RemoteSchemaLoader.sharedInstance)
    var refs: [URL:Schema]

    init() {
        self.refs = [URL:Schema]()
    }

    func loadSchema(_ schemaUrl: URL) -> Schema? {
        if let cachedValue = refs[schemaUrl] {
            return cachedValue
        }
        print(schemaUrl)
        // Load from local file
        do {
        
            if let data = try? Data(contentsOf: URL(fileURLWithPath: schemaUrl.path)) {
                print("Parse data")

                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONObject

                let x = RemoteSchemaLoader.sharedPropertyLoader(jsonResult, schemaUrl)
                assert(x != nil, "what")
                refs[schemaUrl] = x
                return refs[schemaUrl]
            } else {
                print("Failed to parse data")
            }
        } catch {
            // TODO: Better failure handling and reporting
            // https://phabricator.pinadmin.com/T49
            assert(false, "WTF")
        }
        assert(false, "WTF")
        print("P")
        return nil
    }
}