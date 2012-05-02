#
#  ExportController.rb
#  Synchrocorder
#
#  Created by Brian Anderson on 5/1/12.
#  Copyright 2012 Aeroflex. All rights reserved.
#


class ExportController < NSWindowController
    attr_accessor :window 
    attr_accessor :export
    
    NIB_NAME = "ExportWindow"
    
    def self.prepareForExport(parentWindow)
        controller = alloc.init()
        NSApp.beginSheet( controller.window,
                          modalForWindow:parentWindow,
                          modalDelegate:self,
                          didEndSelector:"done:",
                          contextInfo:nil
                        )
    end

    def init
        initWithWindowNibName(NIB_NAME)
        NSLog("Inited")
        self
    end
        
    def awakeFromNib
    end
    
    def cancel(sender)
        closeWindow
    end
    
#    def sheetDidEnd(sheet, returnCode:code, contextInfo:info)
#        sheet.orderOut(nil)
#    end

    def done
        NSLog("Closing!")
    end
    
    private
    def closeWindow
        NSApp.endSheet(window)
    end
    
end
