require 'xcodeproj'
require 'pathname'

puts "=======begin argumens======="
puts ARGV
puts "=======end argumens======="

$dy_is_jekins = true

$dy_project = Xcodeproj::Project.open("XX.xcodeproj")

$dy_target = $dy_project.native_targets.detect { |target|
    target.name == "XX"
}

#引入 dy_addbuild_channel.rb 来进行后续处理
require './ToolChain/ruby/dy_addbuild_channel.rb'

def parseChannelFromArgv(prefix)

	ARGV.each do |argv|
	    
	    channelCmd = prefix

	    if argv.include?channelCmd
	        return argv[channelCmd.length , 100]
	    end
	end

	return ""
end

$ARGV_BETA = parseChannelFromArgv("-isbeta-")
add_channelPreprocess($ARGV_BETA, "Release")
add_channelPreprocess($ARGV_BETA, "Snapshot")
add_channelPreprocess($ARGV_BETA, "Debug")


$ARGV_CHANNEL = parseChannelFromArgv("-channel-")
add_channelPreprocess($ARGV_CHANNEL, "Release")
add_channelPreprocess($ARGV_CHANNEL, "Snapshot")
add_channelPreprocess($ARGV_CHANNEL, "Debug")
