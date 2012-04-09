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
    attr_accessor :recordingImageField,    :recordingApplicationLabel,    :recordingApplicationStatus
    
    attr_accessor :startRecordingButton
    attr_accessor :stopRecordingButton
    
    ERROR_ICON =    "x_24.png"
    WARNING_ICON =  "warn_24.png"
    GOOD_ICON =     "check_24.png"
    
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
        puts "loading!"
        @presentationObserver = nil
        @recordingController = AudioController::SoundStudio.new
        @presentationImageField.setImage(NSImage.imageNamed(ERROR_ICON))
        @recordingImageField.setImage(NSImage.imageNamed(ERROR_ICON))

        @startRecordingButton.setEnabled(false)
        @stopRecordingButton.setEnabled(false)
        
        startDiscoveryTimer(15)
        checkPresentationStatus
        checkRecordingStatus
        
        if(@presentationReady && @recordingReady)
            @startRecordingButton.setEnabled(true)
        end
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
        @startRecordingButton.setTitle("Pause Recording")
        @stopRecordingButton.setEnabled(true)
        
    end
    
    def stopRecording(sender)
    end
    
    def discoveryTimerHandler(userInfo)
        if(@presentationReady && @recordingReady)
            stopDiscoveryTimer()
            @startRecordingButton.setEnabled(true)
        else
            @startRecordingButton.setEnabled(false)
            checkPresentationStatus
            checkRecordingStatus
        end
    end
    
    def checkRecordingStatusButton(sender)
        puts "Checking status..."
        checkPresentationStatus
        checkRecordingStatus
        if(@presentationReady && @recordingReady)
            @startRecordingButton.setEnabled(true)
        else
            @startRecordingButton.setEnabled(false)
        end
    end
    
    def checkRecordingStatus
        @recordingReady = false

        if(@recordingController.isRunning?)
            @recordingApplicationLabel.setStringValue("Controlling " + @recordingController.getApplicationName())

            if(@recordingController.isReadyToRecord?)
                @recordingApplicationStatus.setStringValue("Recording to: " + @recordingController.getFileName())
                @recordingImageField.setImage(NSImage.imageNamed(GOOD_ICON))
                @recordingReady = true
            else
                @recordingApplicationStatus.setStringValue("Not Ready to record, please create a new file")
                @recordingImageField.setImage(NSImage.imageNamed(WARNING_ICON))
            end 
            
        else
            @recordingApplicationLabel.setStringValue("Waiting...")
            @recordingApplicationStatus.setStringValue("...for SoundStudio to launch")
            @recordingImageField.setImage(NSImage.imageNamed(WARNING_ICON))
        
        end
    end
    
    def checkPresentationStatus
        # initialize if we need to
        
        @presentationObserver = PresentationObservation::Discover.getPresentationObserver(nil)
        
        # if initialzed then poll..
        if(!@presentationObserver.nil?)
            @presentationImageField.setImage(NSImage.imageNamed(GOOD_ICON))
            @presentationApplicationLabel.setStringValue("Observing " + @presentationObserver.getApplicationName())
            if(@presentationObserver.hasPresentationOpen?)
                @presentationApplicationStatus.setStringValue("Presentation: #{@presentationObserver.getPresentationName()}")
                @presentationReady = true
            else
                @presentationApplicationStatus.setStringValue("Waiting for presentation to open")
                @presentationImageField.setImage(NSImage.imageNamed(WARNING_ICON))
            end
        else
            @presentationImageField.setImage(NSImage.imageNamed(WARNING_ICON))
            @presentationApplicationLabel.setStringValue("Waiting...")
            @presentationApplicationStatus.setStringValue("...for PowerPoint or Keynote to Launch")
        end
    end
    
end

