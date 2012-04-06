#
#  AppDelegate.rb
#  Synchrocorder
#
#  Created by Brian Anderson on 4/4/12.
#  Copyright 2012 Aeroflex. All rights reserved.
#
class AppDelegate
    
    attr_accessor :window 
    attr_accessor :presentationImageField, :presentationApplicationLabel, :presentationApplicationStatus
    attr_accessor :recordingImageField, :recordingApplicationLabel, :recordingApplicationStatus
    
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
        puts "loading!"
        @presentationObserver = nil
        #@presentationImageField.setImage(NSImage.alloc.initByReferencingURL(NSURL.alloc.initWithString("x_24.png")))
        @presentationImageField.setImage(NSImage.imageNamed("x_24.png"))
        #@presentationImageField.setImage("x_24.png")
        #@recordingImageField.setImage("Resources/x_24.png")
        startDiscoveryTimer(5)
        checkPresentationStatus
        checkRecordingStatus
        @presentationReady = false
        @recordingReady = false

    end
    
    def startDiscoveryTimer(frequency)
        @discoveryTimer = NSTimer.scheduledTimerWithTimeInterval(frequency,
                                                        target: self,
                                                        selector: "discoveryTimerHandler:",
                                                        userInfo: nil,
                                                        repeats: true)
    end
    
    def stopDiscoveryTimer
        puts "Stopping Timer"
        if(@discoveryTimer && @discoveryTimer.isValid)
            @discoveryTimer.invalidate()
        end
    end
    
    def startPauseRecording(sender)
    end
    
    def stopRecording(sender)
    end
    
    def discoveryTimerHandler(userInfo)
        if(@presentationReady && @recordingReady)
            stopDiscoveryTimer()
        else
            checkPresentationStatus
            checkRecordingStatus
        end
    end
    
    def checkRecordingStatus
        @recordingApplicationLabel.setStringValue("Waiting...")
        @recordingApplicationStatus.setStringValue("...for SoundStudio to launch")
        @recordingImageField.setImage(NSImage.imageNamed("x_24.png"))
        @recordingReady = true
    end
    
    def checkPresentationStatus
        # initialize if we need to
        
        @presentationObserver = PresentationObservation::Discover.getPresentationObserver(nil)
        
        # if initialzed then poll..
        if(!@presentationObserver.nil?)
            @presentationImageField.setImage(NSImage.imageNamed("check_24.png"))
            @presentationApplicationLabel.setStringValue("Observing " + @presentationObserver.getApplicationName())
            if(@presentationObserver.hasPresentationOpen?)
                @presentationApplicationStatus.setStringValue("Presentation: #{@presentationObserver.getPresentationName()}")
                @presentationReady = true
            end
        else
            @presentationImageField.setImage(NSImage.imageNamed("x_24.png"))
            @presentationApplicationLabel.setStringValue("Waiting...")
            @presentationApplicationStatus.setStringValue("...for PowerPoint or Keynote to Launch")
        end
    end
    
end

