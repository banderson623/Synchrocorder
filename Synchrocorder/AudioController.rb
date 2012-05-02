if defined?(framework)
    framework "ScriptingBridge"
end


module AudioController
    class Base        
        attr_reader :app
        
        def initialize
            @app=nil 
            setBitRateInKbps(96)
            @systemEvents = SBApplication.applicationWithBundleIdentifier("com.apple.SystemEvents")
            isRunning?
            @running = false
        end
        
        
        # ---- INTERFACE
        def launch!
            SBApplication.applicationWithBundleIdentifier(getBundleIdentifier).activate
        end
        
        def isRunning?
            if(!@running)
                @running = !(@systemEvents.processes.detect{|p|p.name.include?(getApplicationName)}).nil?
                if(@running)
                    @app  = SBApplication.applicationWithBundleIdentifier(getBundleIdentifier)
                end
            end
            @running
        end
        
        def isReadyToRecord?
            false
        end
        
        def startRecording!
            false
        end
        
        def isRecording?
            false
        end
        
        def insertMarkerNowWithLabel(label)
            false
        end
        
        def insertMarkerAtTimeWithLabel(time,label)
            false
        end
        
        def stopRecording!
            false
        end
        
        def getFileName
            ""
        end
        
        
        def setTitle(title)
            false
        end
        
        def getTitle
            ""
        end
        
        def setAuthor(author)
            false
        end
        
        def getAuthor
            ""
        end
        
        def setAlbum(album)
            false
        end
        
        def getAlbum
            ""
        end
        
        def saveAsAACFileAt(path)
        end
        
        def setBitRateInKbps(kps); @bitrate=kps * 1024; end
        
        
        private
        
        def getBundleIdentifier; "....."; end
        def getApplicationName; "...."; end; 
        
    end

    
    class SoundStudio < Base
        def getBundleIdentifier; "com.felttip.SoundStudio.trial"; end
        def getApplicationName; "Sound Studio"; end;
        
        def isRecording?
            isRunning? && @app.isRecording
        end
        
        def isReadyToRecord?
            isRunning? && @app.documents.size > 0 && !isRecording?
        end
        
        def insertMarkerNowWithLabel(label)
            if(isRecording?)
                markerTime = @app.documents[0].sampleCount
                marker = @app.classForScriptingClass("marker").alloc.init
                @app.documents[0].markers.addObject(marker)
                marker.setName(label)
                marker.setPosition(markerTime)
            end
        end
        
        def getFileName
            if(isRunning? && @app.documents.size > 0)
                @app.documents[0].name
            else
                ""
            end
        end
        
        def stopRecording
            if(isRecording?)
                @app.documents[0].pause
                @app.documents[0].stop
                return true
            else
                return false
            end
        end
        
        def startRecording!
            @app.documents[0].record
        end
        
        def getMarkersAsAnArray
            all = @app.classForScriptingClass("sound selection").alloc.init
            @app.addObject(all)
            #all.startTime(0)
            ##all.endTime(@app.documents[0].totalTime)
            #all.firstTrack(0)
            #all.trackCount(2)
            all.copy()
            copied = IO.popen('pbpaste', 'r+').read
            if(copied)
                puts copied.split("\n")
            end
        end
        
        def saveAsAACFileAt(path)
            # Have a document
            if(isRunning? && @app.documents.size > 0)
                #set the bitrate at 96kps.
                @app.documents[0].bitRate=@bitrate
                @app.documents[0].saveIn(path, as:"AAC (m4a) Audio")
            end
        end
    end
    
end


ss = AudioController::SoundStudio.new
#puts "Markers"
#puts ss.getMarkersAsAnArray
#puts "Is running: #{ss.isRunning?}";
#puts "Is recording: #{ss.isRecording?}";
#puts "Is ready to record: #{ss.isReadyToRecord?}";
#puts "Is filename: #{ss.getFileName}";
#puts "Is start Recording: #{ss.startRecording!}";
#puts "Is recording: #{ss.isRecording?}";
#puts "Adding Marker"; ss.insertMarkerNowWithLabel("Hello")


