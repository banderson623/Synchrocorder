if defined?(framework)
    framework "ScriptingBridge"
end


module AudioController
    class Base
        


        
        def initialize
            @app=nil 
            @systemEvents = SBApplication.applicationWithBundleIdentifier("com.apple.SystemEvents")
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
        
        private
        
        def getBundleIdentifier; "....."; end
        def getApplicationName; "...."; end; 
        
    end

    
    class SoundStudio < Base
        def getBundleIdentifier; "com.felttip.SoundStudio.trial"; end
        def getApplicationName; "Sound Studio"; end;
        
        def isRecording?
            isRunning? && @app.recording?
        end
        
        def isReadyToRecord?
            isRunning? && @app.documents.size > 0 && !isRecording?
        end
        
        def insertMarkerNowWithLabel(label)
            false
            if(isRecording?)
                # tell front document
                #@app.document[0]
                #set markerTime to sample count
                marterTime = @app.document[0].sampleCount
                marker = @app.classForScriptingClass("marker")
                marker.name = label
                marker.position = markerTime
                #make new marker with properties {position:markerTime, name:markerName}
                #end tell
            end
        end
        
        def getFileName
            if(isRunning? && @app.documents.size > 0)
                @app.documents[0].name
            else
                ""
            end
        end
        
        def startRecording!
           @app.documents[0].record
        end
    end
    
end


ss = AudioController::SoundStudio.new
puts "Is running: #{ss.isRunning?}";
puts "Is recording: #{ss.isRecording?}";
puts "Is ready to record: #{ss.isReadyToRecord?}";

puts "Is filename: #{ss.getFileName}";

#puts "Is start Recording: #{ss.startRecording!}";
puts "Is recording: #{ss.isRecording?}";


