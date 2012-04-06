#
# A simple observer to check if 
# A program is loaded and/or presenting
# and if it has changed to do something....

if defined?(framework)
    framework "ScriptingBridge"
end

module PresentationObservation
    class Base
        
        def initialize
            @app=nil 
            #@systemEvents = SBApplication.applicationWithBundleIdentifier("com.apple.SystemEvents")
            initializeIfRunning
        end
        
        def getBundleIdentifier; -1; end
        
        def initializeIfRunning
            if(isRunning?)
                @app  = SBApplication.applicationWithBundleIdentifier(getBundleIdentifier)
            end
        end
    
        # Interface ---------------------
        def launch
            if(!isRunning?)
                @app  = SBApplication.applicationWithBundleIdentifier(getBundleIdentifier)
                @app.activate
            end
        end
        
        # check if the app is running
        def isRunning?
            `ps aux | grep -i '#{getApplicationName}'`.split("\n").size > 2
            #!(@systemEvents.processes.detect{|p|p.name.include?(getApplicationName)}).nil?
        end
        
        # Check if a window is open
        def hasPresentationOpen?
            return false
        end
        
        def getPresentationName
            return ""
        end
        
        # check if presenting
        def isPresenting?
            false 
        end
        
        def getSlideNumber
            -1
        end
    end

    
    
    
    class Keynote < Base
        def getBundleIdentifier; "com.apple.iWork.Keynote"; end
        def getApplicationName; "Keynote"; end;
        
        def isPresenting?
            isRunning? && false && @app.playing
        end
        
        def hasPresentationOpen?
            isRunning? && @app.slideshows.size > 0
        end
        
        def getPresentationName
            if hasPresentationOpen?
                @app.slideshows[0].name
            else
                ""
            end
        end
        
        def getSlideNumber
            number = 0
            if(isRunning? && hasPresentationOpen?)
                number = @app.slideshows[0].currentSlide.slideNumber
            end
            
            return number
        end
    end
        
        
    class PowerPoint < Base
        def getBundleIdentifier; "com.microsoft.PowerPoint"; end
        def getApplicationName; "PowerPoint"; end;

        def hasPresentationOpen?
            isRunning? && @app.presentations.size > 0
        end
        
        def getPresentationName
            if hasPresentationOpen?
                @app.activePresentation.name
            else 
                ""
            end
        end
        
        def isPresenting?
            isRunning? && @app.activePresentation && (@app.activePresentation.slideShowWindow.slideshowView.slideState != 0)
        end
        
        def getSlideNumber
            if isRunning?
               @app.activePresentation.slideShowWindow.slideshowView.currentShowPosition
            else
               0
            end
        end
    end
    
    class Discover
        # Will return a new Powerpoint or new Keynote
        def self.getPresentationObserver(default=0)
            options = []
            options << PowerPoint.new
            options << Keynote.new

            selected = options.detect{|p| p.isPresenting?}
            # Give preference to which has a presentation open
            if(selected.nil?)
                selected = options.detect{|p| p.hasPresentationOpen?}
                if(selected.nil?)
                    selected = options.detect{|p| p.isRunning?}
                end
            end
            if selected.nil? 
                return (default.nil? || default >= options.size) ? nil : options[default] 
            else 
                return selected
            end
        end
    end
end