#
#  AppDelegate.rb
#  Synchrocorder
#
#  Created by Brian Anderson on 4/4/12.
#  Copyright 2012 Aeroflex. All rights reserved.
#

framework "ScriptingBridge"
framework "AVFoundation"  

class AppDelegate
    
    attr_accessor :window
    attr_accessor :timeCode #outlet
    attr_accessor :loadingMeter #outlet
    
    
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
        puts "loading!"
        @time = 0.0
        updateTime
        #initRecordingTest()
    end
    
    
    def initRecordingTest
        
        
        err = NSError.alloc.init
        errP = Pointer.new("@")
        url = NSURL.fileURLWithPath("/Users/brian_anderson/Desktop/Slide Recorder/fromRuby.m4a")
        #if(url.fileReferenceURL?)
            settings =  NSDictionary.alloc.initWithDictionary({
                                                              :AVNumberOfChannelsKey => 2,
                                                              :AVSampleRateKey => 44100.0,
                                                              :AVFormatIDKey => KAudioFormatAppleIMA4})
            
            puts settings.inspect
            recorder = AVAudioRecorder.alloc
            recorder.initWithURL(url, 
                                                           :settings => settings, 
                                                           :error => errP)
            
            is_ready = recorder.prepareToRecord()
            if(!is_ready)
                NSAlert.alertWithError(errP[0]).runModal
            end
        #else
            puts "Not a file!"
        #end
        puts is_ready
        
    end
    
    
    
    def startPauseRecording(sender)
        
        if @timer.nil?
           
           
            @timer = NSTimer
            .scheduledTimerWithTimeInterval(0.1,
                                            target: self,
                                            selector: "timerHandler:",
                                            userInfo: nil,
                                            repeats: true)
            sender.setTitle("Pause Recording")
        else
            @timer.invalidate
            @timer= nil
            sender.setTitle("Start Recording")

        end
        
    end
    
    
    def stopRecording(sender)
        if @timer
            @time = 0.0
            @timer.invalidate
            @timer = nil
            updateTime
            @time.nil
        end
    end
    
    def timerHandler(userInfo)
        @time += 0.1
        updateTime
    end
    
    
    def updateTime
        string = sprintf("%.1f", @time)
        timeCode.setStringValue(string)
    end
end

