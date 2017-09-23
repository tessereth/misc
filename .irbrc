# Require RubyGems by default.
require 'rubygems'

# Activate auto-completion.
require 'irb/completion'

# Use the simple prompt if possible.
IRB.conf[:PROMPT_MODE] = :SIMPLE if IRB.conf[:PROMPT_MODE] == :DEFAULT

# Setup permanent history.
IRB.conf[:SAVE_HISTORY] = 1000
