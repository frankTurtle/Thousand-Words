//
//  CoreDataHelper.m
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

+(NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = nil; //.......................... variable to hold the context
    
    id delegate = [[UIApplication sharedApplication] delegate]; //..... gets the shared delegate for the app
    
    if ([delegate performSelector:@selector(managedObjectContext)]) //. testing to make sure the delegate responds to the message managedObjectContext
        context = [delegate managedObjectContext]; //.................. set context
    
    return context;
}

@end
