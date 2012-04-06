//
//  main.m
//  Synchrocorder
//
//  Created by Brian Anderson on 4/4/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
